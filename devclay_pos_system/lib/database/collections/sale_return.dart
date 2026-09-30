import 'package:isar_community/isar.dart';

part 'sale_return.g.dart';

@collection
class SaleReturn {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String returnNo;
  @Index()
  late int saleId;
  late String invoiceNo;
  int? customerId;
  String? customerName;
  late String linesJson;
  late double refundAmount;
  late String refundMethod;
  late String reason;
  bool isVoid = false;
  int? cashierId;
  String? cashierName;
  int? approvedById;
  String? approvedByName;

  @Index()
  late DateTime returnedAt;
}
