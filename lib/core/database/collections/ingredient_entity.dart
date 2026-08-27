import 'package:isar/isar.dart';

part 'ingredient_entity.g.dart';

@collection
class IngredientEntity {
  Id id = Isar.autoIncrement;

  late String name;

  late double stockQuantity;

  late String unit; // e.g., 'grams', 'ml', 'pcs'

  /// Globally unique id used as the cloud primary key for cross-device sync.
  @Index(unique: true)
  String? syncId;

  DateTime? updatedAt;

  bool isDeleted = false;
}
