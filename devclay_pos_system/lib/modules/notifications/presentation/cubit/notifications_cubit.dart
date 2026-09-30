import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar_community/isar.dart';

import '../../../../database/collections/app_notification.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/held_sale.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/isar_service.dart';
import '../../../../modules/license/data/datasources/license_local_datasource.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';

class AppNotificationItem extends Equatable {
  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.actionType,
    this.actionPayload,
  });

  final int id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final String? actionType;
  final String? actionPayload;

  bool get isOutOfStock => type == NotificationTypes.outOfStock;
  bool get isLowStock => type == NotificationTypes.lowStock;
  bool get canClear => NotificationTypes.isDismissible(type);
  bool get canUndo =>
      actionType != null &&
      actionType!.isNotEmpty &&
      actionPayload != null &&
      actionPayload!.isNotEmpty;

  /// Body without the internal sync key line (last line after `\n`).
  String get displayBody {
    final idx = body.lastIndexOf('\n');
    if (idx <= 0) return body;
    final maybeKey = body.substring(idx + 1);
    if (maybeKey.contains('|')) return body.substring(0, idx);
    return body;
  }

  @override
  List<Object?> get props =>
      [id, title, body, type, createdAt, isRead, actionType, actionPayload];
}

abstract final class NotificationTypes {
  static const outOfStock = 'out_of_stock';
  static const lowStock = 'low_stock';
  static const stockDismissed = 'stock_dismissed';
  static const backup = 'backup';
  static const backupDismissed = 'backup_dismissed';
  static const license = 'license';
  static const licenseDismissed = 'license_dismissed';
  static const heldSale = 'held_sale';
  static const warning = 'warning';
  static const info = 'info';
  static const success = 'success';
  static const recycle = 'recycle';

  static const restoreProduct = 'restore_product';
  static const restoreHeldSale = 'restore_held_sale';

  static bool isHiddenMarker(String type) =>
      type == stockDismissed ||
      type == backupDismissed ||
      type == licenseDismissed;

  static bool isDismissible(String type) => !isHiddenMarker(type);
}

class NotificationsState extends Equatable {
  const NotificationsState({
    this.items = const [],
    this.flashAlerts = const [],
    this.undoRevision = 0,
    this.lastUndoActionType,
  });

  final List<AppNotificationItem> items;
  final List<AppNotificationItem> flashAlerts;

  /// Bumped after a successful notification Undo so open pages can refresh.
  final int undoRevision;
  final String? lastUndoActionType;

  int get unreadCount => items.where((i) => !i.isRead).length;

  NotificationsState copyWith({
    List<AppNotificationItem>? items,
    List<AppNotificationItem>? flashAlerts,
    bool clearFlash = false,
    int? undoRevision,
    String? lastUndoActionType,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      flashAlerts: clearFlash ? const [] : (flashAlerts ?? this.flashAlerts),
      undoRevision: undoRevision ?? this.undoRevision,
      lastUndoActionType: lastUndoActionType ?? this.lastUndoActionType,
    );
  }

  @override
  List<Object?> get props =>
      [items, flashAlerts, undoRevision, lastUndoActionType];
}

