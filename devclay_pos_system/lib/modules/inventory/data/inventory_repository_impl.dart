import '../domain/entities/inventory_entities.dart';
import '../domain/repositories/inventory_repository.dart';
import 'datasources/inventory_local_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(this._local);

  final InventoryLocalDataSource _local;

  @override
  Future<List<InventoryProduct>> getProducts({String query = ''}) {
    return _local.getProducts(query: query);
  }

  @override
  Future<List<StockMovementItem>> getMovements({int limit = 100}) {
    return _local.getMovements(limit: limit);
  }

  @override
  Future<InventoryProductDetail> getProductDetail(int productId) {
    return _local.getProductDetail(productId);
  }

  @override
  Future<void> adjustStock(StockAdjustRequest request) {
    return _local.adjustStock(request);
  }
}
