import '../entities/supplier_entities.dart';

abstract class SuppliersRepository {
  Future<List<SupplierProfile>> getSuppliers({String query = ''});

  Future<List<SupplierPurchaseSummary>> getSupplierPurchases(int supplierId);

  Future<SupplierItem> saveSupplier(SupplierDraft draft, {int? id});

  Future<void> recordPurchasePayment({
    required int purchaseId,
    required double amount,
  });

  /// Deletes a supplier. Throws [SupplierHasPurchasesException] if the supplier
  /// has any linked purchase records.
  Future<void> deleteSupplier(int id);
}

class SupplierHasPurchasesException implements Exception {
  const SupplierHasPurchasesException(this.supplierName, this.purchaseCount);

  final String supplierName;
  final int purchaseCount;

  @override
  String toString() =>
      'Cannot delete "$supplierName" — they have $purchaseCount purchase record(s). '
      'Remove the purchase history first.';
}
