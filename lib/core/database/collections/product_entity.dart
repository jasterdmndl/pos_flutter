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
}
