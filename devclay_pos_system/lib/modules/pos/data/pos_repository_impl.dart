import '../../accounts/domain/entities/account_entities.dart';
import '../domain/entities/pos_entities.dart';
import '../domain/repositories/pos_repository.dart';
import 'datasources/pos_local_datasource.dart';

class PosRepositoryImpl implements PosRepository {
  PosRepositoryImpl(this._local);

  final PosLocalDataSource _local;

  @override
  Future<List<PosProduct>> getProducts() => _local.getProducts();

  @override
  Future<List<String>> getCategories() => _local.getCategories();

  @override
  Future<List<AccountItem>> getPaymentAccounts() => _local.getPaymentAccounts();

  @override
  Future<List<PosCustomer>> getCustomers() => _local.getCustomers();

  @override
  Future<List<HeldSaleSummary>> getHeldSales() => _local.getHeldSales();

  @override
  Future<HeldSaleSummary> holdSale({
    required List<CartLine> lines,
    required double cartDiscount,
    required CartDiscountMode cartDiscountMode,
    String? customerName,
    int? customerId,
    String? notes,
  }) {
    return _local.holdSale(
      lines: lines,
      cartDiscount: cartDiscount,
      cartDiscountMode: cartDiscountMode,
      customerName: customerName,
      customerId: customerId,
      notes: notes,
    );
  }

  @override
  Future<
    ({
      List<CartLine> lines,
      double cartDiscount,
      CartDiscountMode cartDiscountMode,
      String? customerName,
      int? customerId,
      String? notes,
    })
  >
  resumeSale(int heldSaleId) {
    return _local.resumeSale(heldSaleId);
  }

  @override
  Future<void> deleteHeldSale(int heldSaleId) {
    return _local.deleteHeldSale(heldSaleId);
  }

  @override
  Future<void> restoreHeldSale(int heldSaleId) {
    return _local.restoreHeldSale(heldSaleId);
  }

  @override
  Future<CompletedSale> completeSale({
    required List<CartLine> lines,
    required double cartDiscount,
    required CartDiscountMode cartDiscountMode,
    required PaymentMethodKind method,
    required double amountPaid,
    required double cardAmount,
    String? customerName,
    int? customerId,
    String? notes,
    int? cashAccountId,
    int? bankAccountId,
  }) {
    return _local.completeSale(
      lines: lines,
      cartDiscount: cartDiscount,
      cartDiscountMode: cartDiscountMode,
      method: method,
      amountPaid: amountPaid,
      cardAmount: cardAmount,
      customerName: customerName,
      customerId: customerId,
      notes: notes,
      cashAccountId: cashAccountId,
      bankAccountId: bankAccountId,
    );
  }
}
