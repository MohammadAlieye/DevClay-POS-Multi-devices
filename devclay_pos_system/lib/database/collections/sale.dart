import 'package:isar_community/isar.dart';

part 'sale.g.dart';

@collection
class Sale {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String invoiceNo;

  late String customerName;
  int? customerId;
  late String paymentMethod;
  late double subtotal;
  late double discount;
  late double tax;
  late double total;
  late double amountPaid;
  late double changeAmount;
  late int itemCount;
  late String linesJson;
  String? notes;
  int? cashierId;
  String? cashierName;
  String status = 'completed';
  double returnedAmount = 0;

  @Index()
  late DateTime soldAt;
}
