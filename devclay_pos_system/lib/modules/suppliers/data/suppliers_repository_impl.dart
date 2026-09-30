import '../domain/entities/supplier_entities.dart';
import '../domain/repositories/suppliers_repository.dart';
import 'datasources/suppliers_local_datasource.dart';

class SuppliersRepositoryImpl implements SuppliersRepository {
  SuppliersRepositoryImpl(this._local);

  final SuppliersLocalDataSource _local;

  @override
  Future<List<SupplierProfile>> getSuppliers({String query = ''}) {
    return _local.getSuppliers(query: query);
  }

  @override
  Future<List<SupplierPurchaseSummary>> getSupplierPurchases(int supplierId) {
    return _local.getSupplierPurchases(supplierId);
  }

  @override
  Future<SupplierItem> saveSupplier(SupplierDraft draft, {int? id}) {
    return _local.saveSupplier(draft, id: id);
  }

  @override
  Future<void> recordPurchasePayment({
    required int purchaseId,
    required double amount,
  }) {
    return _local.recordPurchasePayment(
      purchaseId: purchaseId,
      amount: amount,
    );
  }

  @override
  Future<void> deleteSupplier(int id) {
    return _local.deleteSupplier(id);
  }
}
