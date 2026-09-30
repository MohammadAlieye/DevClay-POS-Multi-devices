import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../database/collections/dining_floor.dart';
import '../../../../database/collections/dining_table.dart';
import '../../../../database/collections/kitchen_ticket.dart';
import '../../../../database/collections/restaurant_check.dart';
import '../../../../modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import '../../lan_api_paths.dart';

/// Authenticated restaurant staff routes for Counter devices.
void mountLanRestaurantRoutes(
  Router router, {
  required RestaurantLocalDataSource restaurant,
}) {
  router.get(LanApiPaths.restaurantFloors, (Request request) async {
    await restaurant.ensureSeededIfNeeded();
    final floors = await restaurant.listFloors();
    return _ok({'items': [for (final f in floors) _floorJson(f)]});
  });

  router.post(LanApiPaths.restaurantFloors, (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final floor = await restaurant.createFloor('${body['name'] ?? ''}');
      return _ok(_floorJson(floor));
    } catch (e) {
      return _err(e.toString());
    }
  });

  router.get(LanApiPaths.restaurantTables, (Request request) async {
    await restaurant.ensureSeededIfNeeded();
    final floorId = int.tryParse(request.url.queryParameters['floorId'] ?? '');
    final tables = await restaurant.listTables(floorId: floorId);
    return _ok({'items': [for (final t in tables) _tableJson(t)]});
  });

  router.post(LanApiPaths.restaurantTables, (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final table = await restaurant.upsertTable(
        id: (body['id'] as num?)?.toInt(),
        floorId: (body['floorId'] as num?)?.toInt() ?? 0,
        code: '${body['code'] ?? ''}',
        name: '${body['name'] ?? ''}',
        capacity: (body['capacity'] as num?)?.toInt() ?? 4,
        posX: (body['posX'] as num?)?.toDouble() ?? 10,
        posY: (body['posY'] as num?)?.toDouble() ?? 10,
        shape: '${body['shape'] ?? 'square'}',
      );
      return _ok(_tableJson(table));
    } catch (e) {
      return _err(e.toString());
    }
  });

  router.post(
    '${LanApiPaths.restaurantTableById}<id|[0-9]+>/regenerate-token',
    (Request request, String id) async {
      final tableId = int.tryParse(id);
      if (tableId == null) return _err('Invalid id', status: 400);
      await restaurant.regenerateTableToken(tableId);
      final table = await restaurant.getTable(tableId);
      if (table == null) return _err('Not found', status: 404);
      return _ok(_tableJson(table));
    },
  );

  router.post('${LanApiPaths.restaurantTableById}<id|[0-9]+>/clear', (
    Request request,
    String id,
  ) async {
    final tableId = int.tryParse(id);
    if (tableId == null) return _err('Invalid id', status: 400);
    await restaurant.clearTable(tableId);
    final table = await restaurant.getTable(tableId);
    return _ok(table == null ? {'ok': true} : _tableJson(table));
  });

  router.get(LanApiPaths.restaurantChecks, (Request request) async {
    final open = request.url.queryParameters['open'] == '1' ||
        request.url.queryParameters['open'] == 'true';
    if (!open) {
      return _err('Use ?open=1', status: 400);
    }
    final checks = await restaurant.listOpenChecks();
    return _ok({'items': [for (final c in checks) _checkJson(c)]});
  });

  router.post('${LanApiPaths.restaurantChecks}/open', (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final check = await restaurant.openOrGetCheck(
        tableId: (body['tableId'] as num?)?.toInt() ?? 0,
        guests: (body['guests'] as num?)?.toInt() ?? 2,
        source: '${body['source'] ?? 'pos'}',
      );
      return _ok(_checkJson(check));
    } catch (e) {
      return _err(e.toString());
    }
  });

  router.get('${LanApiPaths.restaurantCheckById}<id|[0-9]+>', (
    Request request,
    String id,
  ) async {
    final checkId = int.tryParse(id);
    if (checkId == null) return _err('Invalid id', status: 400);
    final check = await restaurant.getCheck(checkId);
    if (check == null) return _err('Not found', status: 404);
    return _ok(_checkJson(check));
  });

  router.post('${LanApiPaths.restaurantCheckById}<id|[0-9]+>/accept-web', (
    Request request,
    String id,
  ) async {
    try {
      final checkId = int.tryParse(id);
      if (checkId == null) return _err('Invalid id', status: 400);
      final check = await restaurant.acceptWebOrder(checkId);
      return _ok(_checkJson(check));
    } catch (e) {
      return _err(e.toString());
    }
  });

  router.post('${LanApiPaths.restaurantCheckById}<id|[0-9]+>/fire-kitchen', (
    Request request,
    String id,
  ) async {
    try {
      final checkId = int.tryParse(id);
      if (checkId == null) return _err('Invalid id', status: 400);
      var course = 'main';
      try {
        final body =
            jsonDecode(await request.readAsString()) as Map<String, dynamic>;
        course = '${body['course'] ?? 'main'}';
      } catch (_) {}
      final ticket = await restaurant.fireKitchenTicket(
        checkId: checkId,
        course: course,
      );
      return _ok(_ticketJson(ticket));
    } catch (e) {
      return _err(e.toString());
    }
  });

  router.post('${LanApiPaths.restaurantCheckById}<id|[0-9]+>/close', (
    Request request,
    String id,
  ) async {
    try {
      final checkId = int.tryParse(id);
      if (checkId == null) return _err('Invalid id', status: 400);
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final check = await restaurant.closeCheck(
        checkId: checkId,
        saleId: (body['saleId'] as num?)?.toInt() ?? 0,
        invoiceNo: '${body['invoiceNo'] ?? ''}',
      );
      return _ok(_checkJson(check));
    } catch (e) {
      return _err(e.toString());
    }
  });

  router.get(LanApiPaths.restaurantKitchenTickets, (Request request) async {
    final openOnly = request.url.queryParameters['openOnly'] != '0';
    final tickets = await restaurant.listKitchenTickets(openOnly: openOnly);
    return _ok({'items': [for (final t in tickets) _ticketJson(t)]});
  });

  router.post(
    '${LanApiPaths.restaurantKitchenTicketById}<id|[0-9]+>/bump',
    (Request request, String id) async {
      final ticketId = int.tryParse(id);
      if (ticketId == null) return _err('Invalid id', status: 400);
      var to = 'ready';
      try {
        final body =
            jsonDecode(await request.readAsString()) as Map<String, dynamic>;
        to = '${body['to'] ?? 'ready'}';
      } catch (_) {}
      await restaurant.bumpKitchenTicket(ticketId, to: to);
      return _ok({'ok': true});
    },
  );
}

