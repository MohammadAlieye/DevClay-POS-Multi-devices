import 'package:isar_community/isar.dart';

part 'customer.g.dart';

@collection
class Customer {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  late String phone;
  String? email;
  String? address;
  String? notes;
  late double balance;
  late double creditLimit;
  late bool isActive;
  late DateTime createdAt;
}
