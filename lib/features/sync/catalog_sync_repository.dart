import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/isar_service.dart';
import '../../core/database/collections/category_entity.dart';
import '../../core/database/collections/product_entity.dart';
import '../../core/database/collections/product_addon_entity.dart';
import '../../core/database/collections/ingredient_entity.dart';
import '../../core/database/collections/product_ingredient_entity.dart';
import '../../core/services/supabase_service.dart';
import '../../core/utils/logger.dart';

/// Handles two-way sync of the shared catalog (categories, products, addons,
/// ingredients, product-ingredient recipes) across devices via Supabase.
///
/// Each local item carries a globally unique [syncId] used as the cloud primary
/// key. Cross references (product -> category, recipe -> product/ingredient) are
/// resolved through those sync ids, not the device-specific local int ids.
class CatalogSyncRepository {
  static const Uuid _uuid = Uuid();

  bool get _ready => SupabaseService.isInitialized;

  // ---------------------------------------------------------------- PUSH ----

  Future<void> upsertCategory(CategoryEntity c) async {
    if (!_ready) return;
    c.syncId ??= _uuid.v4();
    c.updatedAt = DateTime.now();
    try {
      await SupabaseService.client.from('categories').upsert({
        'id': c.syncId,
        'name': c.name,
        'is_active': c.isActive,
        'updated_at': c.updatedAt!.toIso8601String(),
        'is_deleted': false,
      });
    } catch (e) {
      AppLogger.w('Catalog push category failed: $e');
    }
  }

  Future<void> upsertAddon(ProductAddonEntity a) async {
    if (!_ready) return;
    a.syncId ??= _uuid.v4();
    a.updatedAt = DateTime.now();
    try {
      await SupabaseService.client.from('product_addons').upsert({
        'id': a.syncId,
        'name': a.name,
        'price': a.price,
        'is_per_unit': a.isPerUnit,
        'is_active': a.isActive,
        'updated_at': a.updatedAt!.toIso8601String(),
        'is_deleted': false,
      });
    } catch (e) {
      AppLogger.w('Catalog push addon failed: $e');
    }
  }

  Future<void> upsertIngredient(IngredientEntity i) async {
    if (!_ready) return;
    i.syncId ??= _uuid.v4();
    i.updatedAt = DateTime.now();
    try {
      await SupabaseService.client.from('ingredients').upsert({
        'id': i.syncId,
        'name': i.name,
        'unit': i.unit,
        'stock_quantity': i.stockQuantity,
        'updated_at': i.updatedAt!.toIso8601String(),
        'is_deleted': false,
      });
    } catch (e) {
      AppLogger.w('Catalog push ingredient failed: $e');
    }
  }

  Future<void> upsertProduct(ProductEntity p, {String? categorySyncId}) async {
    if (!_ready) return;
    p.syncId ??= _uuid.v4();
    p.updatedAt = DateTime.now();
    try {
      await SupabaseService.client.from('products').upsert({
        'id': p.syncId,
        'name': p.name,
        'price': p.price,
        'is_active': p.isActive,
        'category_sync_id': categorySyncId ?? p.categorySyncId,
        'updated_at': p.updatedAt!.toIso8601String(),
        'is_deleted': false,
      });
    } catch (e) {
      AppLogger.w('Catalog push product failed: $e');
    }
  }

  Future<void> upsertProductIngredient(
    ProductIngredientEntity link, {
    required String productSyncId,
    required String ingredientSyncId,
  }) async {
    if (!_ready) return;
    link.syncId ??= _uuid.v4();
    link.updatedAt = DateTime.now();
    try {
      await SupabaseService.client.from('product_ingredients').upsert({
        'id': link.syncId,
        'product_sync_id': productSyncId,
        'ingredient_sync_id': ingredientSyncId,
        'amount_used': link.amountUsed,
        'updated_at': link.updatedAt!.toIso8601String(),
        'is_deleted': false,
      });
    } catch (e) {
      AppLogger.w('Catalog push product_ingredient failed: $e');
    }
  }

