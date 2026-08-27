import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/app_navigator.dart';
import '../../core/services/supabase_service.dart';
import 'login_screen.dart';
import 'auth_provider.dart';

/// Keeps a single device session enforced across devices.
///
/// Every 15s it checks the cloud `profiles.active_session_id` for the current
/// user. If another device has overwritten it with a different session id,
/// this device is force-logged-out and returned to the Login screen.
final sessionWatcherProvider = Provider((ref) {
  return SessionWatcher(ref);
});

class SessionWatcher {
  SessionWatcher(this.ref) {
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _check());
    ref.onDispose(() => _timer?.cancel());
  }

  final Ref ref;
  Timer? _timer;

  Future<void> _check() async {
    final user = ref.read(authProvider);
    if (user == null ||
        user.supabaseUserId == null ||
        !SupabaseService.isInitialized) {
      return;
    }

    final ourId = ref.read(authProvider.notifier).sessionId;
    if (ourId == null) return;

    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select('active_session_id')
          .eq('id', user.supabaseUserId!)
          .maybeSingle();

      final remoteId = data?['active_session_id'] as String?;
      if (remoteId != null && remoteId != ourId) {
        await ref.read(authProvider.notifier).forceLogout();

        final ctx = appNavigatorKey.currentContext;
        if (ctx != null && ctx.mounted) {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (_) => false,
          );
        }
      }
    } catch (_) {
      // Transient network / RLS hiccup — retry on the next tick.
    }
  }
}
