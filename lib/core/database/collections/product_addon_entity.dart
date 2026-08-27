import 'package:isar/isar.dart';

part 'product_addon_entity.g.dart';

@collection
class ProductAddonEntity {
  Id id = Isar.autoIncrement;

  late String name;

  late double price;

  late bool isPerUnit;

  late bool isActive;

  /// Globally unique id used as the cloud primary key for cross-device sync.
  @Index(unique: true)
  String? syncId;

  DateTime? updatedAt;

  bool isDeleted = false;
}
