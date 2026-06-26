import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_repository.dart';

final syncRepositoryProvider = Provider((ref) => SyncRepository());

final syncProvider = StateNotifierProvider<SyncNotifier, bool>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider));
});

class SyncNotifier extends StateNotifier<bool> {
  final SyncRepository _repository;
  Timer? _timer;

  SyncNotifier(this._repository) : super(false) {
    // Start periodic sync every 5 minutes
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => syncNow());
  }

  Future<void> syncNow() async {
    if (state) return; // Already syncing
    
    state = true;
    try {
      await _repository.syncPendingOrders();
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
