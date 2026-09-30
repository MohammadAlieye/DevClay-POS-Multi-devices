import 'package:isar_community/isar.dart';

part 'account.g.dart';

@collection
class Account {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  /// cash | bank | mobile
  late String type;
  late double balance;
  late bool isDefault;
  late bool isActive;
  String? notes;
  late DateTime createdAt;
}
