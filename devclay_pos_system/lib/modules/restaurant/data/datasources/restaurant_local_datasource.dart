import 'dart:convert';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/lan_api/client/lan_api_client.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/dining_floor.dart';
import '../../../../database/collections/dining_table.dart';
import '../../../../database/collections/kitchen_ticket.dart';
import '../../../../database/collections/restaurant_check.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/restaurant_floor_seed.dart';

/// Local restaurant floor / check / kitchen operations.
/// On Counter (client) devices, ops go through [LanApiClient] to the shop host.
class RestaurantLocalDataSource {
  RestaurantLocalDataSource(this._isarService, {this.forceLocal = false});

  final IsarService _isarService;
  final bool forceLocal;
  final _rng = Random.secure();

  Isar get _isar => _isarService.instance;

  bool get _isClient {
    if (forceLocal) return false;
    final getIt = GetIt.instance;
    return getIt.isRegistered<LanModeService>() &&
        getIt<LanModeService>().isClient;
  }

  LanApiClient get _api => GetIt.instance<LanApiClient>();

  Future<AppSetting?> _settings() =>
      _isar.appSettings.filter().keyEqualTo('default').findFirst();

  Future<bool> isRestaurantEnabled() async {
    final s = await _settings();
    if (s == null) return false;
    return s.enableRestaurantFloor ||
        s.storeProfile.toLowerCase() == 'restaurant';
  }

  Future<List<DiningFloor>> listFloors() async {
    if (_isClient) {
      final items = await _api.fetchRestaurantFloors();
      return [for (final raw in items) _hydrateFloor(raw)];
    }
    final floors = await _isar.diningFloors
        .filter()
        .deletedAtIsNull()
        .findAll();
    floors.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return floors;
  }

