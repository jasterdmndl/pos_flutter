import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_model.dart';
import 'product_repository.dart';
import '../../core/database/collections/category_entity.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  await repo.seedInitialData(); // Ensure we have data
  return await repo.getCategories();
});

final selectedCategoryProvider = StateProvider<int?>((ref) => null);

final productProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == null) {
    final entities = await repo.getAllProducts();
    return entities.map((e) => Product.fromEntity(e)).toList();
  } else {
    final entities = await repo.getProductsByCategory(selectedCategory);
    return entities.map((e) => Product.fromEntity(e)).toList();
  }
});