  Future<void> softDelete(String table, String? syncId) async {
    if (!_ready || syncId == null) return;
    try {
      await SupabaseService.client
          .from(table)
          .update({
            'is_deleted': true,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', syncId);
    } catch (e) {
      AppLogger.w('Catalog soft-delete failed ($table): $e');
    }
  }

  /// Pushes every local catalog item (used after first-run seeding so other
  /// devices can adopt this device's catalog instead of creating duplicates).
  Future<void> pushAllLocal() async {
    if (!_ready) return;
    final isar = IsarService.isar;

    final cats = await isar.categoryEntitys.where().findAll();
    for (final c in cats) {
      await upsertCategory(c);
      await isar.writeTxn(() => isar.categoryEntitys.put(c));
    }

    final adds = await isar.productAddonEntitys.where().findAll();
    for (final a in adds) {
      await upsertAddon(a);
      await isar.writeTxn(() => isar.productAddonEntitys.put(a));
    }

    final ings = await isar.ingredientEntitys.where().findAll();
    for (final i in ings) {
      await upsertIngredient(i);
      await isar.writeTxn(() => isar.ingredientEntitys.put(i));
    }

    final prods = await isar.productEntitys.where().findAll();
    for (final p in prods) {
      final cat = p.categoryId != 0 ? await isar.categoryEntitys.get(p.categoryId) : null;
      await upsertProduct(p, categorySyncId: cat?.syncId);
      await isar.writeTxn(() => isar.productEntitys.put(p));
    }

    final links = await isar.productIngredientEntitys.where().findAll();
    for (final l in links) {
      final prod = await isar.productEntitys.get(l.productId);
      final ing = await isar.ingredientEntitys.get(l.ingredientId);
      if (prod?.syncId != null && ing?.syncId != null) {
        await upsertProductIngredient(
          l,
          productSyncId: prod!.syncId!,
          ingredientSyncId: ing!.syncId!,
        );
        await isar.writeTxn(() => isar.productIngredientEntitys.put(l));
      }
    }
  }

  // ----------------------------------------------------------------- PULL ----

  Future<void> pullCatalog() async {
    if (!_ready) return;
    try {
      final catRows =
          await SupabaseService.client.from('categories').select();
      final ingRows =
          await SupabaseService.client.from('ingredients').select();
      final prodRows =
          await SupabaseService.client.from('products').select();
      final addRows =
          await SupabaseService.client.from('product_addons').select();
      final linkRows =
          await SupabaseService.client.from('product_ingredients').select();

      final isar = IsarService.isar;

      final catSyncToLocal = <String, int>{};
      await isar.writeTxn(() async {
        for (final row in catRows) {
          final syncId = row['id'] as String;
          final deleted = row['is_deleted'] as bool? ?? false;
          var local = await isar.categoryEntitys
              .filter()
              .syncIdEqualTo(syncId)
              .findFirst();
          // Merge with a pre-existing local item that has no syncId yet
          // (e.g. locally-seeded) instead of creating a duplicate.
          local ??= await isar.categoryEntitys
              .filter()
              .nameEqualTo(row['name'] as String)
              .findFirst();
          if (local == null) {
            if (deleted) continue; // nothing local to delete
            local = CategoryEntity()..syncId = syncId;
          }
          if (deleted) {
            local.isDeleted = true;
          } else {
            local.name = row['name'] as String;
            local.isActive = row['is_active'] as bool? ?? true;
            local.isDeleted = false;
            local.updatedAt =
                DateTime.tryParse(row['updated_at'] as String? ?? '');
          }
          await isar.categoryEntitys.put(local);
          catSyncToLocal[syncId] = local.id;
        }
      });

      final ingSyncToLocal = <String, int>{};
      await isar.writeTxn(() async {
        for (final row in ingRows) {
          final syncId = row['id'] as String;
          final deleted = row['is_deleted'] as bool? ?? false;
          var local = await isar.ingredientEntitys
              .filter()
              .syncIdEqualTo(syncId)
              .findFirst();
          local ??= await isar.ingredientEntitys
              .filter()
              .nameEqualTo(row['name'] as String)
              .findFirst();
          if (local == null) {
            if (deleted) continue; // nothing local to delete
            local = IngredientEntity()
              ..syncId = syncId
              ..stockQuantity =
                  (row['stock_quantity'] as num?)?.toDouble() ?? 0;
          }
          if (deleted) {
            local.isDeleted = true;
          } else {
            // Sync definition only; stock quantity stays local/operational.
            local.name = row['name'] as String;
            local.unit = row['unit'] as String;
            local.isDeleted = false;
          }
          await isar.ingredientEntitys.put(local);
          ingSyncToLocal[syncId] = local.id;
        }
      });

      final prodSyncToLocal = <String, int>{};
      await isar.writeTxn(() async {
        for (final row in prodRows) {
          final syncId = row['id'] as String;
          final deleted = row['is_deleted'] as bool? ?? false;
          var local = await isar.productEntitys
              .filter()
              .syncIdEqualTo(syncId)
              .findFirst();
          local ??= await isar.productEntitys
              .filter()
              .nameEqualTo(row['name'] as String)
              .findFirst();
          if (local == null) {
            if (deleted) continue; // nothing local to delete
            local = ProductEntity()..syncId = syncId;
          }
          if (deleted) {
            local.isDeleted = true;
          } else {
            local.name = row['name'] as String;
            local.price = (row['price'] as num?)?.toDouble() ?? 0;
            local.isActive = row['is_active'] as bool? ?? true;
            local.categorySyncId = row['category_sync_id'] as String?;
            final catLocalId = local.categorySyncId != null
                ? catSyncToLocal[local.categorySyncId]
                : null;
            if (catLocalId != null) local.categoryId = catLocalId;
            local.isDeleted = false;
            local.updatedAt =
                DateTime.tryParse(row['updated_at'] as String? ?? '');
          }
          await isar.productEntitys.put(local);
          prodSyncToLocal[syncId] = local.id;
        }
      });

      await isar.writeTxn(() async {
        for (final row in addRows) {
          final syncId = row['id'] as String;
          final deleted = row['is_deleted'] as bool? ?? false;
          var local = await isar.productAddonEntitys
              .filter()
              .syncIdEqualTo(syncId)
              .findFirst();
          local ??= await isar.productAddonEntitys
              .filter()
              .nameEqualTo(row['name'] as String)
              .findFirst();
          if (local == null) {
            if (deleted) continue; // nothing local to delete
            local = ProductAddonEntity()..syncId = syncId;
          }
          if (deleted) {
            local.isDeleted = true;
          } else {
            local.name = row['name'] as String;
            local.price = (row['price'] as num?)?.toDouble() ?? 0;
            local.isPerUnit = row['is_per_unit'] as bool? ?? false;
            local.isActive = row['is_active'] as bool? ?? true;
            local.isDeleted = false;
            local.updatedAt =
                DateTime.tryParse(row['updated_at'] as String? ?? '');
          }
          await isar.productAddonEntitys.put(local);
        }
      });

      await isar.writeTxn(() async {
        for (final row in linkRows) {
          final syncId = row['id'] as String;
          final deleted = row['is_deleted'] as bool? ?? false;
          final pSync = row['product_sync_id'] as String?;
          final iSync = row['ingredient_sync_id'] as String?;
          final pLocal = pSync != null ? prodSyncToLocal[pSync] : null;
          final iLocal = iSync != null ? ingSyncToLocal[iSync] : null;

          var local = await isar.productIngredientEntitys
              .filter()
              .syncIdEqualTo(syncId)
              .findFirst();
          // Reuse an existing local recipe link (same product+ingredient) so
          // a pre-seeded link isn't duplicated by the cloud copy.
          if (local == null && pLocal != null && iLocal != null) {
            local = await isar.productIngredientEntitys
                .filter()
                .productIdEqualTo(pLocal)
                .ingredientIdEqualTo(iLocal)
                .findFirst();
          }
          if (local == null) {
            if (deleted) continue; // no local recipe to delete
            local = ProductIngredientEntity()..syncId = syncId;
          }

          if (deleted) {
            local.isDeleted = true;
            await isar.productIngredientEntitys.put(local);
            continue;
          }
          if (pLocal != null && iLocal != null) {
            local.productId = pLocal;
            local.ingredientId = iLocal;
            local.amountUsed = (row['amount_used'] as num?)?.toDouble() ?? 0;
            local.productSyncId = pSync;
            local.ingredientSyncId = iSync;
            local.isDeleted = false;
            local.updatedAt =
                DateTime.tryParse(row['updated_at'] as String? ?? '');
            await isar.productIngredientEntitys.put(local);
          }
        }
      });

      AppLogger.i('Catalog pull finished.');
    } catch (e) {
      AppLogger.w('Catalog pull failed: $e');
    }
  }
}
