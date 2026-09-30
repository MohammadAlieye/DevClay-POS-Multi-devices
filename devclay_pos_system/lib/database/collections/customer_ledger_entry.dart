import 'package:isar_community/isar.dart';

part 'customer_ledger_entry.g.dart';

/// Immutable khata transaction. Debit increases customer due; credit reduces it.
@collection
class CustomerLedgerEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late int customerId;

  late String customerName;

  /// debit | credit
  late String type;
  late double amount;
  late double balanceAfter;

  String? reference;
  String? note;

  @Index()
  late DateTime entryDate;
  late DateTime createdAt;
}
