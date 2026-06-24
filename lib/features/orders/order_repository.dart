import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';

class OrderRepository {
  Future<void> saveOrder({
    required double subtotal,
    required double discountAmount,
    required double total,
    required String paymentMethod,
  }) async {
    final order = OrderEntity()
      ..subtotal = subtotal
      ..discountAmount = discountAmount
      ..total = total
      ..paymentMethod = paymentMethod
      ..createdAt = DateTime.now();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.orderEntitys.put(order);
    });
  }
}