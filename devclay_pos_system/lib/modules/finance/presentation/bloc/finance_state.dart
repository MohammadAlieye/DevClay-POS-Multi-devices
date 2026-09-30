part of 'finance_bloc.dart';

sealed class FinanceState extends Equatable {
  const FinanceState();

  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {
  const FinanceInitial();
}

class FinanceLoading extends FinanceState {
  const FinanceLoading();
}

class FinanceError extends FinanceState {
  const FinanceError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class FinanceLoaded extends FinanceState {
  const FinanceLoaded({
    required this.data,
    required this.period,
    required this.viewTab,
    this.message,
  });

  final FinanceData data;
  final FinancePeriod period;
  final FinanceViewTab viewTab;
  final String? message;

  List<FinanceMovement> movementsFor(FinanceMovementKind kind) {
    return data.movements.where((m) => m.kind == kind).toList();
  }

  FinanceLoaded copyWith({
    FinanceData? data,
    FinancePeriod? period,
    FinanceViewTab? viewTab,
    String? message,
    bool clearMessage = false,
  }) {
    return FinanceLoaded(
      data: data ?? this.data,
      period: period ?? this.period,
      viewTab: viewTab ?? this.viewTab,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [data, period, viewTab, message];
}
