import '../entities/inventory_entities.dart';

abstract class InventoryRepository {
  Future<List<InventoryProduct>> getProducts({String query = ''});

  Future<List<StockMovementItem>> getMovements({int limit = 100});

  Future<InventoryProductDetail> getProductDetail(int productId);

  Future<void> adjustStock(StockAdjustRequest request);
}
