import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_addon_model.dart';
import '../products/product_model.dart';
import 'cart_item_model.dart';

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);

  void addProduct(
      Product product,
      List<CartAddon> addons,
      ) {
    final newItem = CartItem(
      product: product,
      quantity: 1,
      addons: addons,
    );

    final index = state.indexWhere(
          (item) => item.isSameAs(newItem),
    );

    if (index != -1) {
      final updated = [...state];

      final existing = updated[index];

      updated[index] = CartItem(
        product: existing.product,
        quantity: existing.quantity + 1,
        addons: existing.addons,
      );

      state = updated;
      return;
    }

    state = [...state, newItem];
  }

  void increaseItem(CartItem item) {
    final updated = [...state];

    final index = updated.indexWhere(
          (e) => e.isSameAs(item),
    );

    if (index == -1) return;

    final existing = updated[index];

    updated[index] = CartItem(
      product: existing.product,
      quantity: existing.quantity + 1,
      addons: existing.addons,
    );

    state = updated;
  }

  void decreaseItem(CartItem item) {
    final updated = [...state];

    final index = updated.indexWhere(
          (e) => e.isSameAs(item),
    );

    if (index == -1) return;

    final existing = updated[index];

    if (existing.quantity == 1) {
      updated.removeAt(index);
    } else {
      updated[index] = CartItem(
        product: existing.product,
        quantity: existing.quantity - 1,
        addons: existing.addons,
      );
    }

    state = updated;
  }

  void removeItem(CartItem item) {
    state = state
        .where((e) => !e.isSameAs(item))
        .toList();
  }

  double get total {
    return state.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }
}