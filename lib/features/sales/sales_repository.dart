import 'package:isar/isar.dart';

import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';

class SalesRepository {
  Future<List<OrderEntity>> getOrders() async {
    return await IsarService.isar.orderEntitys
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }
}