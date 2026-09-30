import '../../../accounts/domain/entities/account_entities.dart';
import '../entities/pos_entities.dart';

abstract class PosRepository {
  Future<List<PosProduct>> getProducts();

  Future<List<String>> getCategories();

  Future<List<AccountItem>> getPaymentAccounts();

  Future<List<PosCustomer>> getCustomers();

  Future<List<HeldSaleSummary>> getHeldSales();

  Future<HeldSaleSummary> holdSale({
    required List<CartLine> lines,
    required double cartDiscount,
    required CartDiscountMode cartDiscountMode,
    String? customerName,
    int? customerId,
    String? notes,
  });

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
  resumeSale(int heldSaleId);

  Future<void> deleteHeldSale(int heldSaleId);
  Future<void> restoreHeldSale(int heldSaleId);

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
  });
}
