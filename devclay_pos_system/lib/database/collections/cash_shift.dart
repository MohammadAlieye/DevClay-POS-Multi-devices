import 'package:isar_community/isar.dart';

part 'cash_shift.g.dart';

@collection
class CashShift {
  Id id = Isar.autoIncrement;

  @Index()
  late int userId;
  late String userName;
  int? cashAccountId;
  String? cashAccountName;
  late double openingCash;
  late double expectedCash;
  double? closingCash;
  double? variance;
  String status = 'open';
  String? note;

  @Index()
  late DateTime openedAt;
  DateTime? closedAt;
}
