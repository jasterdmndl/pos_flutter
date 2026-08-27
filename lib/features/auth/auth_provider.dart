import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/user_entity.dart';
import '../../core/services/supabase_service.dart';
import '../sync/sync_provider.dart';
import '../../core/utils/error_handler.dart';
import '../../core/utils/logger.dart';

final authErrorProvider = StateProvider<String?>((ref) => null);

/// Set when this device is force-logged-out by another device taking over
/// the single session. Shown as a banner on the Login screen.
final forceLogoutReasonProvider = StateProvider<String?>((ref) => null);

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<UserEntity?> {
  final Ref ref;
  String? _sessionId;
  AuthNotifier(this.ref) : super(null);

  /// This device's active session id. Null until an online login claims one.
  String? get sessionId => _sessionId;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<bool> login(String email, String password) async {
    ref.read(authErrorProvider.notifier).state = null;

    final String passwordHash = _hashPassword(password);

    // 0. EMERGENCY OFFLINE ADMIN CHECK
    // This allows setup even on a brand new device with ZERO internet.
    final String emergencyEmail = dotenv.get('EMERGENCY_ADMIN_EMAIL', fallback: '');
    final String emergencyPass = dotenv.get('EMERGENCY_ADMIN_PASSWORD', fallback: '');

    if (emergencyEmail.isNotEmpty && email == emergencyEmail && password == emergencyPass) {
      state = UserEntity()
        ..username = emergencyEmail
        ..name = "Emergency Admin"
        ..passwordHash = passwordHash
        ..role = "admin"
        ..lastLogin = DateTime.now();
      AppLogger.i('EMERGENCY LOGIN SUCCESSFUL for $email');
      return true;
    }

    // 1. Try Online Login First
    if (SupabaseService.isInitialized) {
      final supabase = SupabaseService.client;

      try {
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        final user = response.user;
        if (user != null) {
          // Fetch Profile
          final profileData = await supabase
              .from('profiles')
              .select()
              .eq('id', user.id)
              .single();

          final String role = (profileData['role'] as String).toLowerCase();
          final String name = profileData['username'] ?? user.email ?? 'User';

          // Create local entity
          final localUser = UserEntity()
            ..username = email
            ..name = name
            ..passwordHash = passwordHash
            ..role = role
            ..supabaseUserId = user.id // Save the Cloud UUID locally
            ..lastLogin = DateTime.now();

          AppLogger.d('Online login success. Caching user and checking local orders.');

          // 2. CACHE FOR OFFLINE USE
          await IsarService.isar.writeTxn(() async {
            await IsarService.isar.userEntitys.put(localUser);
          });

          state = localUser;

          // Single-session: claim this device by writing a fresh session id.
          // Another device logging in overwrites this; its watcher then
          // force-logs-out this device on the next poll.
          final sessionId = const Uuid().v4();
          _sessionId = sessionId;
          try {
            await SupabaseService.client
                .from('profiles')
                .update({'active_session_id': sessionId})
                .eq('id', user.id);
          } catch (e) {
            AppLogger.w('Session marker write failed: $e');
          }

          // Pull this cashier's cloud orders so history is consistent on this device
          unawaited(ref.read(syncProvider.notifier).pullNow(cashierId: localUser.supabaseUserId));
          return true;
        }
      } on AuthException catch (e) {
        // Specifically check for connection issues to decide whether to try offline
        final msg = e.message.toLowerCase();
        if (!msg.contains('invalid login credentials')) {
           return await _tryOfflineLogin(email, passwordHash);
        }
        ref.read(authErrorProvider.notifier).state = ErrorHandler.map(e);
        return false;
      } catch (e) {
        // Likely network error
        return await _tryOfflineLogin(email, passwordHash);
      }
    } else {
      // Supabase not even initialized (No .env or total offline)
      return await _tryOfflineLogin(email, passwordHash);
    }
    
    return false;
  }

  Future<bool> _tryOfflineLogin(String email, String passwordHash) async {
    AppLogger.d('Attempting Offline Login for: $email');
    
    final localUser = await IsarService.isar.userEntitys
        .filter()
        .usernameEqualTo(email)
        .findFirst();

    if (localUser != null) {
      if (localUser.passwordHash == passwordHash) {
        state = localUser;
        // Pull this cashier's cloud orders so history is consistent on this device
        unawaited(ref.read(syncProvider.notifier).pullNow(cashierId: localUser.supabaseUserId));
        AppLogger.i('Offline Login Successful. Role: ${state?.role}');
        return true;
      } else {
        ref.read(authErrorProvider.notifier).state = 'Incorrect password (Offline Mode).';
        return false;
      }
    }

    ref.read(authErrorProvider.notifier).state = 'Offline mode: You must log in online at least once to cache your credentials.';
    return false;
  }

  void loginAsGuest() {
    state = UserEntity()
      ..username = "guest"
      ..name = "Guest Cashier"
      ..passwordHash = ""
      ..role = "cashier"
      ..lastLogin = DateTime.now();
  }

  /// Normal logout (user-initiated). Clears the cloud session marker too.
  Future<void> logout() async {
    if (SupabaseService.isInitialized) {
      final id = state?.supabaseUserId;
      try {
        await SupabaseService.client.auth.signOut();
      } catch (_) {}
      if (id != null) {
        try {
          await SupabaseService.client
              .from('profiles')
              .update({'active_session_id': null})
              .eq('id', id);
        } catch (_) {}
      }
    }
    _sessionId = null;
    state = null;
  }

  /// Forced logout triggered by another device taking over the session.
  Future<void> forceLogout() async {
    if (SupabaseService.isInitialized) {
      final id = state?.supabaseUserId;
      try {
        await SupabaseService.client.auth.signOut();
      } catch (_) {}
      if (id != null) {
        try {
          await SupabaseService.client
              .from('profiles')
              .update({'active_session_id': null})
              .eq('id', id);
        } catch (_) {}
      }
    }
    _sessionId = null;
    state = null;
    ref.read(forceLogoutReasonProvider.notifier).state =
        'You were logged out because this account was opened on another device.';
  }
}
