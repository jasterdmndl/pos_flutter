import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_item_model.dart';

final cartProvider = StateProvider<List<CartItem>>((ref) {
  return [];
});