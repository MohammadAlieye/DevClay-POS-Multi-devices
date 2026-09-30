part of 'suppliers_bloc.dart';

sealed class SuppliersEvent extends Equatable {
  const SuppliersEvent();

  @override
  List<Object?> get props => [];
}

class SuppliersStarted extends SuppliersEvent {
  const SuppliersStarted();
}

class SuppliersSearchChanged extends SuppliersEvent {
  const SuppliersSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class SuppliersTabChanged extends SuppliersEvent {
  const SuppliersTabChanged(this.tab);

  final SuppliersTab tab;

  @override
  List<Object?> get props => [tab];
}

class SuppliersSortChanged extends SuppliersEvent {
  const SuppliersSortChanged(this.sort);

  final SuppliersSort sort;

  @override
  List<Object?> get props => [sort];
}

class SupplierSaved extends SuppliersEvent {
  const SupplierSaved({required this.draft, this.id});

  final SupplierDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

class SupplierDeleted extends SuppliersEvent {
  const SupplierDeleted(this.supplierId);

  final int supplierId;

  @override
  List<Object?> get props => [supplierId];
}

class SupplierPurchasesRequested extends SuppliersEvent {
  const SupplierPurchasesRequested(this.supplierId);

  final int supplierId;

  @override
  List<Object?> get props => [supplierId];
}

class SupplierPurchasePaymentRecorded extends SuppliersEvent {
  const SupplierPurchasePaymentRecorded({
    required this.purchaseId,
    required this.amount,
  });

  final int purchaseId;
  final double amount;

  @override
  List<Object?> get props => [purchaseId, amount];
}

class SuppliersRefreshRequested extends SuppliersEvent {
  const SuppliersRefreshRequested();
}

class SuppliersMessageDismissed extends SuppliersEvent {
  const SuppliersMessageDismissed();
}

