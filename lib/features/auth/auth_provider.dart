import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/collections/user_entity.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserEntity?> {
  AuthNotifier() : super(null);

  final _supabase = Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      print('Attempting Supabase login for: $email');
      
      // 1. Authenticate with Supabase
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        print('Login failed: User object is null');
        return false;
      }

      print('Supabase Auth successful for UID: ${user.id}. Fetching profile...');

      // 2. Fetch User Profile/Role from Supabase 'profiles' table
      try {
        final profileData = await _supabase
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

        print('Profile loaded successfully. Role: ${state?.role}');
        return true;
      } on PostgrestException catch (pgError) {
        print('Postgrest Error: ${pgError.message} (Code: ${pgError.code})');
        if (pgError.code == 'PGRST116') {
          print('Error Details: No rows found in "profiles" for this UID. This usually means the row exists but RLS is blocking you from reading it, or the row was never inserted.');
        }
        return false;
      } catch (profileError) {
        print('Unexpected Profile Error: $profileError');
        return false;
      }
    } on AuthException catch (e) {
      print('Supabase Auth Error: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected Login Error: $e');
      return false;
    }
  }

  void logout() async {
    await _supabase.auth.signOut();
    state = null;
  }
}
