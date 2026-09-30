import '../entities/customer_entities.dart';

abstract class CustomersRepository {
  Future<List<CustomerItem>> getCustomers({String query = ''});

  Future<List<CustomerSaleSummary>> getCustomerSales(String customerName);

  Future<List<CustomerKhataEntry>> getKhataLedger(int customerId);

  Future<CustomerItem> saveCustomer(CustomerDraft draft, {int? id});

  Future<CustomerItem> recordPayment({
    required int customerId,
    required double amount,
    String? note,
  });

  Future<CustomerItem> adjustBalance({
    required int customerId,
    required double amountChange,
    String? note,
  });
}
