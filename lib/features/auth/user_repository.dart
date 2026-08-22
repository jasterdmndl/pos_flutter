import 'package:isar/isar.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/user_entity.dart';
import '../../core/services/supabase_service.dart';
import '../../core/utils/logger.dart';

class UserRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<UserEntity>> getAllUsers() async {
    return await IsarService.isar.userEntitys.where().findAll();
  }

  Future<void> saveUser(UserEntity user, {String? password}) async {
    if (password != null && user.supabaseUserId == null) {
      try {
        // 1. Try to create the user in Supabase Auth
        final AuthResponse res = await _supabase.auth.signUp(
          email: user.username,
          password: password,
          data: {
            'username': user.name,
            'role': user.role, // This goes into user_metadata
          },
        );

        if (res.user != null) {
          user.supabaseUserId = res.user!.id;
          AppLogger.i('Staff user created in Supabase Auth: ${user.username}');
        }
      } on AuthException catch (e) {
        if (e.code == 'user_already_exists' || e.statusCode == '422') {
          AppLogger.i('User already exists in Auth. Checking for profile link...');
          throw 'The email "${user.username}" is already in use in Supabase Auth. Please delete it from Supabase Auth > Users first, or use a different email.';
        }
        rethrow;
      }
    }

    // 2. Sync Profile (Upsert)
    if (user.supabaseUserId != null) {
      try {
        await _supabase.from('profiles').upsert({
          'id': user.supabaseUserId,
          'username': user.name,
          'role': user.role,
        });
        AppLogger.i('Profile synced to Supabase for ${user.username}');
      } on PostgrestException catch (e) {
        AppLogger.e('Profile sync failed: ${e.message}');
        if (e.code == '42P17') {
          throw 'Database policy error (Infinite Recursion). Please run the updated SQL fix in Supabase.';
        }
        rethrow;
      }
    }

    // 3. Save Locally
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userEntitys.put(user);
    });
  }

  Future<void> deleteUser(int id) async {
    final user = await IsarService.isar.userEntitys.get(id);
    
    // We don't delete from Supabase Auth via client SDK (requires Admin keys),
    // but we can mark the profile as inactive if we had that field.
    // For now, we just delete local.

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userEntitys.delete(id);
    });
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
