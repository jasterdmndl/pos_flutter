import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
import '../../core/services/supabase_service.dart';
import '../../core/utils/logger.dart';

class SyncRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> syncPendingOrders() async {
    final pendingOrders = await IsarService.isar.orderEntitys
        .filter()
        .isSyncedEqualTo(false)
        .findAll();

    if (pendingOrders.isEmpty) {
      AppLogger.d('No pending orders to sync.');
      return;
    }

    AppLogger.i('Found ${pendingOrders.length} pending orders. Starting sync...');

    for (final order in pendingOrders) {
      try {
        await _syncOrder(order);
        AppLogger.i('Successfully synced order ${order.id}');
      } catch (e) {
        AppLogger.e('Failed to sync order ${order.id}: $e');
        rethrow; // Rethrow so the Notifier knows there was a failure
      }
    }
  }

  Future<void> syncOrderById(int orderId) async {
    final order = await IsarService.isar.orderEntitys.get(orderId);
    if (order != null && !order.isSynced) {
      await _syncOrder(order);
    }
  }

  Future<void> _syncOrder(OrderEntity order) async {
    // 1. Sync Order - Use insert() instead of upsert() for BIR Compliance
    // This avoids triggering "Update" rules during the initial upload.
    final orderData = {
      'id': order.id,
      'subtotal': order.subtotal,
      'discount_amount': order.discountAmount,
      'total': order.total,
      'vatable_sales': order.vatableSales,
      'vat_amount': order.vatAmount,
      'exempt_sales': order.exemptSales,
      'payment_method': order.paymentMethod,
      'amount_received': order.amountReceived,
      'change_due': order.changeDue,
      'reference_number': order.referenceNumber,
      'created_at': order.createdAt.toIso8601String(),
      'cashier_id': order.cashierId, // Use the stored Supabase UUID string
      'is_voided': order.isVoided,
      'void_reason': order.voidReason,
    };

    // Use upsert() to handle retries gracefully and avoid "duplicate key" errors
    await _supabase.from('orders').upsert(orderData);

    // 2. Sync Items
    final items = await IsarService.isar.orderItemEntitys
        .filter()
        .orderIdEqualTo(order.id)
        .findAll();

    for (final item in items) {
      final itemData = {
        'id': item.id,
        'order_id': item.orderId,
        'product_name': item.productName,
        'base_price': item.basePrice,
        'quantity': item.quantity,
        'subtotal': item.subtotal,
      };
      
      try {
        await _supabase.from('order_items').upsert(itemData);
      } catch (e) {
        AppLogger.e('Failed to sync item ${item.id} for order ${order.id}: $e');
        rethrow;
      }

      // 3. Sync Addons
      final addons = await IsarService.isar.orderAddonEntitys
          .filter()
          .orderItemIdEqualTo(item.id)
          .findAll();

      for (final addon in addons) {
        final addonData = {
          'id': addon.id,
          'order_item_id': addon.orderItemId,
          'addon_name': addon.addonName,
          'price': addon.price,
          'quantity': addon.quantity,
          'subtotal': addon.subtotal,
        };
        try {
          await _supabase.from('order_item_addons').upsert(addonData);
        } catch (e) {
          AppLogger.e('Failed to sync addon for item ${item.id}: $e');
          rethrow;
        }
      }
    }

    // 4. Mark as Synced
    await IsarService.isar.writeTxn(() async {
      final freshOrder = await IsarService.isar.orderEntitys.get(order.id);
      if (freshOrder != null) {
        freshOrder.isSynced = true;
        await IsarService.isar.orderEntitys.put(freshOrder);
        // Important: Notify Isar that a change occurred for the watch stream
      }
    });
    
    // Explicitly log after transaction completion to ensure persistence
    AppLogger.d('Order ${order.id} sync status successfully persisted to Isar');
  }

  // ======================
  // CROSS-DEVICE PULL-DOWN (per cashier)
  // ======================
  /// Downloads this cashier's orders from Supabase into the local Isar so the
  /// same account sees consistent history across devices. Downloaded rows are
  /// marked [isSynced] = true so they are never re-uploaded and never inflate
  /// the "pending sync" count. Idempotent by the globally-unique order [id].
  Future<void> pullCashierOrders(String? cashierId, {int lookbackDays = 90}) async {
    if (cashierId == null || !SupabaseService.isInitialized) return;

    final now = DateTime.now();
    var since = now.subtract(Duration(days: lookbackDays));

    // Only fetch orders newer than what we already hold locally for this cashier
    final latestLocal = await IsarService.isar.orderEntitys
        .filter()
        .cashierIdEqualTo(cashierId)
        .sortByCreatedAtDesc()
        .findFirst();
    if (latestLocal != null && latestLocal.createdAt.isAfter(since)) {
      since = latestLocal.createdAt;
    }

    final ordersResponse = await _supabase
        .from('orders')
        .select()
        .eq('cashier_id', cashierId)
        .gte('created_at', since.toIso8601String())
        .order('created_at', ascending: true);

    final List<dynamic> cloudOrders = ordersResponse as List;

    // Build the insert set first (network I/O kept outside the write transaction)
    final List<_PullOrderData> toInsert = [];
    for (final o in cloudOrders) {
      final cloudId = (o['id'] as num).toInt();

      // Idempotency: skip if this order already exists locally
      final existing = await IsarService.isar.orderEntitys.get(cloudId);
      if (existing != null) continue;

      final order = OrderEntity()
        ..id = cloudId
        ..subtotal = (o['subtotal'] as num?)?.toDouble() ?? 0
        ..discountAmount = (o['discount_amount'] as num?)?.toDouble() ?? 0
        ..total = (o['total'] as num?)?.toDouble() ?? 0
        ..vatableSales = (o['vatable_sales'] as num?)?.toDouble() ?? 0
        ..vatAmount = (o['vat_amount'] as num?)?.toDouble() ?? 0
        ..exemptSales = (o['exempt_sales'] as num?)?.toDouble() ?? 0
        ..paymentMethod = (o['payment_method'] as String?) ?? 'cash'
        ..amountReceived = (o['amount_received'] as num?)?.toDouble() ?? 0
        ..changeDue = (o['change_due'] as num?)?.toDouble() ?? 0
        ..referenceNumber = o['reference_number'] as String?
        ..createdAt = DateTime.parse(o['created_at'] as String)
        ..cashierId = o['cashier_id'] as String?
        ..isVoided = (o['is_voided'] as bool?) ?? false
        ..voidReason = o['void_reason'] as String?
        ..isSynced = true; // already in the cloud -> never re-upload

      final itemsResponse = await _supabase
          .from('order_items')
          .select()
          .eq('order_id', cloudId);
      final List<dynamic> cloudItems = itemsResponse as List;

      final itemData = <_PullItemData>[];
      for (final it in cloudItems) {
        final item = OrderItemEntity()
          ..productName = (it['product_name'] as String?) ?? 'Unknown'
          ..basePrice = (it['base_price'] as num?)?.toDouble() ?? 0
          ..quantity = (it['quantity'] as num?)?.toInt() ?? 0
          ..subtotal = (it['subtotal'] as num?)?.toDouble() ?? 0;

        final addonsResponse = await _supabase
            .from('order_item_addons')
            .select()
            .eq('order_item_id', (it['id'] as num).toInt());
        final List<dynamic> cloudAddons = addonsResponse as List;

        final addons = cloudAddons.map((ad) => OrderAddonEntity()
          ..addonName = (ad['addon_name'] as String?) ?? ''
          ..price = (ad['price'] as num?)?.toDouble() ?? 0
          ..quantity = (ad['quantity'] as num?)?.toInt() ?? 0
          ..subtotal = (ad['subtotal'] as num?)?.toDouble() ?? 0
        ).toList();

        itemData.add(_PullItemData(item, addons));
      }

      toInsert.add(_PullOrderData(order, itemData));
    }

    if (toInsert.isEmpty) {
      AppLogger.d('Pull: nothing new to download for cashier $cashierId.');
      return;
    }

    await IsarService.isar.writeTxn(() async {
      for (final po in toInsert) {
        final localOrderId = await IsarService.isar.orderEntitys.put(po.order);
        for (final pi in po.items) {
          pi.item.orderId = localOrderId;
          final localItemId = await IsarService.isar.orderItemEntitys.put(pi.item);
          for (final ad in pi.addons) {
            ad.orderItemId = localItemId;
            await IsarService.isar.orderAddonEntitys.put(ad);
          }
        }
      }
    });

    AppLogger.i('Pull: downloaded ${toInsert.length} order(s) for cashier $cashierId.');
  }
}

class _PullItemData {
  final OrderItemEntity item;
  final List<OrderAddonEntity> addons;
  _PullItemData(this.item, this.addons);
}

class _PullOrderData {
  final OrderEntity order;
  final List<_PullItemData> items;
  _PullOrderData(this.order, this.items);
}
