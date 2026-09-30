import '../entities/purchase_entities.dart';

abstract class PurchasesRepository {
  Future<List<PurchaseRecord>> getPurchases({String query = ''});

  Future<List<SupplierItem>> getSuppliers({String query = ''});

  Future<List<PurchaseProductOption>> getProductOptions();

  Future<PurchaseRecord> createPurchase(PurchaseDraft draft);

  Future<PurchaseRecord> recordPayment({
    required int purchaseId,
    required double amount,
  });

  /// Pays [amount] against a supplier's opening balance (oldest) then open invoices.
  Future<void> recordSupplierPayment({
    required int supplierId,
    required double amount,
  });

  Future<SupplierItem> saveSupplier(SupplierDraft draft, {int? id});

  Future<SupplierItem> adjustSupplierBalance({
    required int supplierId,
    required double amountChange,
    String? note,
  });

  Future<double> processPurchaseReturn(PurchaseReturnRequest request);
}
