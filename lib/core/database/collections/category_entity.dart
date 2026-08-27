import 'package:isar/isar.dart';

part 'category_entity.g.dart';

@collection
class CategoryEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  late bool isActive;

  /// Globally unique id used as the cloud primary key for cross-device sync.
  @Index(unique: true)
  String? syncId;

  DateTime? updatedAt;

  bool isDeleted = false;
}
