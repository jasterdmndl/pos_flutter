import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/user_entity.dart';
import '../../core/services/supabase_service.dart';

final authErrorProvider = StateProvider<String?>((ref) => null);

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<UserEntity?> {
  final Ref ref;
  AuthNotifier(this.ref) : super(null);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<bool> login(String email, String password) async {
    ref.read(authErrorProvider.notifier).state = null;

    final String passwordHash = _hashPassword(password);

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
            ..lastLogin = DateTime.now();

          // 2. CACHE FOR OFFLINE USE
          await IsarService.isar.writeTxn(() async {
            await IsarService.isar.userEntitys.put(localUser);
          });

          state = localUser;
          return true;
        }
      } on AuthException catch (e) {
        // Specifically check for connection issues to decide whether to try offline
        final msg = e.message.toLowerCase();
        if (!msg.contains('invalid login credentials')) {
           return await _tryOfflineLogin(email, passwordHash);
        }
        ref.read(authErrorProvider.notifier).state = 'Login Failed: ${e.message}';
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
    print('Attempting Offline Login for: $email');
    
    final localUser = await IsarService.isar.userEntitys
        .filter()
        .usernameEqualTo(email)
        .findFirst();

    if (localUser != null) {
      if (localUser.passwordHash == passwordHash) {
        state = localUser;
        print('Offline Login Successful. Role: ${state?.role}');
        return true;
      } else {
        ref.read(authErrorProvider.notifier).state = 'Incorrect password (Offline Mode).';
        return false;
      }
    }

    ref.read(authErrorProvider.notifier).state = 'Offline mode: You must log in online at least once to cache your credentials.';
    return false;
  }

  void logout() async {
    if (SupabaseService.isInitialized) {
      try {
        await SupabaseService.client.auth.signOut();
      } catch (_) {}
    }
    state = null;
  }
}
