import 'package:isar_community/isar.dart';

import 'collections/supplier.dart';

/// Backfills `Supplier.balance` for rows created before the field existed.
/// Unset Isar doubles read as NaN and make "To give" show as NaN.
abstract final class SupplierBalanceMigration {
  static Future<void> runIfNeeded(Isar isar) async {
    final suppliers = await isar.suppliers.where().findAll();
    final broken = suppliers
        .where((supplier) => !supplier.balance.isFinite)
        .toList();
    if (broken.isEmpty) return;

    await isar.writeTxn(() async {
      for (final supplier in broken) {
        supplier.balance = 0;
        await isar.suppliers.put(supplier);
      }
    });
  }
}
