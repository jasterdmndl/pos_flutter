import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/order_entity.dart';
import 'order_repository.dart';

final orderRepositoryProvider =
Provider<OrderRepository>(
      (ref) => OrderRepository(),
);

final pendingSyncCountProvider = StreamProvider<int>((ref) {
  return IsarService.isar.orderEntitys
      .filter()
      .isSyncedEqualTo(false)
      .watch(fireImmediately: true)
      .map((orders) => orders.length);
});