Map<String, dynamic> _floorJson(DiningFloor f) => {
      'id': f.id,
      'name': f.name,
      'sortOrder': f.sortOrder,
      'isActive': f.isActive,
      'createdAt': f.createdAt.toIso8601String(),
    };

Map<String, dynamic> _tableJson(DiningTable t) => {
      'id': t.id,
      'floorId': t.floorId,
      'code': t.code,
      'name': t.name,
      'capacity': t.capacity,
      'status': t.status,
      'posX': t.posX,
      'posY': t.posY,
      'shape': t.shape,
      'guestToken': t.guestToken,
      'guests': t.guests,
      'openCheckId': t.openCheckId,
      'isActive': t.isActive,
      'createdAt': t.createdAt.toIso8601String(),
      'updatedAt': t.updatedAt?.toIso8601String(),
    };

Map<String, dynamic> _checkJson(RestaurantCheck c) => {
      'id': c.id,
      'tableId': c.tableId,
      'tableCode': c.tableCode,
      'guests': c.guests,
      'status': c.status,
      'linesJson': c.linesJson,
      'serviceCharge': c.serviceCharge,
      'discount': c.discount,
      'subtotal': c.subtotal,
      'total': c.total,
      'source': c.source,
      'webAcceptStatus': c.webAcceptStatus,
      'notes': c.notes,
      'closedSaleId': c.closedSaleId,
      'closedInvoiceNo': c.closedInvoiceNo,
      'createdAt': c.createdAt.toIso8601String(),
      'sentAt': c.sentAt?.toIso8601String(),
      'closedAt': c.closedAt?.toIso8601String(),
      'updatedAt': c.updatedAt?.toIso8601String(),
    };

Map<String, dynamic> _ticketJson(KitchenTicket t) => {
      'id': t.id,
      'checkId': t.checkId,
      'tableId': t.tableId,
      'tableCode': t.tableCode,
      'course': t.course,
      'station': t.station,
      'linesJson': t.linesJson,
      'status': t.status,
      'firedAt': t.firedAt.toIso8601String(),
      'readyAt': t.readyAt?.toIso8601String(),
      'bumpedAt': t.bumpedAt?.toIso8601String(),
    };

Response _ok(Object body) => Response.ok(
      jsonEncode(body),
      headers: const {'Content-Type': 'application/json'},
    );

Response _err(String message, {int status = 400, String code = 'error'}) =>
    Response(
      status,
      body: jsonEncode({'error': message, 'code': code}),
      headers: const {'Content-Type': 'application/json'},
    );
