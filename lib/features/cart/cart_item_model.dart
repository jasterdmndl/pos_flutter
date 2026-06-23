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

  CartItem copyWith({
    Product? product,
    int? quantity,
    List<CartAddon>? addons,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addons: addons ?? this.addons,
    );
  }

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

  bool isSameAs(CartItem other) {
    if (product.id != other.product.id) return false;

    if (addons.length != other.addons.length) return false;

    for (final addon in addons) {
      final match = other.addons.any(
            (a) =>
        a.name == addon.name &&
            a.quantity == addon.quantity &&
            a.price == addon.price,
      );

      if (!match) return false;
    }

    return true;
  }
}