import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/collections/order_entity.dart';
import 'sales_repository.dart';

final salesRepositoryProvider =
Provider<SalesRepository>(
      (ref) => SalesRepository(),
);

final salesHistoryProvider =
FutureProvider<List<OrderEntity>>((ref) async {
  final repository =
  ref.read(salesRepositoryProvider);

  return repository.getOrders();
});