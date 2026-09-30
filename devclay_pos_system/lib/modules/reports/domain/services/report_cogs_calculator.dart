/// Computes line cost of goods sold using batch allocations when available.
abstract final class ReportCogsCalculator {
  /// Resolves unit cost for a sale line using FEFO batch allocations first,
  /// then falls back to [productCosts] for unallocated quantity.
  static double lineCost({
    required Map<String, dynamic> line,
    required Map<int, double> batchCosts,
    required Map<int, double> productCosts,
  }) {
    final productId = line['productId'] as int;
    final totalQty = line['quantity'] as int;
    final fallbackUnitCost = productCosts[productId] ?? 0;

    final rawAllocations = line['batchAllocations'];
    if (rawAllocations is! List || rawAllocations.isEmpty) {
      return fallbackUnitCost * totalQty;
    }

    var cost = 0.0;
    var allocatedQty = 0;
    for (final raw in rawAllocations) {
      if (raw is! Map) continue;
      final batchId = raw['batchId'] as int?;
      final qty = raw['quantity'] as int? ?? 0;
      if (batchId == null || qty <= 0) continue;
      allocatedQty += qty;
      final unitCost = batchCosts[batchId] ?? fallbackUnitCost;
      cost += unitCost * qty;
    }

    final remainder = totalQty - allocatedQty;
    if (remainder > 0) {
      cost += fallbackUnitCost * remainder;
    }

    return cost;
  }

  static double lineProfit({
    required Map<String, dynamic> line,
    required Map<int, double> batchCosts,
    required Map<int, double> productCosts,
  }) {
    final lineTotal = (line['lineTotal'] as num).toDouble();
    return lineTotal - lineCost(
      line: line,
      batchCosts: batchCosts,
      productCosts: productCosts,
    );
  }
}
