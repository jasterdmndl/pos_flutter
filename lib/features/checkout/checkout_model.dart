import '../cart/cart_item_model.dart';
import '../discounts/discount_model.dart';

enum PaymentMethod {
  cash,
  gcash,
}

class Order {
  final String id;
  final List<CartItem> items;

  final double subtotal;
  final double discountAmount;
  final double total;

  final PaymentMethod paymentMethod;
  final DiscountType discountType;

  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.paymentMethod,
    required this.discountType,
    required this.createdAt,
  });
}