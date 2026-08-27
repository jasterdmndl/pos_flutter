import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/logger.dart';
import '../products/product_provider.dart';
import 'catalog_sync_repository.dart';

final catalogSyncRepositoryProvider =
    Provider((ref) => CatalogSyncRepository());

/// Periodically pulls the shared catalog from Supabase so any product/category/
/// addon/ingredient change made on one device shows up on all others (~30s).
final catalogSyncProvider =
    StateNotifierProvider<CatalogSyncNotifier, bool>((ref) {
  return CatalogSyncNotifier(ref.watch(catalogSyncRepositoryProvider), ref);
});

class CatalogSyncNotifier extends StateNotifier<bool> {
  final CatalogSyncRepository _repo;
  final Ref ref;
  Timer? _timer;

  CatalogSyncNotifier(this._repo, this.ref) : super(false) {
    unawaited(pullCatalog());
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => pullCatalog());
  }

  Future<void> pullCatalog() async {
    if (state) return;
    state = true;
    try {
      await _repo.pullCatalog();
      ref.invalidate(productProvider);
      ref.invalidate(categoriesProvider);
    } catch (e) {
      AppLogger.w('Catalog pull failed: $e');
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
