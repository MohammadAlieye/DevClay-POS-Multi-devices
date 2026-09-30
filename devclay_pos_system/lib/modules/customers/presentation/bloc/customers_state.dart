part of 'customers_bloc.dart';

enum CustomersTab { all, toTake, toGive, topBuyers }

sealed class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object?> get props => [];
}

class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

class CustomersError extends CustomersState {
  const CustomersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CustomersLoaded extends CustomersState {
  const CustomersLoaded({
    required this.customers,
    required this.query,
    required this.tab,
    this.message,
    this.selectedCustomerSales = const [],
    this.selectedKhataEntries = const [],
    this.selectedCustomerName,
  });

  final List<CustomerItem> customers;
  final String query;
  final CustomersTab tab;
  final String? message;
  final List<CustomerSaleSummary> selectedCustomerSales;
  final List<CustomerKhataEntry> selectedKhataEntries;
  final String? selectedCustomerName;

  double get totalToTake => customers
      .where((c) => c.customerOwesShop)
      .fold(0.0, (sum, c) => sum + c.balance);

  double get totalToGive => customers
      .where((c) => c.shopOwesCustomer)
      .fold(0.0, (sum, c) => sum + c.balance.abs());

  int get takeCount => customers.where((c) => c.customerOwesShop).length;

  int get giveCount => customers.where((c) => c.shopOwesCustomer).length;

  List<CustomerItem> get visibleCustomers {
    final q = query.trim().toLowerCase();
    Iterable<CustomerItem> base = switch (tab) {
      CustomersTab.all => customers,
      CustomersTab.toTake => customers.where((c) => c.customerOwesShop),
      CustomersTab.toGive => customers.where((c) => c.shopOwesCustomer),
      CustomersTab.topBuyers => customers,
    };

    if (tab == CustomersTab.topBuyers) {
      final sorted = base.toList()
        ..sort((a, b) => b.totalPurchases.compareTo(a.totalPurchases));
      base = sorted;
    }

    if (q.isEmpty) return base.toList();
    return base.where((customer) {
      return customer.name.toLowerCase().contains(q) ||
          customer.phone.contains(q) ||
          (customer.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  CustomersLoaded copyWith({
    List<CustomerItem>? customers,
    String? query,
    CustomersTab? tab,
    String? message,
    bool clearMessage = false,
    List<CustomerSaleSummary>? selectedCustomerSales,
    List<CustomerKhataEntry>? selectedKhataEntries,
    String? selectedCustomerName,
    bool clearSelectedSales = false,
  }) {
    return CustomersLoaded(
      customers: customers ?? this.customers,
      query: query ?? this.query,
      tab: tab ?? this.tab,
      message: clearMessage ? null : message ?? this.message,
      selectedCustomerSales: clearSelectedSales
          ? const []
          : selectedCustomerSales ?? this.selectedCustomerSales,
      selectedKhataEntries: clearSelectedSales
          ? const []
          : selectedKhataEntries ?? this.selectedKhataEntries,
      selectedCustomerName: clearSelectedSales
          ? null
          : selectedCustomerName ?? this.selectedCustomerName,
    );
  }

  @override
  List<Object?> get props => [
        customers,
        query,
        tab,
        message,
        selectedCustomerSales,
        selectedKhataEntries,
        selectedCustomerName,
      ];
}
