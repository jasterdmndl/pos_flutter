import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_repository.dart';
import 'dashboard_summary.dart';
import 'live_orders_provider.dart';

final dashboardProvider = FutureProvider<DashboardSummary>((ref) async {
  return DashboardRepository().getSummary();
});

/// A dedicated provider for the Remote Owner Dashboard.
/// It fetches data from Supabase instead of the local Isar database.
final remoteDashboardProvider = FutureProvider<DashboardSummary>((ref) async {
  // We explicitly watch the liveOrdersProvider. 
  // Whenever the real-time stream updates (new order), this provider will re-execute!
  ref.watch(liveOrdersProvider);
  
  return DashboardRepository().getRemoteSummary();
});
