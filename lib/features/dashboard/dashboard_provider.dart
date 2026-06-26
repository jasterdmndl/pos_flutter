import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_repository.dart';
import 'dashboard_summary.dart';

final dashboardProvider =
FutureProvider<DashboardSummary>((ref) async {
  return DashboardRepository()
      .getSummary();
});