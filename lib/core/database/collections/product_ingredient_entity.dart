import 'package:isar/isar.dart';

part 'product_ingredient_entity.g.dart';

@collection
class ProductIngredientEntity {
  Id id = Isar.autoIncrement;

  late int productId;

  late int ingredientId;

  late double amountUsed;

  /// Globally unique id used as the cloud primary key for cross-device sync.
  @Index(unique: true)
  String? syncId;

  /// References the product's [syncId] (local [productId] is device-specific).
  String? productSyncId;

  /// References the ingredient's [syncId] (local [ingredientId] is device-specific).
  String? ingredientSyncId;

  DateTime? updatedAt;

  bool isDeleted = false;
}
