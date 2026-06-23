import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cart/cart_provider.dart';
import '../cart/cart_item_model.dart';
import '../discounts/discount_model.dart';
import 'checkout_model.dart';

final checkoutProvider =
StateNotifierProvider<CheckoutController, Order?>(
      (ref) => CheckoutController(ref),
);

class CheckoutController extends StateNotifier<Order?> {
  final Ref ref;

  CheckoutController(this.ref) : super(null);

  void checkout({
    required PaymentMethod paymentMethod,
    required DiscountType discountType,
  }) {
    final cartItems = ref.read(cartProvider);
    final cartController = ref.read(cartProvider.notifier);

    final subtotal = cartItems.fold<double>(
      0,
          (sum, item) => sum + item.subtotal,
    );

    final discountAmount =
        subtotal * discountType.rate;

    final total = subtotal - discountAmount;

    final order = Order(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      items: cartItems,
      subtotal: subtotal,
      discountAmount: discountAmount,
      total: total,
      paymentMethod: paymentMethod,
      discountType: discountType,
      createdAt: DateTime.now(),
    );

    state = order;

    cartController.clearCart();
  }
}