import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/collections/user_entity.dart';
import '../../core/services/supabase_service.dart';

final authErrorProvider = StateProvider<String?>((ref) => null);

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<UserEntity?> {
  final Ref ref;
  AuthNotifier(this.ref) : super(null);

  Future<bool> login(String email, String password) async {
    ref.read(authErrorProvider.notifier).state = null;

    if (!SupabaseService.isInitialized) {
      ref.read(authErrorProvider.notifier).state = 'Supabase not initialized. Check .env file.';
      return false;
    }

    final supabase = SupabaseService.client;

    try {
      // 1. Authenticate with Supabase
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        ref.read(authErrorProvider.notifier).state = 'Auth failed: User object is null.';
        return false;
      }

      // 2. Fetch User Profile/Role from Supabase 'profiles' table
      try {
        final profileData = await supabase
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        // 3. Update local state
        state = UserEntity()
          ..id = 0
          ..name = profileData['username'] ?? user.email ?? 'User'
          ..username = profileData['username'] ?? user.email ?? ''
          ..password = ''
          ..role = (profileData['role'] as String).toLowerCase();

        return true;
      } on PostgrestException catch (pgError) {
        if (pgError.code == 'PGRST116') {
          ref.read(authErrorProvider.notifier).state = 'Profile not found in database. Run the SQL script for UID: ${user.id}';
        } else {
          ref.read(authErrorProvider.notifier).state = 'Database Error: ${pgError.message}';
        }
        return false;
      } catch (profileError) {
        ref.read(authErrorProvider.notifier).state = 'Unexpected Profile Error: $profileError';
        return false;
      }
    } on AuthException catch (e) {
      ref.read(authErrorProvider.notifier).state = 'Login Failed: ${e.message}';
      return false;
    } catch (e) {
      final errorStr = e.toString();
      if (errorStr.contains('Failed host lookup') || errorStr.contains('connection')) {
        ref.read(authErrorProvider.notifier).state = 'No Internet Connection. Please check your WiFi.';
      } else {
        ref.read(authErrorProvider.notifier).state = 'Unexpected Error: $e';
      }
      return false;
    }
  }

  void logout() async {
    if (SupabaseService.isInitialized) {
      await SupabaseService.client.auth.signOut();
    }
    state = null;
  }
}