/// Surfaces stock, backup, license, and held-sale alerts in the shell.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(
    this._isarService, {
    LicenseLocalDataSource? licenseLocal,
  })  : _licenseLocal = licenseLocal ?? LicenseLocalDataSource(),
        super(const NotificationsState());

  final IsarService _isarService;
  final LicenseLocalDataSource _licenseLocal;

  static const _backupReminderDays = 7;
  static const _licenseWarnDays = 7;

  Future<void> refresh({bool flashNewOutOfStock = false}) async {
    final created = await _syncAll(flashNewOutOfStock: flashNewOutOfStock);
    final items = await _loadItems();
    emit(
      state.copyWith(
        items: items,
        flashAlerts: flashNewOutOfStock ? created : const [],
        clearFlash: !flashNewOutOfStock,
      ),
    );
  }

  Future<void> clearFlash() async {
    if (state.flashAlerts.isEmpty) return;
    emit(state.copyWith(clearFlash: true));
  }

  /// Marks everything read and reloads — does not recreate stock alerts.
  Future<void> markAllRead() async {
    final isar = _isarService.instance;
    final unread =
        await isar.appNotifications.filter().isReadEqualTo(false).findAll();
    if (unread.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final n in unread) {
          n.isRead = true;
          await isar.appNotifications.put(n);
        }
      });
    }
    final items = await _loadItems();
    emit(state.copyWith(items: items, clearFlash: true));
  }

  Future<void> dismissOne(int id) async {
    final isar = _isarService.instance;
    final n = await isar.appNotifications.get(id);
    if (n == null || NotificationTypes.isHiddenMarker(n.type)) return;

    if (n.type == NotificationTypes.license) {
      final dismissKey = await _licenseDismissKey();
      await isar.writeTxn(() async {
        n
          ..type = NotificationTypes.licenseDismissed
          ..isRead = true
          ..body = '${_displayBody(n.body)}\n$dismissKey';
        await isar.appNotifications.put(n);
      });
    } else if (n.type == NotificationTypes.backup) {
      final dismissKey = await _backupDismissKey(isar);
      await isar.writeTxn(() async {
        n
          ..type = NotificationTypes.backupDismissed
          ..isRead = true
          ..body = '${_displayBody(n.body)}\n$dismissKey';
        await isar.appNotifications.put(n);
      });
    } else {
      await isar.writeTxn(() async {
        if (n.type == NotificationTypes.outOfStock ||
            n.type == NotificationTypes.lowStock) {
          final sku = _skuFromStockBody(n.body) ?? 'unknown';
          final dismissedKey = 'stock_dismissed|$sku';
          n
            ..type = NotificationTypes.stockDismissed
            ..isRead = true
            ..body = '${_displayBody(n.body)}\n$dismissedKey';
          await isar.appNotifications.put(n);
        } else {
          await isar.appNotifications.delete(id);
        }
      });
    }
    final items = await _loadItems();
    emit(state.copyWith(items: items));
  }

  Future<void> clearDismissible() async {
    final isar = _isarService.instance;
    final rows = await isar.appNotifications.where().findAll();
    final licenseKey = await _licenseDismissKey();
    final backupKey = await _backupDismissKey(isar);

    await isar.writeTxn(() async {
      for (final n in rows) {
        if (NotificationTypes.isHiddenMarker(n.type)) continue;
        if (n.type == NotificationTypes.outOfStock ||
            n.type == NotificationTypes.lowStock) {
          final sku = _skuFromStockBody(n.body) ?? 'unknown';
          final dismissedKey = 'stock_dismissed|$sku';
          n
            ..type = NotificationTypes.stockDismissed
            ..isRead = true
            ..body = '${_displayBody(n.body)}\n$dismissedKey';
          await isar.appNotifications.put(n);
        } else if (n.type == NotificationTypes.license) {
          n
            ..type = NotificationTypes.licenseDismissed
            ..isRead = true
            ..body = '${_displayBody(n.body)}\n$licenseKey';
          await isar.appNotifications.put(n);
        } else if (n.type == NotificationTypes.backup) {
          n
            ..type = NotificationTypes.backupDismissed
            ..isRead = true
            ..body = '${_displayBody(n.body)}\n$backupKey';
          await isar.appNotifications.put(n);
        } else {
          await isar.appNotifications.delete(n.id);
        }
      }
    });
    final items = await _loadItems();
    emit(state.copyWith(items: items, clearFlash: true));
  }

  Future<String> _licenseDismissKey() async {
    final payload = await _licenseLocal.readEncryptedLicense();
    final expiry = payload?.expiryDate?.toUtc();
    if (expiry == null) return 'license_dismissed|unknown';
    final stamp =
        '${expiry.year.toString().padLeft(4, '0')}-'
        '${expiry.month.toString().padLeft(2, '0')}-'
        '${expiry.day.toString().padLeft(2, '0')}';
    return 'license_dismissed|$stamp';
  }

  Future<String> _backupDismissKey(Isar isar) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    final stamp =
        settings?.lastBackupAt?.millisecondsSinceEpoch.toString() ?? 'none';
    return 'backup_dismissed|$stamp';
  }

  /// Records a recycle-bin move with an Undo action in the notification panel.
  Future<void> notifyRecycle({
    required String title,
    required String body,
    required String actionType,
    required int entityId,
  }) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      await isar.appNotifications.put(
        AppNotification()
          ..title = title
          ..body = body
          ..type = NotificationTypes.recycle
          ..createdAt = DateTime.now()
          ..isRead = false
          ..actionType = actionType
          ..actionPayload = '$entityId',
      );
    });
    final items = await _loadItems();
    emit(state.copyWith(items: items));
  }

  /// Runs the undo action on a recycle notification, then removes it.
  Future<bool> undoNotification(int id) async {
    final isar = _isarService.instance;
    final n = await isar.appNotifications.get(id);
    if (n == null || n.actionType == null || n.actionPayload == null) {
      return false;
    }
    final actionType = n.actionType!;
    final entityId = int.tryParse(n.actionPayload!);
    if (entityId == null) return false;

    final ok = await _restoreByAction(actionType, entityId);
    if (!ok) return false;

    await isar.writeTxn(() async {
      await isar.appNotifications.delete(id);
    });
    final items = await _loadItems();
    emit(
      state.copyWith(
        items: items,
        undoRevision: state.undoRevision + 1,
        lastUndoActionType: actionType,
      ),
    );
    return true;
  }

  /// Call after restoring outside the notification panel (e.g. toast Undo)
  /// so open lists stay in sync.
  void announceRestore(String actionType) {
    emit(
      state.copyWith(
        undoRevision: state.undoRevision + 1,
        lastUndoActionType: actionType,
      ),
    );
  }

  Future<bool> _restoreByAction(String actionType, int entityId) async {
    final isar = _isarService.instance;
    return isar.writeTxn(() async {
      switch (actionType) {
        case NotificationTypes.restoreProduct:
          final product = await isar.products.get(entityId);
          if (product == null || product.deletedAt == null) return false;
          product.deletedAt = null;
          await isar.products.put(product);
          return true;
        case NotificationTypes.restoreHeldSale:
          final held = await isar.heldSales.get(entityId);
          if (held == null || held.deletedAt == null) return false;
          held.deletedAt = null;
          await isar.heldSales.put(held);
          return true;
        default:
          return false;
      }
    });
  }

  String _displayBody(String body) {
    final lines = body.split('\n');
    if (lines.length > 1 && lines.last.contains('|')) {
      return lines.sublist(0, lines.length - 1).join('\n');
    }
    return body;
  }

  String? _skuFromStockBody(String body) {
    final lines = body.split('\n');
    final key = lines.lastWhere((l) => l.contains('|'), orElse: () => '');
    if (key.isEmpty) return null;
    final parts = key.split('|');
    return parts.length >= 2 ? parts.last : null;
  }

  Future<List<AppNotificationItem>> _syncAll({
    required bool flashNewOutOfStock,
  }) async {
    final flashed = <AppNotificationItem>[];
    flashed.addAll(
      await _syncStockNotifications(flashNewOutOfStock: flashNewOutOfStock),
    );
    await _syncBackupReminder();
    await _syncLicenseReminder();
    await _syncHeldSalesReminder();
    return flashed;
  }

  String _stockKey(String type, String sku) => '$type|$sku';

  Future<List<AppNotificationItem>> _syncStockNotifications({
    required bool flashNewOutOfStock,
  }) async {
    final isar = _isarService.instance;
    final products = await isar.products
        .filter()
        .isActiveEqualTo(true)
        .deletedAtIsNull()
        .findAll();
    final now = DateTime.now();
    final flashed = <AppNotificationItem>[];

    await isar.writeTxn(() async {
      for (final product in products) {
        final outType = NotificationTypes.outOfStock;
        final lowType = NotificationTypes.lowStock;
        final outKey = _stockKey(outType, product.sku);
        final lowKey = _stockKey(lowType, product.sku);

        if (!isStockAtOrBelowLowThreshold(
          product.stock,
          product.lowStockThreshold,
        )) {
          // Stock recovered — remove active + dismissed markers.
          await _deleteByKey(isar, outKey);
          await _deleteByKey(isar, lowKey);
          await _deleteByKey(isar, 'stock_dismissed|${product.sku}');
          continue;
        }

        final isOut = product.stock <= 0;
        final type = isOut ? outType : lowType;
        final key = isOut ? outKey : lowKey;
        final title = isOut ? 'Out of stock' : 'Low stock';
        final body = isOut
            ? '${product.name} has run out of stock. Please refill.'
            : '${product.name} is low (${product.stock} left). Please refill.';

        if (isOut) {
          await _deleteByKey(isar, lowKey);
        }

        // User cleared this alert — wait until stock is refilled.
        final dismissed =
            await _findByKey(isar, 'stock_dismissed|${product.sku}');
        if (dismissed != null) continue;

        final existing = await _findByKey(isar, key);
        final fullBody = '$body\n$key';
        if (existing != null) {
          // Keep read state; only refresh text if stock count changed.
          if (existing.body != fullBody || existing.title != title) {
            existing
              ..body = fullBody
              ..title = title;
            await isar.appNotifications.put(existing);
          }
          continue;
        }

        final notification = AppNotification()
          ..title = title
          ..body = fullBody
          ..type = type
          ..createdAt = now
          ..isRead = false;
        final id = await isar.appNotifications.put(notification);
        if (flashNewOutOfStock && isOut) {
          flashed.add(
            AppNotificationItem(
              id: id,
              title: title,
              body: body,
              type: type,
              createdAt: now,
              isRead: false,
            ),
          );
        }
      }
    });

    return flashed;
  }

  Future<void> _syncBackupReminder() async {
    final isar = _isarService.instance;
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    final lastBackup = settings?.lastBackupAt;
    final now = DateTime.now();
    final needsBackup = lastBackup == null ||
        now.difference(lastBackup).inDays >= _backupReminderDays;

    const key = 'backup|reminder';
    final dismissKey =
        'backup_dismissed|${lastBackup?.millisecondsSinceEpoch ?? 'none'}';

    if (!needsBackup) {
      await isar.writeTxn(() async {
        await _deleteByKey(isar, key);
        await _deleteByKey(isar, 'backup_dismissed|');
      });
      return;
    }

    final existing = await _findByKey(isar, key);
    if (existing != null) return;

    final dismissed = await _findByKey(isar, dismissKey);
    if (dismissed != null) return;

    final body = lastBackup == null
        ? 'No backup found yet. Create one from Settings → Backup.'
        : 'Last backup was ${now.difference(lastBackup).inDays} days ago. '
            'Please back up your data.';

    await isar.writeTxn(() async {
      await isar.appNotifications.put(
        AppNotification()
          ..title = 'Backup reminder'
          ..body = '$body\n$key'
          ..type = NotificationTypes.backup
          ..createdAt = now
          ..isRead = false,
      );
    });
  }

  Future<void> _syncLicenseReminder() async {
    final payload = await _licenseLocal.readEncryptedLicense();
    if (payload == null) return;

    final expiry = payload.expiryDate;
    if (expiry == null) return;

    final now = DateTime.now().toUtc();
    final expiryUtc = expiry.toUtc();
    final daysLeft = expiryUtc.difference(now).inDays;
    const key = 'license|reminder';
    final stamp =
        '${expiryUtc.year.toString().padLeft(4, '0')}-'
        '${expiryUtc.month.toString().padLeft(2, '0')}-'
        '${expiryUtc.day.toString().padLeft(2, '0')}';
    final dismissKey = 'license_dismissed|$stamp';

    final isar = _isarService.instance;
    if (daysLeft > _licenseWarnDays) {
      await isar.writeTxn(() async {
        await _deleteByKey(isar, key);
        await _deleteByKey(isar, 'license_dismissed|');
      });
      return;
    }

    final existing = await _findByKey(isar, key);
    if (existing != null) {
      // Refresh text if needed but keep read state.
      return;
    }

    final dismissed = await _findByKey(isar, dismissKey);
    if (dismissed != null) return;

    final title = daysLeft < 0 ? 'License expired' : 'License expiring soon';
    final body = daysLeft < 0
        ? 'Your license has expired. Renew to keep selling without interruption.'
        : daysLeft == 0
            ? 'Your license expires today. Please renew soon.'
            : 'Your license expires in $daysLeft days. Please renew soon.';

    await isar.writeTxn(() async {
      await isar.appNotifications.put(
        AppNotification()
          ..title = title
          ..body = '$body\n$key'
          ..type = NotificationTypes.license
          ..createdAt = DateTime.now()
          ..isRead = false,
      );
    });
  }

  Future<void> _syncHeldSalesReminder() async {
    final isar = _isarService.instance;
    final heldCount = await isar.heldSales.count();
    const key = 'held_sale|reminder';

    if (heldCount <= 0) {
      await isar.writeTxn(() async => _deleteByKey(isar, key));
      return;
    }

    final existing = await _findByKey(isar, key);
    final body =
        'You have $heldCount held bill${heldCount == 1 ? '' : 's'} waiting. '
        'Resume them from POS when ready.\n$key';

    if (existing != null) {
      if (!existing.body.startsWith('You have $heldCount held')) {
        await isar.writeTxn(() async {
          existing.body = body;
          await isar.appNotifications.put(existing);
        });
      }
      return;
    }

    await isar.writeTxn(() async {
      await isar.appNotifications.put(
        AppNotification()
          ..title = 'Held sales'
          ..body = body
          ..type = NotificationTypes.heldSale
          ..createdAt = DateTime.now()
          ..isRead = false,
      );
    });
  }

  Future<AppNotification?> _findByKey(Isar isar, String key) async {
    final rows = await isar.appNotifications
        .filter()
        .bodyContains(key, caseSensitive: true)
        .findAll();
    if (rows.isEmpty) return null;
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows.first;
  }

  Future<void> _deleteByKey(Isar isar, String key) async {
    final rows = await isar.appNotifications
        .filter()
        .bodyContains(key, caseSensitive: true)
        .findAll();
    for (final row in rows) {
      await isar.appNotifications.delete(row.id);
    }
  }

  Future<List<AppNotificationItem>> _loadItems() async {
    final rows = await _isarService.instance.appNotifications
        .where()
        .sortByCreatedAtDesc()
        .findAll();
    return rows
        .where((n) => !NotificationTypes.isHiddenMarker(n.type))
        .take(40)
        .map((n) {
      return AppNotificationItem(
        id: n.id,
        title: n.title,
        body: _displayBody(n.body),
        type: n.type,
        createdAt: n.createdAt,
        isRead: n.isRead,
        actionType: n.actionType,
        actionPayload: n.actionPayload,
      );
    }).toList();
  }
}
