import '../products/product_model.dart';
import 'cart_addon_model.dart';

class CartItem {
  final Product product;
  final int quantity;
  final List<CartAddon> addons;

  const CartItem({
    required this.product,
    required this.quantity,
    this.addons = const [],
  });

  double get addonTotal {
    return addons.fold(
      0,
          (sum, addon) => sum + addon.subtotal,
    );
  }

  double get unitPrice {
    return product.price + addonTotal;
  }

  double get subtotal {
    return unitPrice * quantity;
  }
}