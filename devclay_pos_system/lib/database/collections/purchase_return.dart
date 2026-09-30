import 'package:isar_community/isar.dart';

part 'purchase_return.g.dart';

@collection
class PurchaseReturn {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String returnNo;
  @Index()
  late int purchaseId;
  late String invoiceNo;
  late int supplierId;
  late String supplierName;
  late String linesJson;
  late double total;
  late String reason;
  int? userId;
  String? userName;

  @Index()
  late DateTime returnedAt;
}
