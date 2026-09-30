import 'package:isar_community/isar.dart';

part 'recent_sale.g.dart';

@collection
class RecentSale {
  Id id = Isar.autoIncrement;

  late String invoiceNo;
  late String customerName;
  late double amount;
  late String paymentMethod;
  late DateTime soldAt;
}
