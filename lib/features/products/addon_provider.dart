import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'addon_model.dart';

final addonProvider = Provider<List<Addon>>((ref) {
  return const [
    Addon(
      id: 1,
      name: 'Oat Milk',
      price: 15,
      isPerUnit: false,
    ),
    Addon(
      id: 2,
      name: 'Soy Milk',
      price: 10,
      isPerUnit: false,
    ),
    Addon(
      id: 3,
      name: 'Extra Shot',
      price: 20,
      isPerUnit: false,
    ),
    Addon(
      id: 4,
      name: 'Vanilla Syrup',
      price: 5,
      isPerUnit: true,
    ),
    Addon(
      id: 5,
      name: 'Caramel Syrup',
      price: 5,
      isPerUnit: true,
    ),
  ];
});