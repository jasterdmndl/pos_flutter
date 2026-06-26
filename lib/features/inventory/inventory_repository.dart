import 'package:isar/isar.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/ingredient_entity.dart';
import '../../core/database/collections/product_ingredient_entity.dart';

class InventoryRepository {
  Future<void> deductInventory(int productId, int quantity) async {
    final recipes = await IsarService.isar.productIngredientEntitys
        .filter()
        .productIdEqualTo(productId)
        .findAll();

    if (recipes.isEmpty) return;

    await IsarService.isar.writeTxn(() async {
      for (final recipe in recipes) {
        final ingredient = await IsarService.isar.ingredientEntitys.get(recipe.ingredientId);
        if (ingredient != null) {
          ingredient.stockQuantity -= (recipe.amountUsed * quantity);
          await IsarService.isar.ingredientEntitys.put(ingredient);
        }
      }
    });
  }

  Future<void> restockInventory(int productId, int quantity) async {
    final recipes = await IsarService.isar.productIngredientEntitys
        .filter()
        .productIdEqualTo(productId)
        .findAll();

    if (recipes.isEmpty) return;

    await IsarService.isar.writeTxn(() async {
      for (final recipe in recipes) {
        final ingredient = await IsarService.isar.ingredientEntitys.get(recipe.ingredientId);
        if (ingredient != null) {
          ingredient.stockQuantity += (recipe.amountUsed * quantity);
          await IsarService.isar.ingredientEntitys.put(ingredient);
        }
      }
    });
  }

  Future<List<IngredientEntity>> getAllIngredients() async {
    return await IsarService.isar.ingredientEntitys.where().findAll();
  }

  Future<void> updateStock(int id, double newQuantity) async {
    await IsarService.isar.writeTxn(() async {
      final ingredient = await IsarService.isar.ingredientEntitys.get(id);
      if (ingredient != null) {
        ingredient.stockQuantity = newQuantity;
        await IsarService.isar.ingredientEntitys.put(ingredient);
      }
    });
  }
}
