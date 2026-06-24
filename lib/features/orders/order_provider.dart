import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'order_repository.dart';

final orderRepositoryProvider =
Provider<OrderRepository>(
      (ref) => OrderRepository(),
);