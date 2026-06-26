import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/dashboard_provider.dart';
import '../orders/order_provider.dart';
import '../cart/cart_provider.dart';
import '../discounts/discount_model.dart';
import 'checkout_model.dart';
import '../sales/sales_provider.dart';
import '../inventory/inventory_repository.dart';
import '../auth/auth_provider.dart';
import '../sync/sync_provider.dart';

final inventoryRepositoryProvider = Provider((ref) => InventoryRepository());

final checkoutProvider =
StateNotifierProvider<CheckoutController, Order?>(
      (ref) => CheckoutController(ref),
);

class CheckoutController extends StateNotifier<Order?> {
  final Ref ref;

  CheckoutController(this.ref) : super(null);

  Future<void> checkout({
    required PaymentMethod paymentMethod,
    required DiscountType discountType,
  }) async {
    final cartItems = ref.read(cartProvider);
    final cartController = ref.read(cartProvider.notifier);

    final subtotal = cartItems.fold<double>(
      0,
          (sum, item) => sum + item.subtotal,
    );

    final discountAmount =
        subtotal * discountType.rate;

    final total = subtotal - discountAmount;

    final repository =
      ref.read(orderRepositoryProvider);

    final inventoryRepository =
      ref.read(inventoryRepositoryProvider);
    
    final cashier = ref.read(authProvider);

    final savedOrderId =
    await repository.saveOrder(
      cartItems: cartItems,
      subtotal: subtotal,
      discountAmount: discountAmount,
      total: total,
      paymentMethod: paymentMethod.name,
      cashierId: cashier?.id,
    );

    // Deduct Inventory
    for (final item in cartItems) {
      await inventoryRepository.deductInventory(item.product.id, item.quantity);
    }

    final order = Order(
      id: savedOrderId.toString(),
      items: cartItems,
      subtotal: subtotal,
      discountAmount: discountAmount,
      total: total,
      paymentMethod: paymentMethod,
      discountType: discountType,
      createdAt: DateTime.now(),
    );

    // ==========================
    // SAVE TO ISAR
    // ==========================


    ref.invalidate(dashboardProvider);
    ref.invalidate(salesHistoryProvider);

    // Trigger background sync
    ref.read(syncProvider.notifier).syncNow();

    // ==========================
    // UPDATE STATE
    // ==========================

    state = order;

    // ==========================
    // CLEAR CART
    // ==========================

    cartController.clearCart();
  }
}