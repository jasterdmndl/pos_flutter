import 'package:isar/isar.dart';

part 'product_addon_entity.g.dart';

@collection
class ProductAddonEntity {
  Id id = Isar.autoIncrement;

  late String name;

  late double price;

  late bool isPerUnit;

  late bool isActive;
}
