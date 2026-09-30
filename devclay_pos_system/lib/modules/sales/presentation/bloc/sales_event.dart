part of 'sales_bloc.dart';

sealed class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

class SalesStarted extends SalesEvent {
  const SalesStarted();
}

class SalesSearchChanged extends SalesEvent {
  const SalesSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class SalesPeriodChanged extends SalesEvent {
  const SalesPeriodChanged(this.period);

  final SalesPeriod period;

  @override
  List<Object?> get props => [period];
}

class SalesViewTabChanged extends SalesEvent {
  const SalesViewTabChanged(this.viewTab);

  final SalesViewTab viewTab;

  @override
  List<Object?> get props => [viewTab];
}

class SalesRefreshRequested extends SalesEvent {
  const SalesRefreshRequested();
}
