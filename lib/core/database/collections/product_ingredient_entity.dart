import 'package:isar/isar.dart';

part 'product_ingredient_entity.g.dart';

@collection
class ProductIngredientEntity {
  Id id = Isar.autoIncrement;

  late int productId;

  late int ingredientId;

  late double amountUsed;
}
