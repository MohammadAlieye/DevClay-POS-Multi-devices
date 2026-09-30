import '../entities/account_entities.dart';

abstract class AccountsRepository {
  Future<AccountsOverview> getOverview({required AccountsPeriod period});

  Future<List<AccountItem>> getAccounts({String query = ''});

  Future<List<LedgerEntryItem>> getEntries({
    String query = '',
    AccountsPeriod period = AccountsPeriod.all,
    LedgerType? type,
  });

  Future<AccountItem> saveAccount(AccountDraft draft, {int? id});

  Future<void> addLedgerEntry(LedgerDraft draft);
}
