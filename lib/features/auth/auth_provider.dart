import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/user_entity.dart';
import 'package:isar/isar.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserEntity?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserEntity?> {
  AuthNotifier() : super(null);

  Future<bool> login(String pin) async {
    // Seed admin if none exists
    final count = await IsarService.isar.userEntitys.count();
    if (count == 0) {
      await IsarService.isar.writeTxn(() async {
        final admin = UserEntity()
          ..name = 'Admin'
          ..pin = '1234'
          ..role = 'admin';
        await IsarService.isar.userEntitys.put(admin);
      });
    }

    final user = await IsarService.isar.userEntitys
        .filter()
        .pinEqualTo(pin)
        .findFirst();

    if (user != null) {
      state = user;
      return true;
    }
    return false;
  }

  void logout() {
    state = null;
  }
}
