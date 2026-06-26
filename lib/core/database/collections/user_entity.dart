import 'package:isar/isar.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;

  late String name;

  late String pin; // Simple 4-digit PIN

  late String role; // 'admin' or 'cashier'
}
