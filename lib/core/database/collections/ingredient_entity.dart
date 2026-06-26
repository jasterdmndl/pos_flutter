import 'package:isar/isar.dart';

part 'ingredient_entity.g.dart';

@collection
class IngredientEntity {
  Id id = Isar.autoIncrement;

  late String name;

  late double stockQuantity;

  late String unit; // e.g., 'grams', 'ml', 'pcs'
}
