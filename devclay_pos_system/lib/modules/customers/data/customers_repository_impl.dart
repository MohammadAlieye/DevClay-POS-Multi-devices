import '../domain/entities/customer_entities.dart';
import '../domain/repositories/customers_repository.dart';
import 'datasources/customers_local_datasource.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl(this._local);

  final CustomersLocalDataSource _local;

  @override
  Future<List<CustomerItem>> getCustomers({String query = ''}) {
    return _local.getCustomers(query: query);
  }

  @override
  Future<List<CustomerSaleSummary>> getCustomerSales(String customerName) {
    return _local.getCustomerSales(customerName);
  }

  @override
  Future<List<CustomerKhataEntry>> getKhataLedger(int customerId) {
    return _local.getKhataLedger(customerId);
  }

  @override
  Future<CustomerItem> saveCustomer(CustomerDraft draft, {int? id}) {
    return _local.saveCustomer(draft, id: id);
  }

  @override
  Future<CustomerItem> recordPayment({
    required int customerId,
    required double amount,
    String? note,
  }) {
    return _local.recordPayment(
      customerId: customerId,
      amount: amount,
      note: note,
    );
  }

  @override
  Future<CustomerItem> adjustBalance({
    required int customerId,
    required double amountChange,
    String? note,
  }) {
    return _local.adjustBalance(
      customerId: customerId,
      amountChange: amountChange,
      note: note,
    );
  }
}
