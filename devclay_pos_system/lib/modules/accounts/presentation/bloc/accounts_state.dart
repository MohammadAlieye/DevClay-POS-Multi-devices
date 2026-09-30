part of 'accounts_bloc.dart';

sealed class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Object?> get props => [];
}

class AccountsInitial extends AccountsState {
  const AccountsInitial();
}

class AccountsLoading extends AccountsState {
  const AccountsLoading();
}

class AccountsError extends AccountsState {
  const AccountsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AccountsLoaded extends AccountsState {
  const AccountsLoaded({
    required this.overview,
    required this.accounts,
    required this.entries,
    required this.query,
    required this.period,
    required this.viewTab,
    this.ledgerFilter,
    this.message,
  });

  final AccountsOverview overview;
  final List<AccountItem> accounts;
  final List<LedgerEntryItem> entries;
  final String query;
  final AccountsPeriod period;
  final AccountsViewTab viewTab;
  final LedgerType? ledgerFilter;
  final String? message;

  List<AccountItem> get visibleAccounts {
    final q = query.trim().toLowerCase();
    if (q.isEmpty || viewTab != AccountsViewTab.accounts) return accounts;
    return accounts.where((account) {
      return account.name.toLowerCase().contains(q) ||
          account.type.contains(q);
    }).toList();
  }

  AccountsLoaded copyWith({
    AccountsOverview? overview,
    List<AccountItem>? accounts,
    List<LedgerEntryItem>? entries,
    String? query,
    AccountsPeriod? period,
    AccountsViewTab? viewTab,
    LedgerType? ledgerFilter,
    bool clearLedgerFilter = false,
    String? message,
    bool clearMessage = false,
  }) {
    return AccountsLoaded(
      overview: overview ?? this.overview,
      accounts: accounts ?? this.accounts,
      entries: entries ?? this.entries,
      query: query ?? this.query,
      period: period ?? this.period,
      viewTab: viewTab ?? this.viewTab,
      ledgerFilter:
          clearLedgerFilter ? null : ledgerFilter ?? this.ledgerFilter,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        overview,
        accounts,
        entries,
        query,
        period,
        viewTab,
        ledgerFilter,
        message,
      ];
}
