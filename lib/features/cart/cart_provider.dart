import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_controller.dart';
import 'cart_item_model.dart';

final cartProvider =
StateNotifierProvider<CartController, List<CartItem>>(
      (ref) => CartController(),
);