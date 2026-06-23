import '../products/product_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  double get subtotal {
    return product.price * quantity;
  }
}