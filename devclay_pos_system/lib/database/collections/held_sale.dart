import 'package:isar_community/isar.dart';

part 'held_sale.g.dart';

@collection
class HeldSale {
  Id id = Isar.autoIncrement;

  late String holdCode;
  int? customerId;
  late String? customerName;
  late String? notes;
  late String itemsJson;

  /// Cart discount rate 0–100 (percent of subtotal), not a fixed amount.
  late double discountAmount;

  /// When true, [discountAmount] is a percent; otherwise a fixed rupee amount.
  bool discountIsPercent = true;
  late DateTime heldAt;

  /// When set, held bill is in the Recycle Bin.
  DateTime? deletedAt;
}
