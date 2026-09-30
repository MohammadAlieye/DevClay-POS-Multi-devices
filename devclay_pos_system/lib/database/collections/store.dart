import 'package:isar_community/isar.dart';

part 'store.g.dart';

@collection
class Store {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String code;

  late String name;
  late String city;
  late String address;
  late bool isActive;
}
