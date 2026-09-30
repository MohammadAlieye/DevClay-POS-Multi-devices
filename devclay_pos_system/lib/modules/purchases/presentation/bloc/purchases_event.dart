part of 'purchases_bloc.dart';

sealed class PurchasesEvent extends Equatable {
  const PurchasesEvent();

  @override
  List<Object?> get props => [];
}

class PurchasesStarted extends PurchasesEvent {
  const PurchasesStarted();
}

class PurchasesSearchChanged extends PurchasesEvent {
  const PurchasesSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class PurchasesTabChanged extends PurchasesEvent {
  const PurchasesTabChanged(this.tab);

  final PurchasesTab tab;

  @override
  List<Object?> get props => [tab];
}

class PurchasesSupplierFilterChanged extends PurchasesEvent {
  const PurchasesSupplierFilterChanged(this.filter);

  final SupplierFilter filter;

  @override
  List<Object?> get props => [filter];
}

class PurchaseCreated extends PurchasesEvent {
  const PurchaseCreated(this.draft);

  final PurchaseDraft draft;

  @override
  List<Object?> get props => [draft];
}

class PurchasePaymentRecorded extends PurchasesEvent {
  const PurchasePaymentRecorded({
    required this.purchaseId,
    required this.amount,
  });

  final int purchaseId;
  final double amount;

  @override
  List<Object?> get props => [purchaseId, amount];
}

class SupplierPaymentRecorded extends PurchasesEvent {
  const SupplierPaymentRecorded({
    required this.supplierId,
    required this.amount,
  });

  final int supplierId;
  final double amount;

  @override
  List<Object?> get props => [supplierId, amount];
}

class SupplierSaved extends PurchasesEvent {
  const SupplierSaved({required this.draft, this.id});

  final SupplierDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

class SupplierBalanceAdjusted extends PurchasesEvent {
  const SupplierBalanceAdjusted({
    required this.supplierId,
    required this.amountChange,
    this.note,
  });

  final int supplierId;
  final double amountChange;
  final String? note;

  @override
  List<Object?> get props => [supplierId, amountChange, note];
}

class PurchasesRefreshRequested extends PurchasesEvent {
  const PurchasesRefreshRequested();
}

class PurchasesMessageDismissed extends PurchasesEvent {
  const PurchasesMessageDismissed();
}
