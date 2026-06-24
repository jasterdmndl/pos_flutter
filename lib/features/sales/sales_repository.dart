import 'package:isar/isar.dart';
import '../../core/database/collections/order_item_entity.dart';
import '../../core/database/collections/order_addon_entity.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';

class SalesRepository {
  Future<List<OrderEntity>> getOrders() async {
    return await IsarService.isar.orderEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }
  Future<List<OrderItemEntity>> getOrderItems(
      int orderId,
      ) async {
    return await IsarService.isar.orderItemEntitys
        .filter()
        .orderIdEqualTo(orderId)
        .findAll();
  }
  Future<List<OrderAddonEntity>> getAddons(
      int orderItemId,
      ) async {
    return await IsarService.isar.orderAddonEntitys
        .filter()
        .orderItemIdEqualTo(orderItemId)
        .findAll();
  }
}