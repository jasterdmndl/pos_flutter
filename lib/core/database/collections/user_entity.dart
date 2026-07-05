import 'package:isar/isar.dart';

part 'user_entity.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String username; // This will store the email for cloud users

  late String name;

  late String passwordHash;

  late String role; // 'admin', 'cashier', or 'owner'

  late DateTime lastLogin;
}
