import '../entities/sale_entities.dart';

abstract class SalesRepository {
  Future<List<SaleRecord>> getSales({String query = ''});

  Future<SaleRecord?> getSaleById(int id);

  Future<SaleRecord?> getSaleByInvoice(String invoiceNo);

  Future<SaleReturnResult> processReturn(SaleReturnRequest request);

  Future<List<SaleReturnRecord>> getReturns();
}
