import 'package:isar_community/isar.dart';

part 'purchase.g.dart';

@collection
class Purchase {
  Id id = Isar.autoIncrement;

  @Index()
  late int supplierId;

  late String supplierName;

  @Index()
  late String invoiceNo;

  @Index()
  late DateTime purchaseDate;

  late String linesJson;
  late double subtotal;
  late double taxAmount;
  late double total;
  late double paidAmount;
  late double dueAmount;

  /// open | paid
  late String status;
  String? notes;
  late DateTime createdAt;
}
