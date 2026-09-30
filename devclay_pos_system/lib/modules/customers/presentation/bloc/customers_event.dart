part of 'customers_bloc.dart';

sealed class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object?> get props => [];
}

class CustomersStarted extends CustomersEvent {
  const CustomersStarted();
}

class CustomersSearchChanged extends CustomersEvent {
  const CustomersSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class CustomersTabChanged extends CustomersEvent {
  const CustomersTabChanged(this.tab);

  final CustomersTab tab;

  @override
  List<Object?> get props => [tab];
}

class CustomerSaved extends CustomersEvent {
  const CustomerSaved({required this.draft, this.id});

  final CustomerDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

class CustomerPaymentRecorded extends CustomersEvent {
  const CustomerPaymentRecorded({
    required this.customerId,
    required this.amount,
    this.note,
  });

  final int customerId;
  final double amount;
  final String? note;

  @override
  List<Object?> get props => [customerId, amount, note];
}

class CustomerBalanceAdjusted extends CustomersEvent {
  const CustomerBalanceAdjusted({
    required this.customerId,
    required this.amountChange,
    this.note,
  });

  final int customerId;
  final double amountChange;
  final String? note;

  @override
  List<Object?> get props => [customerId, amountChange, note];
}

class CustomersRefreshRequested extends CustomersEvent {
  const CustomersRefreshRequested();
}

class CustomersMessageDismissed extends CustomersEvent {
  const CustomersMessageDismissed();
}

class CustomerSalesRequested extends CustomersEvent {
  const CustomerSalesRequested({
    required this.customerId,
    required this.customerName,
  });

  final int customerId;
  final String customerName;

  @override
  List<Object?> get props => [customerId, customerName];
}
