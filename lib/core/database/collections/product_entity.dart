import 'package:isar/isar.dart';

part 'product_entity.g.dart';

@collection
class ProductEntity {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  late double price;

  @Index()
  late int categoryId;

  late bool isActive;

  /// Globally unique id used as the cloud primary key for cross-device sync.
  @Index(unique: true)
  String? syncId;

  /// References the category's [syncId] (local [categoryId] is device-specific).
  String? categorySyncId;

  DateTime? updatedAt;

  bool isDeleted = false;
}
