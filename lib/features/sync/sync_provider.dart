import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_repository.dart';
import '../../core/utils/logger.dart';

final syncRepositoryProvider = Provider((ref) => SyncRepository());

final syncProvider = StateNotifierProvider<SyncNotifier, bool>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider));
});

class SyncNotifier extends StateNotifier<bool> {
  final SyncRepository _repository;
  Timer? _timer;
  int _retryCount = 0;

  SyncNotifier(this._repository) : super(false) {
    // Initial sync
    syncNow();
    // Start periodic sync every 5 minutes
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => syncNow());
  }

  Future<void> syncNow() async {
    if (state) return; 
    
    state = true;
    try {
      await _repository.syncPendingOrders();
      _retryCount = 0; // Reset count on success
    } catch (e) {
      _retryCount++;
      // Exponential Backoff: wait 2^retry seconds (max 1 hour) before retrying if it failed
      final backoff = Duration(seconds: (1 << _retryCount).clamp(1, 3600));
      AppLogger.w('Sync failed. Retrying in ${backoff.inSeconds}s... (Attempt $_retryCount)');
      
      Future.delayed(backoff, () => syncNow());
    } finally {
      state = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
