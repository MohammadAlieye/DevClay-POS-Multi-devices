import 'package:isar_community/isar.dart';

import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/supplier.dart';
import '../../../../database/isar_service.dart';
import '../../../../utils/khata_balance.dart';
import '../../../purchases/data/datasources/purchases_local_datasource.dart';
import '../../domain/entities/supplier_entities.dart';
import '../../domain/repositories/suppliers_repository.dart'
    show SupplierHasPurchasesException;

class SuppliersLocalDataSource {
  SuppliersLocalDataSource(this._isarService, this._purchasesLocal);

  final IsarService _isarService;
  final PurchasesLocalDataSource _purchasesLocal;

  Future<List<SupplierProfile>> getSuppliers({String query = ''}) async {
    final isar = _isarService.instance;
    final suppliers = await isar.suppliers.where().sortByName().findAll();
    final purchases = await isar.purchases.where().findAll();

    final q = query.trim().toLowerCase();
    final profiles = suppliers
        .map((supplier) => _mapProfile(supplier, purchases))
        .toList();

    if (q.isEmpty) return profiles;
    return profiles.where((supplier) {
      return supplier.name.toLowerCase().contains(q) ||
          supplier.phone.contains(q) ||
          (supplier.email?.toLowerCase().contains(q) ?? false) ||
          (supplier.address?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  Future<List<SupplierPurchaseSummary>> getSupplierPurchases(
    int supplierId,
  ) async {
    final isar = _isarService.instance;
    final purchases = await isar.purchases
        .filter()
        .supplierIdEqualTo(supplierId)
        .sortByPurchaseDateDesc()
        .findAll();

    return purchases
        .map(
          (purchase) => SupplierPurchaseSummary(
            id: purchase.id,
            invoiceNo: purchase.invoiceNo,
            total: purchase.total,
            dueAmount: purchase.dueAmount,
            purchaseDate: purchase.purchaseDate,
            status: purchase.status,
          ),
        )
        .toList();
  }

  Future<SupplierItem> saveSupplier(SupplierDraft draft, {int? id}) {
    return _purchasesLocal.saveSupplier(draft, id: id);
  }

  Future<void> recordPurchasePayment({
    required int purchaseId,
    required double amount,
  }) async {
    await _purchasesLocal.recordPayment(
      purchaseId: purchaseId,
      amount: amount,
    );
  }

  Future<void> deleteSupplier(int id) async {
    final isar = _isarService.instance;
    final supplier = await isar.suppliers.get(id);
    if (supplier == null) return; // already gone

    final purchaseCount = await isar.purchases
        .filter()
        .supplierIdEqualTo(id)
        .count();

    if (purchaseCount > 0) {
      throw SupplierHasPurchasesException(supplier.name, purchaseCount);
    }

    await isar.writeTxn(() => isar.suppliers.delete(id));
  }

  SupplierProfile _mapProfile(Supplier supplier, List<Purchase> purchases) {
    final matched =
        purchases.where((purchase) => purchase.supplierId == supplier.id);
    final totalPurchased =
        matched.fold(0.0, (sum, purchase) => sum + purchase.total);
    final invoiceDue =
        matched.fold(0.0, (sum, purchase) => sum + purchase.dueAmount);
    final balance = KhataBalanceRules.money(supplier.balance);
    final totalDue = invoiceDue + balance;
    DateTime? lastPurchaseDate;
    for (final purchase in matched) {
      if (lastPurchaseDate == null ||
          purchase.purchaseDate.isAfter(lastPurchaseDate)) {
        lastPurchaseDate = purchase.purchaseDate;
      }
    }

    return SupplierProfile(
      id: supplier.id,
      name: supplier.name,
      phone: supplier.phone,
      isActive: supplier.isActive,
      purchaseCount: matched.length,
      totalPurchased: totalPurchased,
      totalDue: totalDue,
      balance: balance,
      createdAt: supplier.createdAt,
      email: supplier.email,
      address: supplier.address,
      notes: supplier.notes,
      lastPurchaseDate: lastPurchaseDate,
    );
  }
}
