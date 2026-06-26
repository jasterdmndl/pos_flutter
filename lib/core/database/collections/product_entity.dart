import 'package:isar/isar.dart';

part 'product_entity.g.dart';

@collection
class ProductEntity {
  Id id = Isar.autoIncrement;

  late String name;

  late double price;

  late int categoryId;

  late bool isActive;
}
