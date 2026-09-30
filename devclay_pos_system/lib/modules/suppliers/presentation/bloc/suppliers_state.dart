part of 'suppliers_bloc.dart';

enum SuppliersTab { all, active, withDue, topSuppliers }

enum SuppliersSort {
  nameAZ,
  nameZA,
  recentlyAdded,
  oldestFirst,
  highestDue,
  highestPurchase,
}

sealed class SuppliersState extends Equatable {
  const SuppliersState();

  @override
  List<Object?> get props => [];
}

class SuppliersInitial extends SuppliersState {
  const SuppliersInitial();
}

class SuppliersLoading extends SuppliersState {
  const SuppliersLoading();
}

class SuppliersError extends SuppliersState {
  const SuppliersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SuppliersLoaded extends SuppliersState {
  const SuppliersLoaded({
    required this.suppliers,
    required this.query,
    required this.tab,
    this.sort = SuppliersSort.nameAZ,
    this.message,
    this.selectedSupplierId,
    this.selectedSupplierName,
    this.selectedPurchases = const [],
  });

  final List<SupplierProfile> suppliers;
  final String query;
  final SuppliersTab tab;
  final SuppliersSort sort;
  final String? message;
  final int? selectedSupplierId;
  final String? selectedSupplierName;
  final List<SupplierPurchaseSummary> selectedPurchases;

  double get totalDue {
    var give = 0.0;
    for (final supplier in suppliers) {
      final net = KhataBalanceRules.money(supplier.totalDue);
      if (net > 0.001) give += net;
    }
    return give;
  }

  double get totalPurchased => suppliers.fold<double>(
        0,
        (sum, supplier) => sum + supplier.totalPurchased,
      );

  List<SupplierProfile> get visibleSuppliers {
    final q = query.trim().toLowerCase();
    Iterable<SupplierProfile> base = switch (tab) {
      SuppliersTab.all => suppliers,
      SuppliersTab.active => suppliers.where((s) => s.isActive),
      SuppliersTab.withDue => suppliers.where((s) => s.hasDue),
      SuppliersTab.topSuppliers => suppliers,
    };

    // Apply search filter
    if (q.isNotEmpty) {
      base = base.where((supplier) {
        return supplier.name.toLowerCase().contains(q) ||
            supplier.phone.contains(q) ||
            (supplier.email?.toLowerCase().contains(q) ?? false) ||
            (supplier.address?.toLowerCase().contains(q) ?? false);
      });
    }

    // Apply sort
    final list = base.toList();
    switch (sort) {
      case SuppliersSort.nameAZ:
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case SuppliersSort.nameZA:
        list.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
      case SuppliersSort.recentlyAdded:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SuppliersSort.oldestFirst:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case SuppliersSort.highestDue:
        list.sort((a, b) => b.totalDue.compareTo(a.totalDue));
      case SuppliersSort.highestPurchase:
        list.sort((a, b) => b.totalPurchased.compareTo(a.totalPurchased));
    }

    return list;
  }

  SuppliersLoaded copyWith({
    List<SupplierProfile>? suppliers,
    String? query,
    SuppliersTab? tab,
    SuppliersSort? sort,
    String? message,
    bool clearMessage = false,
    int? selectedSupplierId,
    String? selectedSupplierName,
    List<SupplierPurchaseSummary>? selectedPurchases,
    bool clearSelected = false,
  }) {
    return SuppliersLoaded(
      suppliers: suppliers ?? this.suppliers,
      query: query ?? this.query,
      tab: tab ?? this.tab,
      sort: sort ?? this.sort,
      message: clearMessage ? null : message ?? this.message,
      selectedSupplierId:
          clearSelected ? null : selectedSupplierId ?? this.selectedSupplierId,
      selectedSupplierName: clearSelected
          ? null
          : selectedSupplierName ?? this.selectedSupplierName,
      selectedPurchases: clearSelected
          ? const []
          : selectedPurchases ?? this.selectedPurchases,
    );
  }

  @override
  List<Object?> get props => [
        suppliers,
        query,
        tab,
        sort,
        message,
        selectedSupplierId,
        selectedSupplierName,
        selectedPurchases,
      ];
}

