import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/account_entities.dart';
import '../../domain/repositories/accounts_repository.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(this._repository) : super(const AccountsInitial()) {
    on<AccountsStarted>(_onStarted);
    on<AccountsSearchChanged>(_onSearch);
    on<AccountsPeriodChanged>(_onPeriod);
    on<AccountsViewTabChanged>(_onViewTab);
    on<AccountsLedgerFilterChanged>(_onLedgerFilter);
    on<AccountSaved>(_onAccountSaved);
    on<LedgerEntryAdded>(_onLedgerAdded);
    on<AccountsRefreshRequested>(_onRefresh);
    on<AccountsMessageDismissed>(_onDismiss);
  }

  final AccountsRepository _repository;

  Future<void> _onStarted(
    AccountsStarted event,
    Emitter<AccountsState> emit,
  ) async {
    emit(const AccountsLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    AccountsSearchChanged event,
    Emitter<AccountsState> emit,
  ) async {
    final current = state;
    if (current is AccountsLoaded) {
      emit(current.copyWith(query: event.query));
      if (current.viewTab == AccountsViewTab.transactions) {
        await _reloadEntries(emit, current.copyWith(query: event.query));
      }
    }
  }

  Future<void> _onPeriod(
    AccountsPeriodChanged event,
    Emitter<AccountsState> emit,
  ) async {
    final current = state;
    if (current is AccountsLoaded) {
      emit(current.copyWith(period: event.period));
      await _load(emit, preserveUi: current.copyWith(period: event.period));
    }
  }

  Future<void> _onViewTab(
    AccountsViewTabChanged event,
    Emitter<AccountsState> emit,
  ) async {
    final current = state;
    if (current is AccountsLoaded) {
      emit(current.copyWith(viewTab: event.viewTab, clearLedgerFilter: true));
    }
  }

  Future<void> _onLedgerFilter(
    AccountsLedgerFilterChanged event,
    Emitter<AccountsState> emit,
  ) async {
    final current = state;
    if (current is AccountsLoaded) {
      final next = current.copyWith(
        ledgerFilter: event.type,
        clearLedgerFilter: event.type == null,
      );
      emit(next);
      await _reloadEntries(emit, next);
    }
  }

  Future<void> _onAccountSaved(
    AccountSaved event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _repository.saveAccount(event.draft, id: event.id);
      await _load(
        emit,
        message: event.id == null ? 'Account added' : 'Account updated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onLedgerAdded(
    LedgerEntryAdded event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _repository.addLedgerEntry(event.draft);
      final kind = event.draft.type == LedgerType.expense
          ? 'Expense'
          : 'Income';
      await _load(emit, message: '$kind recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onRefresh(
    AccountsRefreshRequested event,
    Emitter<AccountsState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onDismiss(
    AccountsMessageDismissed event,
    Emitter<AccountsState> emit,
  ) async {
    final current = state;
    if (current is AccountsLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _reloadEntries(
    Emitter<AccountsState> emit,
    AccountsLoaded current,
  ) async {
    try {
      final entries = await _repository.getEntries(
        query: current.query,
        period: current.period,
        type: current.ledgerFilter,
      );
      emit(current.copyWith(entries: entries));
    } catch (error) {
      emit(current.copyWith(message: userFacingError(error)));
    }
  }

  void _emitActionError(Emitter<AccountsState> emit, Object error) {
    final current = state;
    final message = userFacingError(error);
    if (current is AccountsLoaded) {
      emit(current.copyWith(message: message));
    } else {
      emit(AccountsError(message));
    }
  }

  Future<void> _load(
    Emitter<AccountsState> emit, {
    String? message,
    AccountsLoaded? preserveUi,
  }) async {
    try {
      final current = state;
      final ui = preserveUi ?? (current is AccountsLoaded ? current : null);
      final query = ui?.query ?? '';
      final period = ui?.period ?? AccountsPeriod.month;
      final viewTab = ui?.viewTab ?? AccountsViewTab.overview;
      final ledgerFilter = ui?.ledgerFilter;

      final overview = await _repository.getOverview(period: period);
      final accounts = await _repository.getAccounts();
      final entries = await _repository.getEntries(
        query: query,
        period: period,
        type: ledgerFilter,
      );

      emit(
        AccountsLoaded(
          overview: overview,
          accounts: accounts,
          entries: entries,
          query: query,
          period: period,
          viewTab: viewTab,
          ledgerFilter: ledgerFilter,
          message: message,
        ),
      );
    } catch (error) {
      final current = state;
      if (current is AccountsLoaded) {
        emit(current.copyWith(message: userFacingError(error)));
      } else {
        emit(AccountsError(userFacingError(error)));
      }
    }
  }
}
