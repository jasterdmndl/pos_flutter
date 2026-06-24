import 'package:isar/isar.dart';

part 'order_addon_entity.g.dart';

@collection
class OrderAddonEntity {
  Id id = Isar.autoIncrement;

  late int orderItemId;

  late String addonName;

  late double price;

  late int quantity;

  late double subtotal;
}