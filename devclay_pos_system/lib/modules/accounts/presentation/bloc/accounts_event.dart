part of 'accounts_bloc.dart';

sealed class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class AccountsStarted extends AccountsEvent {
  const AccountsStarted();
}

class AccountsSearchChanged extends AccountsEvent {
  const AccountsSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class AccountsPeriodChanged extends AccountsEvent {
  const AccountsPeriodChanged(this.period);

  final AccountsPeriod period;

  @override
  List<Object?> get props => [period];
}

class AccountsViewTabChanged extends AccountsEvent {
  const AccountsViewTabChanged(this.viewTab);

  final AccountsViewTab viewTab;

  @override
  List<Object?> get props => [viewTab];
}

class AccountsLedgerFilterChanged extends AccountsEvent {
  const AccountsLedgerFilterChanged(this.type);

  final LedgerType? type;

  @override
  List<Object?> get props => [type];
}

class AccountSaved extends AccountsEvent {
  const AccountSaved({required this.draft, this.id});

  final AccountDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

class LedgerEntryAdded extends AccountsEvent {
  const LedgerEntryAdded(this.draft);

  final LedgerDraft draft;

  @override
  List<Object?> get props => [draft];
}

class AccountsRefreshRequested extends AccountsEvent {
  const AccountsRefreshRequested();
}

class AccountsMessageDismissed extends AccountsEvent {
  const AccountsMessageDismissed();
}
