import 'package:isar/isar.dart';

part 'order_item_entity.g.dart';

@collection
class OrderItemEntity {
  Id id = Isar.autoIncrement;

  late int orderId;

  late String productName;

  late double basePrice;

  late int quantity;

  late double subtotal;
}