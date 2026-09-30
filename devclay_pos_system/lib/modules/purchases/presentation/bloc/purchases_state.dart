part of 'purchases_bloc.dart';

enum PurchasesTab { purchases, due, suppliers }

enum SupplierFilter { all, active, inactive, hasDue, cleared }

sealed class PurchasesState extends Equatable {
  const PurchasesState();

  @override
  List<Object?> get props => [];
}

class PurchasesInitial extends PurchasesState {
  const PurchasesInitial();
}

class PurchasesLoading extends PurchasesState {
  const PurchasesLoading();
}

class PurchasesError extends PurchasesState {
  const PurchasesError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PurchasesLoaded extends PurchasesState {
  const PurchasesLoaded({
    required this.purchases,
    required this.suppliers,
    required this.products,
    required this.query,
    required this.tab,
    this.supplierFilter = SupplierFilter.all,
    this.message,
  });

  final List<PurchaseRecord> purchases;
  final List<SupplierItem> suppliers;
  final List<PurchaseProductOption> products;
  final String query;
  final PurchasesTab tab;
  final SupplierFilter supplierFilter;
  final String? message;

  double supplierInvoiceDue(int supplierId) => purchases
      .where((purchase) => purchase.supplierId == supplierId)
      .fold<double>(
        0,
        (sum, purchase) => sum + KhataBalanceRules.money(purchase.dueAmount),
      );

  double supplierBalance(int supplierId) {
    for (final supplier in suppliers) {
      if (supplier.id == supplierId) {
        return KhataBalanceRules.money(supplier.balance);
      }
    }
    return 0;
  }

  double supplierDue(int supplierId) =>
      supplierInvoiceDue(supplierId) + supplierBalance(supplierId);

  double get totalDue {
    var give = 0.0;
    for (final supplier in suppliers) {
      final net = supplierDue(supplier.id);
      if (net > 0.001) give += net;
    }
    return give;
  }

  double get totalPurchases => purchases.fold<double>(
        0,
        (sum, purchase) => sum + purchase.total,
      );

  List<PurchaseRecord> get visiblePurchases {
    final q = query.trim().toLowerCase();
    Iterable<PurchaseRecord> base = switch (tab) {
      PurchasesTab.purchases => purchases,
      PurchasesTab.due => purchases.where((p) => p.dueAmount > 0),
      PurchasesTab.suppliers => purchases,
    };
    if (q.isEmpty) return base.toList();
    return base.where((purchase) {
      return purchase.supplierName.toLowerCase().contains(q) ||
          purchase.invoiceNo.toLowerCase().contains(q) ||
          purchase.lines.any(
            (line) =>
                line.productName.toLowerCase().contains(q) ||
                line.productSku.toLowerCase().contains(q),
          );
    }).toList();
  }

  List<SupplierItem> get visibleSuppliers {
    Iterable<SupplierItem> base = switch (supplierFilter) {
      SupplierFilter.all => suppliers,
      SupplierFilter.active => suppliers.where((s) => s.isActive),
      SupplierFilter.inactive => suppliers.where((s) => !s.isActive),
      SupplierFilter.hasDue =>
        suppliers.where((s) => supplierDue(s.id) > 0.009),
      SupplierFilter.cleared =>
        suppliers.where((s) => supplierDue(s.id).abs() <= 0.009),
    };
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return base.toList();
    return base.where((supplier) {
      return supplier.name.toLowerCase().contains(q) ||
          supplier.phone.contains(q) ||
          (supplier.email?.toLowerCase().contains(q) ?? false) ||
          (supplier.address?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  List<PurchaseRecord> purchasesForSupplier(int supplierId) => purchases
      .where((purchase) => purchase.supplierId == supplierId)
      .toList()
    ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

  PurchasesLoaded copyWith({
    List<PurchaseRecord>? purchases,
    List<SupplierItem>? suppliers,
    List<PurchaseProductOption>? products,
    String? query,
    PurchasesTab? tab,
    SupplierFilter? supplierFilter,
    String? message,
    bool clearMessage = false,
  }) {
    return PurchasesLoaded(
      purchases: purchases ?? this.purchases,
      suppliers: suppliers ?? this.suppliers,
      products: products ?? this.products,
      query: query ?? this.query,
      tab: tab ?? this.tab,
      supplierFilter: supplierFilter ?? this.supplierFilter,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    purchases,
    suppliers,
    products,
    query,
    tab,
    supplierFilter,
    message,
  ];
}
