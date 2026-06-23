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

  double get total {
    return state.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }

}