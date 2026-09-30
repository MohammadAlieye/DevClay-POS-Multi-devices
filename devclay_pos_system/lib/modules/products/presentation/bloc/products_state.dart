part of 'products_bloc.dart';

enum ProductsListFilter {
  all,
  active,
  inactive,
  lowStock,
  outOfStock,
  expired,
  expiringSoon,
  noExpiry,
}

enum ProductsListSort {
  nameAsc,
  nameDesc,
  stockLowHigh,
  stockHighLow,
  priceLowHigh,
  priceHighLow,
  expirySoonest,
  expiryLatest,
}

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

final class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

final class ProductsError extends ProductsState {
  const ProductsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded({
    required this.products,
    required this.categories,
    required this.query,
    this.filter = ProductsListFilter.all,
    this.sort = ProductsListSort.nameAsc,
    this.message,
    this.isRefreshing = false,
  });

  final List<ProductItem> products;
  final List<String> categories;
  final String query;
  final ProductsListFilter filter;
  final ProductsListSort sort;
  final String? message;
  final bool isRefreshing;

  List<ProductItem> get visibleProducts {
    final filtered = products.where(_matchesFilter).toList();
    filtered.sort(_compare);
    return filtered;
  }

  bool _matchesFilter(ProductItem product) {
    return switch (filter) {
      ProductsListFilter.all => true,
      ProductsListFilter.active => product.isActive,
      ProductsListFilter.inactive => !product.isActive,
      ProductsListFilter.lowStock =>
        product.isActive && product.isLowStock && !product.isOutOfStock,
      ProductsListFilter.outOfStock => product.isOutOfStock,
      ProductsListFilter.expired => product.isExpired,
      ProductsListFilter.expiringSoon => product.isExpiringSoon(),
      ProductsListFilter.noExpiry => product.expiryDate == null,
    };
  }

  int _compare(ProductItem a, ProductItem b) {
    return switch (sort) {
      ProductsListSort.nameAsc =>
        a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ProductsListSort.nameDesc =>
        b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      ProductsListSort.stockLowHigh => a.stock.compareTo(b.stock),
      ProductsListSort.stockHighLow => b.stock.compareTo(a.stock),
      ProductsListSort.priceLowHigh =>
        a.sellingPrice.compareTo(b.sellingPrice),
      ProductsListSort.priceHighLow =>
        b.sellingPrice.compareTo(a.sellingPrice),
      ProductsListSort.expirySoonest => _compareExpiry(a, b, ascending: true),
      ProductsListSort.expiryLatest => _compareExpiry(a, b, ascending: false),
    };
  }

  int _compareExpiry(ProductItem a, ProductItem b, {required bool ascending}) {
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

  ProductsLoaded copyWith({
    List<ProductItem>? products,
    List<String>? categories,
    String? query,
    ProductsListFilter? filter,
    ProductsListSort? sort,
    String? message,
    bool? isRefreshing,
    bool clearMessage = false,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
      message: clearMessage ? null : (message ?? this.message),
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props =>
      [products, categories, query, filter, sort, message, isRefreshing];
}
