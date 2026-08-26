import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_repository.dart';
import '../../core/utils/logger.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/dashboard/dashboard_provider.dart';
import '../../features/sales/sales_provider.dart';

final syncRepositoryProvider = Provider((ref) => SyncRepository());

final syncProvider = StateNotifierProvider<SyncNotifier, bool>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider), ref);
});

class SyncNotifier extends StateNotifier<bool> {
  final SyncRepository _repository;
  final Ref ref;
  Timer? _timer;
  int _retryCount = 0;
  bool _pulling = false;

  SyncNotifier(this._repository, this.ref) : super(false) {
    // Initial sync + cross-device pull
    syncNow();
    pullNow();
    // Start periodic sync every 5 minutes
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      syncNow();
      pullNow();
    });
  }

  Future<void> syncNow() async {
    if (state) {
      AppLogger.d('Sync already in progress, skipping...');
      return;
    }
    
    AppLogger.d('Triggering syncNow...');
    state = true;
    try {
      await _repository.syncPendingOrders();
      _retryCount = 0; // Reset count on success
    } catch (e) {
      _retryCount++;
      // Exponential Backoff: wait 2^retry seconds (max 1 hour) before retrying if it failed
      final backoff = Duration(seconds: (1 << _retryCount).clamp(1, 3600));
      AppLogger.w('Sync process encountered an error. Retrying in ${backoff.inSeconds}s... (Attempt $_retryCount)');
      
      Timer(backoff, () => syncNow());
    } finally {
      state = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Downloads this account's cloud orders into the local Isar so the same
  /// cashier sees consistent history on any device. Pulled rows are marked
  /// synced, so they never inflate the "pending sync" badge or get re-uploaded.
  Future<void> pullNow({String? cashierId}) async {
    if (_pulling) {
      AppLogger.d('Pull already in progress, skipping...');
      return;
    }

    _pulling = true;
    try {
      final id = cashierId ?? ref.read(authProvider)?.supabaseUserId;
      await _repository.pullCashierOrders(id);
      ref.invalidate(dashboardProvider);
      ref.invalidate(salesHistoryProvider);
      AppLogger.i('Cross-device pull finished.');
    } catch (e) {
      AppLogger.w('Cross-device pull failed: $e');
    } finally {
      _pulling = false;
    }
  }
}
