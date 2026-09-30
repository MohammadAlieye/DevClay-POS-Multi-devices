import 'package:isar_community/isar.dart';

part 'supplier.g.dart';

@collection
class Supplier {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  late String phone;
  String? email;
  String? address;
  String? notes;

  /// Positive = shop owes supplier. Negative = supplier owes shop (credit/advance).
  double balance = 0;

  late bool isActive;
  late DateTime createdAt;
}
