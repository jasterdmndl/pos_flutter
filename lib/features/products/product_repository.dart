import 'package:isar/isar.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/category_entity.dart';
import '../../core/database/collections/product_entity.dart';
import '../../core/database/collections/ingredient_entity.dart';
import '../../core/database/collections/product_ingredient_entity.dart';
import '../../core/database/collections/product_addon_entity.dart';

class ProductRepository {
  Future<List<CategoryEntity>> getCategories() async {
    return await IsarService.isar.categoryEntitys.where().findAll();
  }

  Future<List<ProductAddonEntity>> getAddons() async {
    return await IsarService.isar.productAddonEntitys.where().findAll();
  }

  Future<void> saveAddon(ProductAddonEntity addon) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.productAddonEntitys.put(addon);
    });
  }

  Future<void> deleteAddon(int id) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.productAddonEntitys.delete(id);
    });
  }

  Future<List<ProductEntity>> getProductsByCategory(int categoryId) async {
    return await IsarService.isar.productEntitys
        .filter()
        .categoryIdEqualTo(categoryId)
        .findAll();
  }

  Future<List<ProductEntity>> getAllProducts() async {
    return await IsarService.isar.productEntitys.where().findAll();
  }

  Future<void> saveProduct(ProductEntity product) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.productEntitys.put(product);
    });
  }

  Future<void> deleteProduct(int id) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.productEntitys.delete(id);
    });
  }

  Future<void> saveCategory(CategoryEntity category) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.categoryEntitys.put(category);
    });
  }

  Future<void> deleteCategory(int id) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.categoryEntitys.delete(id);
    });
  }

  Future<void> seedInitialData() async {
    final categoryCount = await IsarService.isar.categoryEntitys.count();
    if (categoryCount > 0) return;

    await IsarService.isar.writeTxn(() async {
      // Create Categories
      final coffee = CategoryEntity()
        ..name = 'Coffee'
        ..isActive = true;
      final tea = CategoryEntity()
        ..name = 'Tea'
        ..isActive = true;
      final pastries = CategoryEntity()
        ..name = 'Pastries'
        ..isActive = true;
      final meals = CategoryEntity()
        ..name = 'Meals'
        ..isActive = true;

      await IsarService.isar.categoryEntitys.putAll([coffee, tea, pastries, meals]);

      // Create Ingredients
      final beans = IngredientEntity()
        ..name = 'Coffee Beans'
        ..stockQuantity = 5000 // grams
        ..unit = 'grams';
      final milk = IngredientEntity()
        ..name = 'Fresh Milk'
        ..stockQuantity = 10000 // ml
        ..unit = 'ml';
      final sugar = IngredientEntity()
        ..name = 'Syrup'
        ..stockQuantity = 2000 // ml
        ..unit = 'ml';

      await IsarService.isar.ingredientEntitys.putAll([beans, milk, sugar]);

      // Create Products
      final latte = ProductEntity()
        ..name = 'Latte'
        ..price = 120
        ..categoryId = coffee.id
        ..isActive = true;
      final americano = ProductEntity()
        ..name = 'Americano'
        ..price = 100
        ..categoryId = coffee.id
        ..isActive = true;

      await IsarService.isar.productEntitys.putAll([latte, americano]);

      // Create Product-Ingredient links
      final latteBeans = ProductIngredientEntity()
        ..productId = latte.id
        ..ingredientId = beans.id
        ..amountUsed = 18; // 18g per latte
      final latteMilk = ProductIngredientEntity()
        ..productId = latte.id
        ..ingredientId = milk.id
        ..amountUsed = 200; // 200ml per latte
      
      final amBeans = ProductIngredientEntity()
        ..productId = americano.id
        ..ingredientId = beans.id
        ..amountUsed = 18;

      await IsarService.isar.productIngredientEntitys.putAll([latteBeans, latteMilk, amBeans]);

      // Create Addons
      final oatMilk = ProductAddonEntity()
        ..name = 'Oat Milk'
        ..price = 15
        ..isPerUnit = false
        ..isActive = true;
      final vanilla = ProductAddonEntity()
        ..name = 'Vanilla Syrup'
        ..price = 5
        ..isPerUnit = true
        ..isActive = true;

      await IsarService.isar.productAddonEntitys.putAll([oatMilk, vanilla]);
    });
  }
}
