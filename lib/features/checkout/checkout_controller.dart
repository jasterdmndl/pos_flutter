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
    double amountReceived = 0,
    double changeDue = 0,
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

    // BIR VAT Calculations (12% VAT)
    final double vatableSales;
    final double vatAmount;
    final double exemptSales;

    if (discountType.isVatExempt) {
      vatableSales = 0;
      vatAmount = 0;
      exemptSales = total;
    } else {
      vatableSales = total / 1.12;
      vatAmount = total - vatableSales;
      exemptSales = 0;
    }

    final repository = ref.read(orderRepositoryProvider);
    final inventoryRepository = ref.read(inventoryRepositoryProvider);
    final cashier = ref.read(authProvider);

    final savedOrderId = await repository.saveOrder(
      cartItems: cartItems,
      subtotal: subtotal,
      discountAmount: discountAmount,
      total: total,
      vatableSales: vatableSales,
      vatAmount: vatAmount,
      exemptSales: exemptSales,
      paymentMethod: paymentMethod.name,
      amountReceived: amountReceived,
      changeDue: changeDue,
      cashierId: cashier?.id,
    );

    // Deduct Inventory
    for (final item in cartItems) {
      await inventoryRepository.deductInventory(item.product.id, item.quantity);
    }

    final order = Order(
      id: savedOrderId.toString(),
      items: List.from(cartItems),
      subtotal: subtotal,
      discountAmount: discountAmount,
      total: total,
      paymentMethod: paymentMethod,
      discountType: discountType,
      amountReceived: amountReceived,
      changeDue: changeDue,
      createdAt: DateTime.now(),
    );

    ref.invalidate(dashboardProvider);
    ref.invalidate(salesHistoryProvider);

    // Instant Cloud Push (Directly trigger sync for this specific order)
    try {
      await ref.read(syncRepositoryProvider).syncOrderById(savedOrderId);
    } catch (e) {
      print('Instant sync failed, falling back to background queue: $e');
      ref.read(syncProvider.notifier).syncNow();
    }

    state = order;
    cartController.clearCart();
  }
}
