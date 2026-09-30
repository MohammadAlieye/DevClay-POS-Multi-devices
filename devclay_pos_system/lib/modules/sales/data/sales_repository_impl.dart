import '../domain/entities/sale_entities.dart';
import '../domain/repositories/sales_repository.dart';
import 'datasources/sales_local_datasource.dart';

class SalesRepositoryImpl implements SalesRepository {
  SalesRepositoryImpl(this._local);

  final SalesLocalDataSource _local;

  @override
  Future<List<SaleRecord>> getSales({String query = ''}) {
    return _local.getSales(query: query);
  }

  @override
  Future<SaleRecord?> getSaleById(int id) {
    return _local.getSaleById(id);
  }

  @override
  Future<SaleRecord?> getSaleByInvoice(String invoiceNo) {
    return _local.getSaleByInvoice(invoiceNo);
  }

  @override
  Future<SaleReturnResult> processReturn(SaleReturnRequest request) {
    return _local.processReturn(request);
  }

  @override
  Future<List<SaleReturnRecord>> getReturns() => _local.getReturns();
}
