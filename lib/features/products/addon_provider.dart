import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'addon_model.dart';
import 'product_provider.dart';

final addonProvider = FutureProvider<List<Addon>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final entities = await repo.getAddons();
  
  return entities.map((e) => Addon(
    id: e.id,
    name: e.name,
    price: e.price,
    isPerUnit: e.isPerUnit,
  )).toList();
});
