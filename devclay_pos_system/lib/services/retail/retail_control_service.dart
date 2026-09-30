import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../core/auth/password_hasher.dart';
import '../../core/auth/retail_actor.dart';
import '../../database/collections/account.dart';
import '../../database/collections/app_setting.dart';
import '../../database/collections/cash_shift.dart';
import '../../database/collections/ledger_entry.dart';
import '../../database/collections/product.dart';
import '../../database/collections/stock_movement.dart';
import '../../database/collections/stock_write_off.dart';
import '../../database/collections/user_account.dart';
import '../../database/isar_service.dart';
import '../../database/product_batch_store.dart';

class RetailControlService {
  RetailControlService(this._isarService);

  final IsarService _isarService;

  Future<ShiftPolicy> shiftPolicy() async {
    final isar = _isarService.instance;
    final actor = await RetailActorStore.current(isar);
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    return ShiftPolicy(
      required: settings?.cashierShiftRequired ?? false,
      canConfigure: actor?.isOwnerOrManager ?? false,
    );
  }

  Future<void> setShiftRequired(bool value) async {
    final isar = _isarService.instance;
    final actor = await RetailActorStore.current(isar);
    if (actor == null || !actor.isOwnerOrManager) {
      throw StateError('Only an owner or manager can change shift policy.');
    }
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null) throw StateError('Business settings not found.');
    await isar.writeTxn(() async {
      settings.cashierShiftRequired = value;
      await isar.appSettings.put(settings);
      await RetailActorStore.audit(
        isar: isar,
        action: 'shift.policy_changed',
        entityType: 'settings',
        actor: actor,
        details: value
            ? 'Cashier shifts made required'
            : 'Cashier shifts made optional',
      );
    });
  }

  Future<RetailActor?> verifySupervisor({
    required String username,
    required String password,
  }) async {
    final isar = _isarService.instance;
    final user = await isar.userAccounts
        .filter()
        .usernameEqualTo(username.trim().toLowerCase())
        .findFirst();
    if (user == null ||
        !user.isActive ||
        user.deletedAt != null ||
        (user.role != 'owner' && user.role != 'manager')) {
      return null;
    }
    final valid = PasswordHasher.verify(
      password: password,
      salt: user.passwordSalt,
      expectedHash: user.passwordHash,
    );
    if (!valid) return null;
    return RetailActor(id: user.id, name: user.displayName, role: user.role);
  }

  Future<void> recordApproval({
    required RetailActor supervisor,
    required String action,
    required String details,
  }) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      await RetailActorStore.audit(
        isar: isar,
        action: action,
        entityType: 'manager_approval',
        actor: supervisor,
        details: details,
      );
    });
  }

  Future<CashShift?> activeShift() async {
    final isar = _isarService.instance;
    final actor = await RetailActorStore.current(isar);
    if (actor == null) return null;
    final shifts = await isar.cashShifts
        .filter()
        .userIdEqualTo(actor.id)
        .statusEqualTo('open')
        .findAll();
    shifts.sort((a, b) => b.openedAt.compareTo(a.openedAt));
    return shifts.firstOrNull;
  }

  Future<CashShift> openShift({
    required double openingCash,
    int? cashAccountId,
    String? note,
  }) async {
    if (openingCash < 0) {
      throw ArgumentError('Opening cash cannot be negative.');
    }
    final isar = _isarService.instance;
    final actor = await RetailActorStore.current(isar);
    if (actor == null) throw StateError('Sign in before opening a shift.');
    if (await activeShift() != null) {
      throw StateError('You already have an open shift.');
    }
    final account = cashAccountId == null
        ? null
        : await isar.accounts.get(cashAccountId);
    final now = DateTime.now();
    late int id;
    await isar.writeTxn(() async {
      id = await isar.cashShifts.put(
        CashShift()
          ..userId = actor.id
          ..userName = actor.name
          ..cashAccountId = account?.id
          ..cashAccountName = account?.name
          ..openingCash = openingCash
          ..expectedCash = openingCash
          ..status = 'open'
          ..note = _emptyToNull(note)
          ..openedAt = now,
      );
      await RetailActorStore.audit(
        isar: isar,
        action: 'shift.opened',
        entityType: 'cash_shift',
        entityId: id,
        actor: actor,
        details:
            'Opening cash Rs ${openingCash.toStringAsFixed(2)}'
            '${account == null ? '' : ' · ${account.name}'}',
        occurredAt: now,
      );
    });
    return (await isar.cashShifts.get(id))!;
  }

  Future<CashShift> closeShift({
    required int shiftId,
    required double closingCash,
    String? note,
  }) async {
    if (closingCash < 0) {
      throw ArgumentError('Closing cash cannot be negative.');
    }
    final isar = _isarService.instance;
    final actor = await RetailActorStore.current(isar);
    final shift = await isar.cashShifts.get(shiftId);
    if (shift == null || shift.status != 'open') {
      throw StateError('Open shift not found.');
    }
    if (actor == null || shift.userId != actor.id) {
      throw StateError('Only the cashier who opened this shift can close it.');
    }

    final entries = await isar.ledgerEntrys.where().findAll();
    final shiftEntries = entries.where(
      (entry) =>
          !entry.entryDate.isBefore(shift.openedAt) &&
          entry.userId == shift.userId &&
          (shift.cashAccountId == null ||
              entry.accountId == shift.cashAccountId),
    );
    var netCash = 0.0;
    for (final entry in shiftEntries) {
      if (entry.type == 'income') netCash += entry.amount;
      if (entry.type == 'expense') netCash -= entry.amount;
    }
    final expected = shift.openingCash + netCash;
    final variance = closingCash - expected;
    final now = DateTime.now();
    await isar.writeTxn(() async {
      shift
        ..expectedCash = expected
        ..closingCash = closingCash
        ..variance = variance
        ..status = 'closed'
        ..note = _emptyToNull(note) ?? shift.note
        ..closedAt = now;
      await isar.cashShifts.put(shift);
      await RetailActorStore.audit(
        isar: isar,
        action: 'shift.closed',
        entityType: 'cash_shift',
        entityId: shift.id,
        actor: actor,
        details:
            'Expected Rs ${expected.toStringAsFixed(2)} · Counted Rs '
            '${closingCash.toStringAsFixed(2)} · Variance Rs '
            '${variance.toStringAsFixed(2)}',
        occurredAt: now,
      );
    });
    return shift;
  }

  Future<List<Account>> cashAccounts() async {
    final accounts = await _isarService.instance.accounts
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    return accounts.where((account) => account.type == 'cash').toList();
  }

  Future<void> writeOffStock({
    required int productId,
    required int quantity,
    required String reason,
    String? note,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than zero.');
    }
    final allowedReasons = {'damaged', 'wastage', 'theft', 'expired', 'other'};
    if (!allowedReasons.contains(reason)) {
      throw ArgumentError('Invalid reason.');
    }
    final isar = _isarService.instance;
    final actor = await RetailActorStore.current(isar);
    final product = await isar.products.get(productId);
    if (product == null || product.deletedAt != null) {
      throw StateError('Product not found.');
    }
    final now = DateTime.now();
    await isar.writeTxn(() async {
      final allocations = await ProductBatchStore.deductFefo(
        isar: isar,
        product: product,
        quantity: quantity,
      );
      final refreshed = await isar.products.get(product.id);
      final writeOffId = await isar.stockWriteOffs.put(
        StockWriteOff()
          ..productId = product.id
          ..productName = product.name
          ..productSku = product.sku
          ..quantity = quantity
          ..valueAtCost = quantity * product.purchasePrice
          ..reason = reason
          ..allocationsJson = jsonEncode(
            allocations.map((item) => item.toJson()).toList(),
          )
          ..userId = actor?.id
          ..userName = actor?.name
          ..note = _emptyToNull(note)
          ..createdAt = now,
      );
      await isar.stockMovements.put(
        StockMovement()
          ..productId = product.id
          ..productName = product.name
          ..productSku = product.sku
          ..type = 'write_off_$reason'
          ..quantityChange = -quantity
          ..quantityAfter = refreshed?.stock ?? 0
          ..note = _emptyToNull(note)
          ..createdAt = now,
      );
      await RetailActorStore.audit(
        isar: isar,
        action: 'stock.written_off',
        entityType: 'stock_write_off',
        entityId: writeOffId,
        actor: actor,
        details: '${product.name} · $quantity · $reason',
        occurredAt: now,
      );
    });
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

class ShiftPolicy {
  const ShiftPolicy({required this.required, required this.canConfigure});

  final bool required;
  final bool canConfigure;
}
