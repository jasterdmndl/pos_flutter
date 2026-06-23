import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../products/product_model.dart';
import 'cart_item_model.dart';

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);

  void addProduct(Product product) {
    final index = state.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index == -1) {
      state = [
        ...state,
        CartItem(
          product: product,
          quantity: 1,
        ),
      ];
      return;
    }

    final updatedCart = [...state];
    final existingItem = updatedCart[index];

    updatedCart[index] = CartItem(
      product: existingItem.product,
      quantity: existingItem.quantity + 1,
    );

    state = updatedCart;
  }

  void increaseQuantity(int productId) {
    final updatedCart = [...state];

    final index = updatedCart.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index == -1) return;

    final item = updatedCart[index];

    updatedCart[index] = CartItem(
      product: item.product,
      quantity: item.quantity + 1,
    );

    state = updatedCart;
  }

  void decreaseQuantity(int productId) {
    final updatedCart = [...state];

    final index = updatedCart.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index == -1) return;

    final item = updatedCart[index];

    if (item.quantity == 1) {
      updatedCart.removeAt(index);
      state = updatedCart;
      return;
    }

    updatedCart[index] = CartItem(
      product: item.product,
      quantity: item.quantity - 1,
    );

    state = updatedCart;
  }

  void removeItem(int productId) {
    state = state
        .where((item) => item.product.id != productId)
        .toList();
  }

  double get total {
    return state.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }
}