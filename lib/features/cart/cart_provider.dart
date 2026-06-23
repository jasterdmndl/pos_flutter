import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_item_model.dart';
import 'cart_addon_model.dart';
import '../products/product_model.dart';

final cartProvider =
StateNotifierProvider<CartNotifier, List<CartItem>>(
      (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // -------------------------
  // ADD PRODUCT (SMART MERGE)
  // -------------------------
  void addProduct(Product product, List<CartAddon> addons) {
    final index = state.indexWhere(
          (item) =>
      item.product.id == product.id &&
          _compareAddons(item.addons, addons),
    );

    if (index >= 0) {
      // MERGE QUANTITY
      final updatedItem = state[index].copyWith(
        quantity: state[index].quantity + 1,
      );

      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    } else {
      // NEW ITEM
      state = [
        ...state,
        CartItem(
          product: product,
          addons: addons,
          quantity: 1,
        ),
      ];
    }
  }

  // -------------------------
  // INCREASE QUANTITY
  // -------------------------
  void increaseItem(CartItem item) {
    state = state.map((e) {
      if (e == item) {
        return e.copyWith(quantity: e.quantity + 1);
      }
      return e;
    }).toList();
  }

  // -------------------------
  // DECREASE QUANTITY
  // -------------------------
  void decreaseItem(CartItem item) {
    state = state.map((e) {
      if (e == item && e.quantity > 1) {
        return e.copyWith(quantity: e.quantity - 1);
      }
      return e;
    }).toList();
  }

  // -------------------------
  // REMOVE ITEM
  // -------------------------
  void removeItem(CartItem item) {
    state = state.where((e) => e != item).toList();
  }

  // -------------------------
  // UPDATE ADDONS (EDIT FEATURE)
  // -------------------------
  void updateItemAddons(
      CartItem item,
      List<CartAddon> updatedAddons,
      ) {
    final index = state.indexOf(item);
    if (index == -1) return;

    final updatedItem = item.copyWith(
      addons: updatedAddons,
    );

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];
  }

  // -------------------------
  // CLEAR CART (AFTER CHECKOUT)
  // -------------------------
  void clearCart() {
    state = [];
  }

  // -------------------------
  // TOTAL CALCULATION
  // -------------------------
  double get total {
    double sum = 0;

    for (final item in state) {
      double addonTotal = 0;

      for (final addon in item.addons) {
        addonTotal += addon.price * addon.quantity;
      }

      sum += (item.product.price + addonTotal) *
          item.quantity;
    }

    return sum;
  }

  // -------------------------
  // HELPER: COMPARE ADDONS
  // -------------------------
  bool _compareAddons(
      List<CartAddon> a,
      List<CartAddon> b,
      ) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i].name != b[i].name ||
          a[i].quantity != b[i].quantity) {
        return false;
      }
    }

    return true;
  }
}