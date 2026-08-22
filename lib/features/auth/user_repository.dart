import 'package:isar/isar.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../core/database/isar_service.dart';
import '../../core/database/collections/user_entity.dart';

class UserRepository {
  Future<List<UserEntity>> getAllUsers() async {
    return await IsarService.isar.userEntitys.where().findAll();
  }

  Future<void> saveUser(UserEntity user) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userEntitys.put(user);
    });
  }

  Future<void> deleteUser(int id) async {
    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.userEntitys.delete(id);
    });
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
