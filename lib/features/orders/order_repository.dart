import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';

import '../cart/cart_item_model.dart';

class OrderRepository {
  Future<void> saveOrder({
    required List<CartItem> cartItems,
    required double subtotal,
    required double discountAmount,
    required double total,
    required String paymentMethod,
  }) async {
    await IsarService.isar.writeTxn(() async {
      // =====================
      // SAVE ORDER
      // =====================

      final order = OrderEntity()
        ..subtotal = subtotal
        ..discountAmount = discountAmount
        ..total = total
        ..paymentMethod = paymentMethod
        ..createdAt = DateTime.now();

      final orderId =
      await IsarService.isar.orderEntitys.put(order);

      // =====================
      // SAVE ITEMS
      // =====================

      for (final cartItem in cartItems) {
        final orderItem = OrderItemEntity()
          ..orderId = orderId
          ..productName = cartItem.product.name
          ..basePrice = cartItem.product.price
          ..quantity = cartItem.quantity
          ..subtotal = cartItem.subtotal;

        final orderItemId =
        await IsarService.isar.orderItemEntitys
            .put(orderItem);

        // =====================
        // SAVE ADDONS
        // =====================

        for (final addon in cartItem.addons) {
          final orderAddon = OrderAddonEntity()
            ..orderItemId = orderItemId
            ..addonName = addon.name
            ..price = addon.price
            ..quantity = addon.quantity
            ..subtotal = addon.subtotal;

          await IsarService.isar.orderAddonEntitys
              .put(orderAddon);
        }
      }
    });
  }
}