import 'package:isar/isar.dart';

part 'order_entity.g.dart';

@collection
class OrderEntity {
  Id id = Isar.autoIncrement;

  late double subtotal;
  late double discountAmount;
  late double total;

  late String paymentMethod;

  late DateTime createdAt;

  @ignore
  String get receiptNumber {
    final year = createdAt.year;

    return 'OR-$year-${id.toString().padLeft(6, '0')}';
  }
}

