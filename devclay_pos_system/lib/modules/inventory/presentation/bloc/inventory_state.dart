part of 'inventory_bloc.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {
  const InventoryInitial();
}

class InventoryLoading extends InventoryState {
  const InventoryLoading();
}

class InventoryError extends InventoryState {
  const InventoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class InventoryLoaded extends InventoryState {
  const InventoryLoaded({
    required this.products,
    required this.movements,
    required this.query,
    required this.tab,
    this.filter = InventoryListFilter.all,
    this.sort = InventoryListSort.nameAsc,
    this.message,
  });

  final List<InventoryProduct> products;
  final List<StockMovementItem> movements;
  final String query;
  final InventoryTab tab;
  final InventoryListFilter filter;
  final InventoryListSort sort;
  final String? message;

  List<InventoryProduct> get visibleProducts {
    final q = query.trim().toLowerCase();
    var base = products.where(_matchesFilter).toList();
    if (q.isNotEmpty) {
      base = base.where((product) {
        return product.name.toLowerCase().contains(q) ||
            product.sku.toLowerCase().contains(q) ||
            product.category.toLowerCase().contains(q);
      }).toList();
    }
    base.sort(_compare);
    return base;
  }

  bool _matchesFilter(InventoryProduct product) {
    return switch (filter) {
      InventoryListFilter.all => true,
      InventoryListFilter.lowStock =>
        product.isActive && product.isLowStock && !product.isOutOfStock,
      InventoryListFilter.outOfStock => product.isOutOfStock,
      InventoryListFilter.expired => product.isExpired,
      InventoryListFilter.expiringSoon => product.isExpiringSoon(),
      InventoryListFilter.noExpiry => product.expiryDate == null,
      InventoryListFilter.inactive => !product.isActive,
    };
  }

  int _compare(InventoryProduct a, InventoryProduct b) {
    return switch (sort) {
      InventoryListSort.nameAsc =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      InventoryListSort.nameDesc =>
        b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      InventoryListSort.stockLowHigh => a.stock.compareTo(b.stock),
      InventoryListSort.stockHighLow => b.stock.compareTo(a.stock),
      InventoryListSort.valueHighLow => b.stockValue.compareTo(a.stockValue),
      InventoryListSort.expirySoonest => _compareExpiry(a, b, ascending: true),
      InventoryListSort.expiryLatest => _compareExpiry(a, b, ascending: false),
    };
  }

  int _compareExpiry(
    InventoryProduct a,
    InventoryProduct b, {
    required bool ascending,
  }) {
    final aDate = a.expiryDate;
    final bDate = b.expiryDate;
    if (aDate == null && bDate == null) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    }
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    final compared = aDate.compareTo(bDate);
    return ascending ? compared : -compared;
  }

  int get totalUnits => products.fold(0, (sum, p) => sum + p.stock);

  double get totalStockValue =>
      products.fold(0, (sum, p) => sum + p.stockValue);

  int get lowStockCount =>
      products.where((p) => p.isLowStock && !p.isOutOfStock).length;

  int get expiredCount => products.where((p) => p.isExpired).length;

  int get expiringSoonCount =>
      products.where((p) => p.isExpiringSoon()).length;

  InventoryLoaded copyWith({
    List<InventoryProduct>? products,
    List<StockMovementItem>? movements,
    String? query,
    InventoryTab? tab,
    InventoryListFilter? filter,
    InventoryListSort? sort,
    String? message,
    bool clearMessage = false,
  }) {
    return InventoryLoaded(
      products: products ?? this.products,
      movements: movements ?? this.movements,
      query: query ?? this.query,
      tab: tab ?? this.tab,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props =>
      [products, movements, query, tab, filter, sort, message];
}
