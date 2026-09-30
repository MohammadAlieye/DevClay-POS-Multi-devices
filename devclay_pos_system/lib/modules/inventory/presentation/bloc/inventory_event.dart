part of 'inventory_bloc.dart';

enum InventoryTab { stock, history }

enum InventoryListFilter {
  all,
  lowStock,
  outOfStock,
  expired,
  expiringSoon,
  noExpiry,
  inactive,
}

enum InventoryListSort {
  nameAsc,
  nameDesc,
  stockLowHigh,
  stockHighLow,
  valueHighLow,
  expirySoonest,
  expiryLatest,
}

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

class InventoryStarted extends InventoryEvent {
  const InventoryStarted();
}

class InventorySearchChanged extends InventoryEvent {
  const InventorySearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class InventoryTabChanged extends InventoryEvent {
  const InventoryTabChanged(this.tab);

  final InventoryTab tab;

  @override
  List<Object?> get props => [tab];
}

class InventoryFilterChanged extends InventoryEvent {
  const InventoryFilterChanged(this.filter);

  final InventoryListFilter filter;

  @override
  List<Object?> get props => [filter];
}

class InventorySortChanged extends InventoryEvent {
  const InventorySortChanged(this.sort);

  final InventoryListSort sort;

  @override
  List<Object?> get props => [sort];
}

class InventoryAdjustRequested extends InventoryEvent {
  const InventoryAdjustRequested(this.request);

  final StockAdjustRequest request;

  @override
  List<Object?> get props => [request];
}

class InventoryRefreshRequested extends InventoryEvent {
  const InventoryRefreshRequested();
}

class InventoryMessageDismissed extends InventoryEvent {
  const InventoryMessageDismissed();
}
