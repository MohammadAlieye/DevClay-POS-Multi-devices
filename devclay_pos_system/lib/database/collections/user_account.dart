import 'package:isar_community/isar.dart';

part 'user_account.g.dart';

@collection
class UserAccount {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String username;

  late String displayName;
  late String role;
  late List<String> permissions;
  late String passwordHash;
  late String passwordSalt;
  late bool isActive;
  late DateTime createdAt;

  /// When set, staff account is in the Recycle Bin.
  DateTime? deletedAt;
}
