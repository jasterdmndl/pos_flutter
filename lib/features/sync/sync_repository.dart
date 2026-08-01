import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
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
    await _supabase.from('orders').insert(orderData);

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
      await _supabase.from('order_items').insert(itemData);

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
        await _supabase.from('order_item_addons').insert(addonData);
      }
    }

    // 4. Mark as Synced
    await IsarService.isar.writeTxn(() async {
      final freshOrder = await IsarService.isar.orderEntitys.get(order.id);
      if (freshOrder != null) {
        freshOrder.isSynced = true;
        await IsarService.isar.orderEntitys.put(freshOrder);
        AppLogger.d('Order ${order.id} marked as isSynced=true in local DB');
      } else {
        AppLogger.w('Could not find order ${order.id} to mark as synced');
      }
    });
  }
}
