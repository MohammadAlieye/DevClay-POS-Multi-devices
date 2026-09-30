part of 'pos_bloc.dart';

sealed class PosState extends Equatable {
  const PosState();

  @override
  List<Object?> get props => [];
}

final class PosInitial extends PosState {
  const PosInitial();
}

final class PosLoading extends PosState {
  const PosLoading();
}

final class PosError extends PosState {
  const PosError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class PosReady extends PosState {
  const PosReady({
    required this.allProducts,
    required this.categories,
    required this.selectedCategory,
    this.stockFilter = PosStockFilter.all,
    required this.query,
    required this.lines,
    required this.cartDiscount,
    required this.cartDiscountMode,
    required this.heldSales,
    this.customers = const [],
    this.selectedCustomerId,
    this.customerName,
    this.notes,
    this.checkoutOpen = false,
    this.message,
    this.lastSale,
  });

  final List<PosProduct> allProducts;
  final List<String> categories;
  final String selectedCategory;
  final PosStockFilter stockFilter;
  final String query;
  final List<CartLine> lines;
  final double cartDiscount;
  final CartDiscountMode cartDiscountMode;
  final List<HeldSaleSummary> heldSales;
  final List<PosCustomer> customers;
  final int? selectedCustomerId;
  final String? customerName;
  final String? notes;
  final bool checkoutOpen;
  final String? message;
  final CompletedSale? lastSale;

  List<PosProduct> get visibleProducts {
    final q = query.trim().toLowerCase();
    return allProducts.where((product) {
      final matchesCategory =
          selectedCategory == 'All' || product.category == selectedCategory;
      if (!matchesCategory) return false;

      final matchesStock = switch (stockFilter) {
        PosStockFilter.all => true,
        PosStockFilter.expired => product.isExpired,
        PosStockFilter.lowStock => product.isLowStock,
      };
      if (!matchesStock) return false;

      if (q.isEmpty) return true;
      return product.name.toLowerCase().contains(q) ||
          product.sku.toLowerCase().contains(q) ||
          product.barcode.toLowerCase().contains(q);
    }).toList();
  }

  /// Units of [productId] currently in the cart.
  int cartQtyFor(int productId) {
    var qty = 0;
    for (final line in lines) {
      if (line.product.id == productId) {
        qty += line.quantity;
      }
    }
    return qty;
  }

  /// Shelf stock minus what is already in this cart (live for the product grid).
  int availableStockFor(PosProduct product) =>
      (product.stock - cartQtyFor(product.id)).clamp(0, product.stock);

  CartTotals get totals {
    final subtotal = lines.fold<double>(
      0,
      (sum, line) => sum + line.subtotalBeforeTax,
    );
    final tax = lines.fold<double>(0, (sum, line) => sum + line.taxAmount);
    final lineDiscounts = lines.fold<double>(
      0,
      (sum, line) => sum + line.discountAmount,
    );
    final cartDiscountValue = resolveCartDiscountAmount(
      lines,
      cartDiscount,
      cartDiscountMode,
    );
    final total = (subtotal + tax - cartDiscountValue)
        .clamp(0, double.infinity)
        .roundToDouble();
    final itemCount =
        lines.fold<int>(0, (sum, line) => sum + line.cartCountContribution);
    return CartTotals(
      subtotal: subtotal,
      discount: lineDiscounts + cartDiscountValue,
      tax: tax,
      total: total.toDouble(),
      itemCount: itemCount,
    );
  }

  PosReady copyWith({
    List<PosProduct>? allProducts,
    List<String>? categories,
    String? selectedCategory,
    PosStockFilter? stockFilter,
    String? query,
    List<CartLine>? lines,
    double? cartDiscount,
    CartDiscountMode? cartDiscountMode,
    List<HeldSaleSummary>? heldSales,
    List<PosCustomer>? customers,
    int? selectedCustomerId,
    String? customerName,
    String? notes,
    bool? checkoutOpen,
    String? message,
    CompletedSale? lastSale,
    bool clearCustomer = false,
    bool clearSelectedCustomer = false,
    bool clearNotes = false,
    bool clearMessage = false,
    bool clearLastSale = false,
  }) {
    return PosReady(
      allProducts: allProducts ?? this.allProducts,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      stockFilter: stockFilter ?? this.stockFilter,
      query: query ?? this.query,
      lines: lines ?? this.lines,
      cartDiscount: cartDiscount ?? this.cartDiscount,
      cartDiscountMode: cartDiscountMode ?? this.cartDiscountMode,
      heldSales: heldSales ?? this.heldSales,
      customers: customers ?? this.customers,
      selectedCustomerId: clearCustomer || clearSelectedCustomer
          ? null
          : (selectedCustomerId ?? this.selectedCustomerId),
      customerName: clearCustomer ? null : (customerName ?? this.customerName),
      notes: clearNotes ? null : (notes ?? this.notes),
      checkoutOpen: checkoutOpen ?? this.checkoutOpen,
      message: clearMessage ? null : (message ?? this.message),
      lastSale: clearLastSale ? null : (lastSale ?? this.lastSale),
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    categories,
    selectedCategory,
    stockFilter,
    query,
    lines,
    cartDiscount,
    cartDiscountMode,
    heldSales,
    customers,
    selectedCustomerId,
    customerName,
    notes,
    checkoutOpen,
    message,
    lastSale,
  ];
}
