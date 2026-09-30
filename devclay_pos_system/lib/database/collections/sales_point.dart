import 'package:isar_community/isar.dart';

part 'sales_point.g.dart';

@collection
class SalesPoint {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late double amount;
  late double profit;
}
