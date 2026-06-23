import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_model.dart';

final productProvider = Provider<List<Product>>((ref) {
  return [
    const Product(
      id: 1,
      name: 'Latte',
      price: 120,
      isActive: true,
    ),
    const Product(
      id: 2,
      name: 'Mocha',
      price: 140,
      isActive: true,
    ),
    const Product(
      id: 3,
      name: 'Americano',
      price: 100,
      isActive: true,
    ),
    const Product(
      id: 4,
      name: 'Cappuccino',
      price: 130,
      isActive: true,
    ),
  ];
});