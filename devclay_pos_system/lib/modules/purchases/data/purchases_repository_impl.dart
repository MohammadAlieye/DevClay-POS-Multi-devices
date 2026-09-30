import '../domain/entities/purchase_entities.dart';
import '../domain/repositories/purchases_repository.dart';
import 'datasources/purchases_local_datasource.dart';

class PurchasesRepositoryImpl implements PurchasesRepository {
  PurchasesRepositoryImpl(this._local);

  final PurchasesLocalDataSource _local;

  @override
  Future<List<PurchaseRecord>> getPurchases({String query = ''}) {
    return _local.getPurchases(query: query);
  }

  @override
  Future<List<SupplierItem>> getSuppliers({String query = ''}) {
    return _local.getSuppliers(query: query);
  }

  @override
  Future<List<PurchaseProductOption>> getProductOptions() {
    return _local.getProductOptions();
  }

  @override
  Future<PurchaseRecord> createPurchase(PurchaseDraft draft) {
    return _local.createPurchase(draft);
  }

  @override
  Future<PurchaseRecord> recordPayment({
    required int purchaseId,
    required double amount,
  }) {
    return _local.recordPayment(purchaseId: purchaseId, amount: amount);
  }

  @override
  Future<void> recordSupplierPayment({
    required int supplierId,
    required double amount,
  }) {
    return _local.recordSupplierPayment(supplierId: supplierId, amount: amount);
  }

  @override
  Future<SupplierItem> saveSupplier(SupplierDraft draft, {int? id}) {
    return _local.saveSupplier(draft, id: id);
  }

  @override
  Future<SupplierItem> adjustSupplierBalance({
    required int supplierId,
    required double amountChange,
    String? note,
  }) {
    return _local.adjustSupplierBalance(
      supplierId: supplierId,
      amountChange: amountChange,
      note: note,
    );
  }

  @override
  Future<double> processPurchaseReturn(PurchaseReturnRequest request) {
    return _local.processPurchaseReturn(request);
  }
}
