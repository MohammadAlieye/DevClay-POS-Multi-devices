import 'package:isar_community/isar.dart';

import '../../../../database/collections/account.dart';
import '../../../../database/collections/ledger_entry.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/isar_service.dart';
import '../../domain/entities/account_entities.dart';

class AccountsLocalDataSource {
  AccountsLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<AccountsOverview> getOverview({required AccountsPeriod period}) async {
    final isar = _isarService.instance;
    final accounts = await isar.accounts.where().findAll();
    final entries = await isar.ledgerEntrys.where().findAll();
    final sales = await isar.sales.where().findAll();
    final purchases = await isar.purchases.where().findAll();

    final filteredEntries = entries.where((entry) {
      return _entryPeriod(entry.entryDate, period);
    });

    final periodIncome = filteredEntries
        .where((entry) => entry.type == 'income')
        .fold(0.0, (sum, entry) => sum + entry.amount);

    final periodExpense = filteredEntries
        .where((entry) => entry.type == 'expense')
        .fold(0.0, (sum, entry) => sum + entry.amount);

    final posSalesTotal = sales
        .where((sale) => _entryPeriod(sale.soldAt, period))
        .fold(0.0, (sum, sale) => sum + sale.total);

    final purchasePaymentsTotal = purchases
        .where((purchase) => _entryPeriod(purchase.purchaseDate, period))
        .fold(0.0, (sum, purchase) => sum + purchase.paidAmount);

    return AccountsOverview(
      totalBalance: accounts.fold(0.0, (sum, account) => sum + account.balance),
      periodIncome: periodIncome,
      periodExpense: periodExpense,
      posSalesTotal: posSalesTotal,
      purchasePaymentsTotal: purchasePaymentsTotal,
    );
  }

  Future<List<AccountItem>> getAccounts({String query = ''}) async {
    final isar = _isarService.instance;
    final accounts = await isar.accounts.where().sortByName().findAll();
    final q = query.trim().toLowerCase();
    final mapped = accounts.map(_mapAccount).toList();
    if (q.isEmpty) return mapped;
    return mapped.where((account) {
      return account.name.toLowerCase().contains(q) || account.type.contains(q);
    }).toList();
  }

  Future<List<LedgerEntryItem>> getEntries({
    String query = '',
    AccountsPeriod period = AccountsPeriod.all,
    LedgerType? type,
  }) async {
    final isar = _isarService.instance;
    final entries = await isar.ledgerEntrys
        .where()
        .sortByEntryDateDesc()
        .findAll();
    final q = query.trim().toLowerCase();

    return entries
        .where((entry) {
          if (!_entryPeriod(entry.entryDate, period)) return false;
          if (type != null && entry.type != type.name) return false;
          if (q.isEmpty) return true;
          return entry.accountName.toLowerCase().contains(q) ||
              entry.category.toLowerCase().contains(q) ||
              (entry.reference?.toLowerCase().contains(q) ?? false) ||
              (entry.note?.toLowerCase().contains(q) ?? false);
        })
        .map(_mapEntry)
        .toList();
  }

  Future<AccountItem> saveAccount(AccountDraft draft, {int? id}) async {
    final name = draft.name.trim();
    if (name.isEmpty) {
      throw ArgumentError('Account name is required.');
    }
    if (!draft.openingBalance.isFinite) {
      throw ArgumentError('Enter a valid opening balance.');
    }

    final isar = _isarService.instance;

    if (id == null) {
      late int newId;
      await isar.writeTxn(() async {
        if (draft.isDefault) {
          await _clearDefaultAccount(isar);
        }
        newId = await isar.accounts.put(
          Account()
            ..name = name
            ..type = draft.type.name
            ..balance = draft.openingBalance
            ..isDefault = draft.isDefault
            ..isActive = draft.isActive
            ..notes = _emptyToNull(draft.notes)
            ..createdAt = DateTime.now(),
        );
      });
      final saved = await isar.accounts.get(newId);
      return _mapAccount(saved!);
    }

    final existing = await isar.accounts.get(id);
    if (existing == null) {
      throw StateError('Account not found.');
    }

    await isar.writeTxn(() async {
      if (draft.isDefault && !existing.isDefault) {
        await _clearDefaultAccount(isar);
      }
      existing
        ..name = name
        ..type = draft.type.name
        ..isDefault = draft.isDefault
        ..isActive = draft.isActive
        ..notes = _emptyToNull(draft.notes);
      await isar.accounts.put(existing);
    });

    final saved = await isar.accounts.get(id);
    return _mapAccount(saved!);
  }

  Future<void> addLedgerEntry(LedgerDraft draft) async {
    if (draft.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    final isar = _isarService.instance;
    final account = await isar.accounts.get(draft.accountId);
    if (account == null) {
      throw StateError('Account not found.');
    }

    final now = DateTime.now();
    final signedAmount = draft.type == LedgerType.expense
        ? -draft.amount
        : draft.amount;
    final nextBalance = (account.balance + signedAmount).clamp(
      -999999999,
      999999999,
    );

    await isar.writeTxn(() async {
      account.balance = nextBalance.toDouble();
      await isar.accounts.put(account);
      await isar.ledgerEntrys.put(
        LedgerEntry()
          ..accountId = account.id
          ..accountName = account.name
          ..type = draft.type.name
          ..category = draft.category.trim()
          ..amount = draft.amount
          ..reference = _emptyToNull(draft.reference)
          ..note = _emptyToNull(draft.note)
          ..entryDate = now
          ..createdAt = now,
      );
    });
  }

  Future<void> _clearDefaultAccount(Isar isar) async {
    final defaults = await isar.accounts
        .filter()
        .isDefaultEqualTo(true)
        .findAll();
    for (final account in defaults) {
      account.isDefault = false;
      await isar.accounts.put(account);
    }
  }

  bool _entryPeriod(DateTime date, AccountsPeriod period) {
    final now = DateTime.now();
    return switch (period) {
      AccountsPeriod.all => true,
      AccountsPeriod.today =>
        date.year == now.year && date.month == now.month && date.day == now.day,
      AccountsPeriod.week => () {
        final start = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));
        final end = start.add(const Duration(days: 7));
        return !date.isBefore(start) && date.isBefore(end);
      }(),
      AccountsPeriod.month => date.year == now.year && date.month == now.month,
    };
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  AccountItem _mapAccount(Account account) {
    return AccountItem(
      id: account.id,
      name: account.name,
      type: account.type,
      balance: account.balance,
      isDefault: account.isDefault,
      isActive: account.isActive,
      notes: account.notes,
    );
  }

  LedgerEntryItem _mapEntry(LedgerEntry entry) {
    return LedgerEntryItem(
      id: entry.id,
      accountId: entry.accountId,
      accountName: entry.accountName,
      type: entry.type,
      category: entry.category,
      amount: entry.amount,
      entryDate: entry.entryDate,
      createdAt: entry.createdAt,
      reference: entry.reference,
      note: entry.note,
    );
  }
}
