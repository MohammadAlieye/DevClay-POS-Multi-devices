import 'package:isar_community/isar.dart';

part 'auth_session.g.dart';

@collection
class AuthSession {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  int? userId;
  int? storeId;
  late bool rememberMe;
  DateTime? loggedInAt;
}
