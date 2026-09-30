import '../domain/entities/account_entities.dart';
import '../domain/repositories/accounts_repository.dart';
import 'datasources/accounts_local_datasource.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  AccountsRepositoryImpl(this._local);

  final AccountsLocalDataSource _local;

  @override
  Future<AccountsOverview> getOverview({required AccountsPeriod period}) {
    return _local.getOverview(period: period);
  }

  @override
  Future<List<AccountItem>> getAccounts({String query = ''}) {
    return _local.getAccounts(query: query);
  }

  @override
  Future<List<LedgerEntryItem>> getEntries({
    String query = '',
    AccountsPeriod period = AccountsPeriod.all,
    LedgerType? type,
  }) {
    return _local.getEntries(query: query, period: period, type: type);
  }

  @override
  Future<AccountItem> saveAccount(AccountDraft draft, {int? id}) {
    return _local.saveAccount(draft, id: id);
  }

  @override
  Future<void> addLedgerEntry(LedgerDraft draft) {
    return _local.addLedgerEntry(draft);
  }
}
