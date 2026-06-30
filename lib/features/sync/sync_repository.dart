import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';

class SyncRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> syncPendingOrders() async {
    final pendingOrders = await IsarService.isar.orderEntitys
        .filter()
        .isSyncedEqualTo(false)
        .findAll();

    for (final order in pendingOrders) {
      try {
        await _syncOrder(order);
      } catch (e) {
        print('Failed to sync order ${order.id}: $e');
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
    // 1. Sync Order
    final orderData = {
      'id': order.id,
      'subtotal': order.subtotal,
      'discount_amount': order.discountAmount,
      'total': order.total,
      'payment_method': order.paymentMethod,
      'created_at': order.createdAt.toIso8601String(),
      'cashier_id': order.cashierId,
      'is_voided': order.isVoided,
      'void_reason': order.voidReason,
    };

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
      await _supabase.from('order_items').upsert(itemData);

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
        await _supabase.from('order_item_addons').upsert(addonData);
      }
    }

    // 4. Mark as Synced
    await IsarService.isar.writeTxn(() async {
      order.isSynced = true;
      await IsarService.isar.orderEntitys.put(order);
    });
  }
}