  Future<DiningFloor> createFloor(String name) async {
    if (_isClient) {
      return _hydrateFloor(await _api.createRestaurantFloor(name));
    }
    final floors = await listFloors();
    final floor = DiningFloor()
      ..name = name.trim().isEmpty ? 'Floor' : name.trim()
      ..sortOrder = floors.length
      ..isActive = true
      ..createdAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.diningFloors.put(floor);
    });
    return floor;
  }

  Future<void> renameFloor(int id, String name) async {
    if (_isClient) {
      throw StateError('Rename floors on the shop host PC.');
    }
    final floor = await _isar.diningFloors.get(id);
    if (floor == null) return;
    floor.name = name.trim();
    await _isar.writeTxn(() async {
      await _isar.diningFloors.put(floor);
    });
  }

  Future<void> archiveFloor(int id) async {
    if (_isClient) {
      throw StateError('Archive floors on the shop host PC.');
    }
    final floor = await _isar.diningFloors.get(id);
    if (floor == null) return;
    floor
      ..isActive = false
      ..deletedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.diningFloors.put(floor);
    });
  }

  Future<void> reorderFloors(List<int> orderedIds) async {
    if (_isClient) {
      throw StateError('Reorder floors on the shop host PC.');
    }
    await _isar.writeTxn(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        final floor = await _isar.diningFloors.get(orderedIds[i]);
        if (floor == null) continue;
        floor.sortOrder = i;
        await _isar.diningFloors.put(floor);
      }
    });
  }

  Future<List<DiningTable>> listTables({int? floorId}) async {
    if (_isClient) {
      final items = await _api.fetchRestaurantTables(floorId: floorId);
      return [for (final raw in items) _hydrateTable(raw)];
    }
    final all = await _isar.diningTables.filter().deletedAtIsNull().findAll();
    final filtered = floorId == null
        ? all.where((t) => t.isActive).toList()
        : all.where((t) => t.isActive && t.floorId == floorId).toList();
    filtered.sort((a, b) => a.code.compareTo(b.code));
    return filtered;
  }

  Future<DiningTable?> getTable(int id) async {
    if (_isClient) {
      final tables = await listTables();
      return tables.where((t) => t.id == id).firstOrNull;
    }
    return _isar.diningTables.get(id);
  }

  Future<DiningTable?> getTableByToken(String token) async {
    // Guest token resolve is host-only (/guest/api).
    final tables = await _isar.diningTables
        .filter()
        .guestTokenEqualTo(token)
        .findAll();
    return tables.where((t) => t.deletedAt == null && t.isActive).firstOrNull;
  }

  Future<DiningTable> upsertTable({
    int? id,
    required int floorId,
    required String code,
    required String name,
    required int capacity,
    double posX = 10,
    double posY = 10,
    String shape = 'square',
  }) async {
    if (_isClient) {
      return _hydrateTable(
        await _api.upsertRestaurantTable({
          if (id != null) 'id': id,
          'floorId': floorId,
          'code': code,
          'name': name,
          'capacity': capacity,
          'posX': posX,
          'posY': posY,
          'shape': shape,
        }),
      );
    }
    final settings = await _settings();
    var secret = settings?.webToTableTokenSecret ?? '';
    if (secret.isEmpty) {
      secret = List.generate(24, (_) => _chars[_rng.nextInt(_chars.length)])
          .join();
      if (settings != null) {
        settings.webToTableTokenSecret = secret;
        await _isar.writeTxn(() async {
          await _isar.appSettings.put(settings);
        });
      }
    }

    final existing = id == null ? null : await _isar.diningTables.get(id);
    final table = existing ??
        (DiningTable()
          ..createdAt = DateTime.now()
          ..guestToken = _newToken(code, secret)
          ..status = 'free');
    table
      ..floorId = floorId
      ..code = code.trim().toUpperCase()
      ..name = name.trim().isEmpty ? code.trim().toUpperCase() : name.trim()
      ..capacity = capacity.clamp(1, 99)
      ..posX = posX.clamp(0, 100)
      ..posY = posY.clamp(0, 100)
      ..shape = shape
      ..isActive = true
      ..updatedAt = DateTime.now();
    if (table.guestToken.isEmpty) {
      table.guestToken = _newToken(table.code, secret);
    }
    await _isar.writeTxn(() async {
      await _isar.diningTables.put(table);
    });
    return table;
  }

  Future<void> regenerateTableToken(int tableId) async {
    if (_isClient) {
      await _api.regenerateRestaurantTableToken(tableId);
      return;
    }
    final table = await _isar.diningTables.get(tableId);
    if (table == null) return;
    final settings = await _settings();
    final secret = settings?.webToTableTokenSecret ?? 'devclay';
    table
      ..guestToken = _newToken(table.code, secret)
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.diningTables.put(table);
    });
  }

  Future<void> clearTable(int tableId) async {
    if (_isClient) {
      await _api.clearRestaurantTable(tableId);
      return;
    }
    final table = await _isar.diningTables.get(tableId);
    if (table == null) return;
    table
      ..status = 'free'
      ..guests = 0
      ..openCheckId = null
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.diningTables.put(table);
    });
  }

  Future<void> markDirty(int tableId) async {
    if (_isClient) {
      throw StateError('Mark dirty on the shop host PC.');
    }
    final table = await _isar.diningTables.get(tableId);
    if (table == null) return;
    table
      ..status = 'dirty'
      ..openCheckId = null
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.diningTables.put(table);
    });
  }

  Future<RestaurantCheck> openOrGetCheck({
    required int tableId,
    int guests = 2,
    String source = 'pos',
  }) async {
    if (_isClient) {
      return _hydrateCheck(
        await _api.openRestaurantCheck(
          tableId: tableId,
          guests: guests,
          source: source,
        ),
      );
    }
    final table = await _isar.diningTables.get(tableId);
    if (table == null) throw StateError('Table not found');

    if (table.openCheckId != null) {
      final existing = await _isar.restaurantChecks.get(table.openCheckId!);
      if (existing != null && existing.status != 'closed') {
        return existing;
      }
    }

    final settings = await _settings();
    final now = DateTime.now();
    final check = RestaurantCheck()
      ..tableId = tableId
      ..tableCode = table.code
      ..guests = guests.clamp(1, table.capacity)
      ..status = 'open'
      ..linesJson = '[]'
      ..serviceCharge = 0
      ..discount = 0
      ..subtotal = 0
      ..total = 0
      ..source = source
      ..webAcceptStatus = source == 'web' &&
              (settings?.webToTablePin.trim().isNotEmpty ?? false)
          ? 'pending'
          : (source == 'web' ? 'accepted' : '')
      ..createdAt = now
      ..updatedAt = now;

    await _isar.writeTxn(() async {
      final id = await _isar.restaurantChecks.put(check);
      check.id = id;
      table
        ..status = 'seated'
        ..guests = check.guests
        ..openCheckId = id
        ..updatedAt = now;
      await _isar.diningTables.put(table);
    });
    return check;
  }

  Future<RestaurantCheck?> getCheck(int id) async {
    if (_isClient) {
      try {
        return _hydrateCheck(await _api.fetchRestaurantCheck(id));
      } catch (_) {
        return null;
      }
    }
    return _isar.restaurantChecks.get(id);
  }

  Future<List<RestaurantCheck>> listOpenChecks() async {
    if (_isClient) {
      final items = await _api.fetchOpenRestaurantChecks();
      return [for (final raw in items) _hydrateCheck(raw)];
    }
    final all = await _isar.restaurantChecks.where().findAll();
    return all
        .where((c) => c.status != 'closed' && c.status != 'cancelled')
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<RestaurantCheck> setCheckLines({
    required int checkId,
    required List<Map<String, dynamic>> lines,
    double discount = 0,
    double? serviceChargePct,
  }) async {
    if (_isClient) {
      throw StateError('Edit check lines on the shop host PC.');
    }
    final check = await _isar.restaurantChecks.get(checkId);
    if (check == null) throw StateError('Check not found');
    final settings = await _settings();
    final pct = serviceChargePct ?? settings?.defaultServiceChargePct ?? 0;
    final subtotal = lines.fold<double>(
      0,
      (sum, line) => sum + ((line['lineTotal'] as num?)?.toDouble() ?? 0),
    );
    final service = subtotal * (pct / 100);
    final total = (subtotal + service - discount).clamp(0, double.infinity);

    check
      ..linesJson = jsonEncode(lines)
      ..subtotal = subtotal
      ..serviceCharge = service
      ..discount = discount
      ..total = total.toDouble()
      ..status = lines.isEmpty ? 'open' : 'ordered'
      ..updatedAt = DateTime.now();

    final table = await _isar.diningTables.get(check.tableId);
    await _isar.writeTxn(() async {
      await _isar.restaurantChecks.put(check);
      if (table != null) {
        table
          ..status = lines.isEmpty ? 'seated' : 'ordered'
          ..updatedAt = DateTime.now();
        await _isar.diningTables.put(table);
      }
    });
    return check;
  }

  Future<RestaurantCheck> appendWebLines({
    required int checkId,
    required List<Map<String, dynamic>> newLines,
  }) async {
    final check = await _isar.restaurantChecks.get(checkId);
    if (check == null) throw StateError('Check not found');
    final existing = _decodeLines(check.linesJson);
    existing.addAll(newLines);
    return setCheckLines(checkId: checkId, lines: existing);
  }

  Future<RestaurantCheck> acceptWebOrder(int checkId) async {
    if (_isClient) {
      return _hydrateCheck(await _api.acceptRestaurantWebOrder(checkId));
    }
    final check = await _isar.restaurantChecks.get(checkId);
    if (check == null) throw StateError('Check not found');
    check
      ..webAcceptStatus = 'accepted'
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.restaurantChecks.put(check);
    });
    return check;
  }

  Future<KitchenTicket> fireKitchenTicket({
    required int checkId,
    String course = 'main',
  }) async {
    if (_isClient) {
      return _hydrateTicket(
        await _api.fireRestaurantKitchen(checkId: checkId, course: course),
      );
    }
    final check = await _isar.restaurantChecks.get(checkId);
    if (check == null) throw StateError('Check not found');
    final ticket = KitchenTicket()
      ..checkId = checkId
      ..tableId = check.tableId
      ..tableCode = check.tableCode
      ..course = course
      ..station = 'kitchen'
      ..linesJson = check.linesJson
      ..status = 'queued'
      ..firedAt = DateTime.now();
    check
      ..status = 'sent'
      ..sentAt = DateTime.now()
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.kitchenTickets.put(ticket);
      await _isar.restaurantChecks.put(check);
    });
    return ticket;
  }

  Future<List<KitchenTicket>> listKitchenTickets({bool openOnly = true}) async {
    if (_isClient) {
      final items = await _api.fetchKitchenTickets(openOnly: openOnly);
      return [for (final raw in items) _hydrateTicket(raw)];
    }
    final all = await _isar.kitchenTickets.where().findAll();
    final filtered = openOnly
        ? all.where((t) => t.status != 'bumped').toList()
        : all;
    filtered.sort((a, b) => a.firedAt.compareTo(b.firedAt));
    return filtered;
  }

  Future<void> bumpKitchenTicket(int ticketId, {String to = 'ready'}) async {
    if (_isClient) {
      await _api.bumpKitchenTicket(ticketId, to: to);
      return;
    }
    final ticket = await _isar.kitchenTickets.get(ticketId);
    if (ticket == null) return;
    final now = DateTime.now();
    if (to == 'preparing') {
      ticket.status = 'preparing';
    } else if (to == 'ready') {
      ticket
        ..status = 'ready'
        ..readyAt = now;
    } else if (to == 'bumped') {
      ticket
        ..status = 'bumped'
        ..bumpedAt = now;
    }
    await _isar.writeTxn(() async {
      await _isar.kitchenTickets.put(ticket);
      if (to == 'ready') {
        final check = await _isar.restaurantChecks.get(ticket.checkId);
        if (check != null) {
          check
            ..status = 'ready'
            ..updatedAt = now;
          await _isar.restaurantChecks.put(check);
        }
      }
    });
  }

  Future<RestaurantCheck> closeCheck({
    required int checkId,
    required int saleId,
    required String invoiceNo,
  }) async {
    if (_isClient) {
      return _hydrateCheck(
        await _api.closeRestaurantCheck(
          checkId: checkId,
          saleId: saleId,
          invoiceNo: invoiceNo,
        ),
      );
    }
    final check = await _isar.restaurantChecks.get(checkId);
    if (check == null) throw StateError('Check not found');
    final now = DateTime.now();
    check
      ..status = 'closed'
      ..closedSaleId = saleId
      ..closedInvoiceNo = invoiceNo
      ..closedAt = now
      ..updatedAt = now;
    final table = await _isar.diningTables.get(check.tableId);
    await _isar.writeTxn(() async {
      await _isar.restaurantChecks.put(check);
      if (table != null) {
        table
          ..status = 'dirty'
          ..openCheckId = null
          ..guests = 0
          ..updatedAt = now;
        await _isar.diningTables.put(table);
      }
    });
    return check;
  }

  Future<Map<String, dynamic>> dashboardRestaurantMetrics() async {
    final tables = await listTables();
    final openTables =
        tables.where((t) => t.status != 'free' && t.status != 'dirty').length;
    final seatedGuests = tables.fold<int>(0, (sum, t) => sum + t.guests);
    final pendingWeb = (await listOpenChecks())
        .where((c) => c.source == 'web' && c.webAcceptStatus == 'pending')
        .length;
    final kitchen = await listKitchenTickets(openOnly: true);
    if (_isClient) {
      return {
        'openTables': openTables,
        'seatedGuests': seatedGuests,
        'avgTableTurnMinutes': 0.0,
        'webOrdersPending': pendingWeb,
        'kitchenOpenTickets': kitchen.length,
      };
    }
    final closed =
        await _isar.restaurantChecks.filter().statusEqualTo('closed').findAll();
    var turnSum = 0.0;
    var turnN = 0;
    for (final c in closed.take(50)) {
      final closedAt = c.closedAt;
      if (closedAt == null) continue;
      turnSum += closedAt.difference(c.createdAt).inMinutes.toDouble();
      turnN++;
    }
    return {
      'openTables': openTables,
      'seatedGuests': seatedGuests,
      'avgTableTurnMinutes': turnN == 0 ? 0.0 : turnSum / turnN,
      'webOrdersPending': pendingWeb,
      'kitchenOpenTickets': kitchen.length,
    };
  }

  Future<void> ensureSeededIfNeeded() async {
    if (_isClient) {
      await _api.fetchRestaurantFloors();
      return;
    }
    if (await isRestaurantEnabled()) {
      await RestaurantFloorSeed.ensureSampleFloor(_isar);
    }
  }

  DiningFloor _hydrateFloor(Map<String, dynamic> raw) {
    return DiningFloor()
      ..id = (raw['id'] as num?)?.toInt() ?? 0
      ..name = '${raw['name'] ?? ''}'
      ..sortOrder = (raw['sortOrder'] as num?)?.toInt() ?? 0
      ..isActive = raw['isActive'] != false
      ..createdAt =
          DateTime.tryParse('${raw['createdAt']}') ?? DateTime.now();
  }

  DiningTable _hydrateTable(Map<String, dynamic> raw) {
    return DiningTable()
      ..id = (raw['id'] as num?)?.toInt() ?? 0
      ..floorId = (raw['floorId'] as num?)?.toInt() ?? 0
      ..code = '${raw['code'] ?? ''}'
      ..name = '${raw['name'] ?? ''}'
      ..capacity = (raw['capacity'] as num?)?.toInt() ?? 4
      ..status = '${raw['status'] ?? 'free'}'
      ..posX = (raw['posX'] as num?)?.toDouble() ?? 10
      ..posY = (raw['posY'] as num?)?.toDouble() ?? 10
      ..shape = '${raw['shape'] ?? 'square'}'
      ..guestToken = '${raw['guestToken'] ?? ''}'
      ..guests = (raw['guests'] as num?)?.toInt() ?? 0
      ..openCheckId = (raw['openCheckId'] as num?)?.toInt()
      ..isActive = raw['isActive'] != false
      ..createdAt =
          DateTime.tryParse('${raw['createdAt']}') ?? DateTime.now()
      ..updatedAt = DateTime.tryParse('${raw['updatedAt'] ?? ''}');
  }

  RestaurantCheck _hydrateCheck(Map<String, dynamic> raw) {
    return RestaurantCheck()
      ..id = (raw['id'] as num?)?.toInt() ?? 0
      ..tableId = (raw['tableId'] as num?)?.toInt() ?? 0
      ..tableCode = '${raw['tableCode'] ?? ''}'
      ..guests = (raw['guests'] as num?)?.toInt() ?? 1
      ..status = '${raw['status'] ?? 'open'}'
      ..linesJson = '${raw['linesJson'] ?? '[]'}'
      ..serviceCharge = (raw['serviceCharge'] as num?)?.toDouble() ?? 0
      ..discount = (raw['discount'] as num?)?.toDouble() ?? 0
      ..subtotal = (raw['subtotal'] as num?)?.toDouble() ?? 0
      ..total = (raw['total'] as num?)?.toDouble() ?? 0
      ..source = '${raw['source'] ?? 'pos'}'
      ..webAcceptStatus = '${raw['webAcceptStatus'] ?? ''}'
      ..notes = '${raw['notes'] ?? ''}'
      ..closedSaleId = (raw['closedSaleId'] as num?)?.toInt()
      ..closedInvoiceNo = raw['closedInvoiceNo'] as String?
      ..createdAt =
          DateTime.tryParse('${raw['createdAt']}') ?? DateTime.now()
      ..sentAt = DateTime.tryParse('${raw['sentAt'] ?? ''}')
      ..closedAt = DateTime.tryParse('${raw['closedAt'] ?? ''}')
      ..updatedAt = DateTime.tryParse('${raw['updatedAt'] ?? ''}');
  }

  KitchenTicket _hydrateTicket(Map<String, dynamic> raw) {
    return KitchenTicket()
      ..id = (raw['id'] as num?)?.toInt() ?? 0
      ..checkId = (raw['checkId'] as num?)?.toInt() ?? 0
      ..tableId = (raw['tableId'] as num?)?.toInt() ?? 0
      ..tableCode = '${raw['tableCode'] ?? ''}'
      ..course = '${raw['course'] ?? 'main'}'
      ..station = '${raw['station'] ?? 'kitchen'}'
      ..linesJson = '${raw['linesJson'] ?? '[]'}'
      ..status = '${raw['status'] ?? 'queued'}'
      ..firedAt = DateTime.tryParse('${raw['firedAt']}') ?? DateTime.now()
      ..readyAt = DateTime.tryParse('${raw['readyAt'] ?? ''}')
      ..bumpedAt = DateTime.tryParse('${raw['bumpedAt'] ?? ''}');
  }

  List<Map<String, dynamic>> _decodeLines(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  String _newToken(String code, String secret) {
    final mix = '$secret:$code:${_rng.nextInt(1 << 32)}';
    return mix.hashCode.abs().toRadixString(16).padLeft(8, '0') +
        List.generate(16, (_) => _chars[_rng.nextInt(_chars.length)]).join();
  }

  static const _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
}
