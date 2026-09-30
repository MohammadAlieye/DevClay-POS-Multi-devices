import 'package:isar_community/isar.dart';

part 'dashboard_metric.g.dart';

@collection
class DashboardMetric {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late double todaySales;
  late double todayProfit;
  late double monthlySales;
  late double monthlyProfit;
  late double todaySalesChange;
  late double todayProfitChange;
  late double monthlySalesChange;
  late double monthlyProfitChange;
  late DateTime updatedAt;
}
