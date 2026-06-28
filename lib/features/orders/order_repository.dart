import 'package:isar/isar.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
import '../../core/database/collections/product_entity.dart';
import '../../core/database/collections/ingredient_entity.dart';
import '../../core/database/collections/product_ingredient_entity.dart';

import '../cart/cart_item_model.dart';

class OrderRepository {
  Future<int> saveOrder({
    required List<CartItem> cartItems,
    required double subtotal,
    required double discountAmount,
    required double total,
    required double vatableSales,
    required double vatAmount,
    required double exemptSales,
    required String paymentMethod,
    int? cashierId,
  }) async {
    return await IsarService.isar.writeTxn(() async {
      // 1. Save Order
      final order = OrderEntity()
        ..subtotal = subtotal
        ..discountAmount = discountAmount
        ..total = total
        ..vatableSales = vatableSales
        ..vatAmount = vatAmount
        ..exemptSales = exemptSales
        ..paymentMethod = paymentMethod
        ..createdAt = DateTime.now()
        ..cashierId = cashierId;

      final orderId = await IsarService.isar.orderEntitys.put(order);

      // 2. Save Items
      for (final cartItem in cartItems) {
        final orderItem = OrderItemEntity()
          ..orderId = orderId
          ..productName = cartItem.product.name
          ..basePrice = cartItem.product.price
          ..quantity = cartItem.quantity
          ..subtotal = cartItem.subtotal;

        final orderItemId = await IsarService.isar.orderItemEntitys.put(orderItem);

        // 3. Save Addons
        for (final addon in cartItem.addons) {
          final orderAddon = OrderAddonEntity()
            ..orderItemId = orderItemId
            ..addonName = addon.name
            ..price = addon.price
            ..quantity = addon.quantity
            ..subtotal = addon.subtotal;

          await IsarService.isar.orderAddonEntitys.put(orderAddon);
        }
      }
      return orderId;
    });
  }

  Future<void> voidOrder(int orderId, String reason) async {
    await IsarService.isar.writeTxn(() async {
      final order = await IsarService.isar.orderEntitys.get(orderId);
      if (order != null && !order.isVoided) {
        order.isVoided = true;
        order.voidReason = reason;
        await IsarService.isar.orderEntitys.put(order);

        // Restock Inventory
        final items = await IsarService.isar.orderItemEntitys
            .filter()
            .orderIdEqualTo(orderId)
            .findAll();

        for (final item in items) {
          // We need the product ID. Let's find it by name for now, 
          // or ideally OrderItem should store productId.
          final product = await IsarService.isar.productEntitys
              .filter()
              .nameEqualTo(item.productName)
              .findFirst();
          
          if (product != null) {
            final recipes = await IsarService.isar.productIngredientEntitys
                .filter()
                .productIdEqualTo(product.id)
                .findAll();

            for (final recipe in recipes) {
              final ingredient = await IsarService.isar.ingredientEntitys.get(recipe.ingredientId);
              if (ingredient != null) {
                ingredient.stockQuantity += (recipe.amountUsed * item.quantity);
                await IsarService.isar.ingredientEntitys.put(ingredient);
              }
            }
          }
        }
      }
    });
  }

  Future<List<OrderEntity>> getSalesHistory() async {
    return await IsarService.isar.orderEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }
}
