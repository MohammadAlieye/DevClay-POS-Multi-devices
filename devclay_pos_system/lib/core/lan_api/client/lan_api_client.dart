import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../dtos/lan_dtos.dart';
import '../lan_api_errors.dart';
import '../lan_api_paths.dart';
import '../lan_mode_service.dart';

/// HTTP client for Counter (client) mode.
class LanApiClient {
  LanApiClient(this._lanMode);

  final LanModeService _lanMode;

  static const _connectTimeout = Duration(seconds: 3);
  static const _callTimeout = Duration(seconds: 12);
  static const _tokenKey = 'lan_auth_token';

  String? _token;

  String? get authToken => _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> _persistToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token == null || token.isEmpty) {
      await prefs.remove(_tokenKey);
    } else {
      await prefs.setString(_tokenKey, token);
    }
  }

  Future<void> clearToken() => _persistToken(null);

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = Uri.parse('${_lanMode.clientBaseUrl}$path');
    if (query == null || query.isEmpty) return base;
    return base.replace(queryParameters: query);
  }

  Map<String, String> _headers({bool jsonBody = false}) {
    return {
      if (jsonBody) 'Content-Type': 'application/json',
      if (_token != null && _token!.isNotEmpty)
        'Authorization': 'Bearer $_token',
    };
  }

  Future<Map<String, dynamic>> _decode(http.Response res) {
    Map<String, dynamic>? body;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) body = decoded;
    } catch (_) {}
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw LanApiException.fromBody(res.statusCode, body);
    }
    return Future.value(body ?? <String, dynamic>{});
  }

  Future<http.Response> _get(String path, [Map<String, String>? query]) async {
    try {
      return await http
          .get(_uri(path, query), headers: _headers())
          .timeout(_callTimeout);
    } catch (e) {
      if (e is LanApiException) rethrow;
      throw LanApiException.hostOffline('$e');
    }
  }

  Future<http.Response> _post(String path, Object body) async {
    try {
      return await http
          .post(
            _uri(path),
            headers: _headers(jsonBody: true),
            body: body is String ? body : jsonEncode(body),
          )
          .timeout(_callTimeout);
    } catch (e) {
      if (e is LanApiException) rethrow;
      throw LanApiException.hostOffline('$e');
    }
  }

  Future<http.Response> _delete(String path) async {
    try {
      return await http
          .delete(_uri(path), headers: _headers())
          .timeout(_callTimeout);
    } catch (e) {
      if (e is LanApiException) rethrow;
      throw LanApiException.hostOffline('$e');
    }
  }

  Future<LanHealthDto> health() async {
    final res = await _get(LanApiPaths.health).timeout(_connectTimeout);
    final body = await _decode(res);
    return LanHealthDto.fromJson(body);
  }

  Future<LanProfileDto> fetchProfile() async {
    final res = await _get(LanApiPaths.profile);
    return LanProfileDto.fromJson(await _decode(res));
  }

  Future<LanAuthUserDto> login({
    required String username,
    required String password,
  }) async {
    final res = await _post(LanApiPaths.login, {
      'username': username,
      'password': password,
    });
    final body = await _decode(res);
    final token = '${body['token'] ?? ''}';
    if (token.isNotEmpty) {
      await _persistToken(token);
    }
    return LanAuthUserDto.fromJson(body);
  }

  Future<String> fetchNextInvoicePreview() async {
    final res = await _get(LanApiPaths.nextInvoicePreview);
    final body = await _decode(res);
    return '${body['invoiceNo'] ?? ''}';
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final res = await _get(LanApiPaths.products);
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCustomers() async {
    final res = await _get(LanApiPaths.customers);
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> createCustomer(Map<String, dynamic> payload) async {
    final res = await _post(LanApiPaths.customers, payload);
    return _decode(res);
  }

  Future<Map<String, dynamic>> recordCustomerPayment({
    required int customerId,
    required double amount,
    String? note,
  }) async {
    final res = await _post(
      '${LanApiPaths.customerPayment}$customerId/payments',
      {'amount': amount, if (note != null) 'note': note},
    );
    return _decode(res);
  }

  Future<List<Map<String, dynamic>>> fetchPaymentAccounts() async {
    final res = await _get(LanApiPaths.paymentAccounts);
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchSales({
    String query = '',
    int limit = 100,
  }) async {
    final res = await _get(LanApiPaths.sales, {
      if (query.trim().isNotEmpty) 'q': query.trim(),
      'limit': '$limit',
    });
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> fetchSaleById(int id) async {
    final res = await _get('${LanApiPaths.saleById}$id');
    return _decode(res);
  }

  Future<Map<String, dynamic>> createSale(LanCreateSaleDto request) async {
    final res = await _post(LanApiPaths.sales, request.encode());
    return _decode(res);
  }

  Future<List<Map<String, dynamic>>> fetchCustomerLedger(int customerId) async {
    final res = await _get('${LanApiPaths.customerById}$customerId/ledger');
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCustomerSales(int customerId) async {
    final res = await _get('${LanApiPaths.customerById}$customerId/sales');
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // --- Restaurant ---

  Future<List<Map<String, dynamic>>> fetchRestaurantFloors() async {
    final res = await _get(LanApiPaths.restaurantFloors);
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> createRestaurantFloor(String name) async {
    final res = await _post(LanApiPaths.restaurantFloors, {'name': name});
    return _decode(res);
  }

  Future<List<Map<String, dynamic>>> fetchRestaurantTables({int? floorId}) async {
    final res = await _get(LanApiPaths.restaurantTables, {
      if (floorId != null) 'floorId': '$floorId',
    });
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> upsertRestaurantTable(
    Map<String, dynamic> payload,
  ) async {
    final res = await _post(LanApiPaths.restaurantTables, payload);
    return _decode(res);
  }

  Future<Map<String, dynamic>> regenerateRestaurantTableToken(int id) async {
    final res = await _post(
      '${LanApiPaths.restaurantTableById}$id/regenerate-token',
      {},
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> clearRestaurantTable(int id) async {
    final res = await _post('${LanApiPaths.restaurantTableById}$id/clear', {});
    return _decode(res);
  }

  Future<Map<String, dynamic>> openRestaurantCheck({
    required int tableId,
    int guests = 2,
    String source = 'pos',
  }) async {
    final res = await _post('${LanApiPaths.restaurantChecks}/open', {
      'tableId': tableId,
      'guests': guests,
      'source': source,
    });
    return _decode(res);
  }

  Future<Map<String, dynamic>> fetchRestaurantCheck(int id) async {
    final res = await _get('${LanApiPaths.restaurantCheckById}$id');
    return _decode(res);
  }

  Future<List<Map<String, dynamic>>> fetchOpenRestaurantChecks() async {
    final res = await _get(LanApiPaths.restaurantChecks, {'open': '1'});
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> acceptRestaurantWebOrder(int checkId) async {
    final res = await _post(
      '${LanApiPaths.restaurantCheckById}$checkId/accept-web',
      {},
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> fireRestaurantKitchen({
    required int checkId,
    String course = 'main',
  }) async {
    final res = await _post(
      '${LanApiPaths.restaurantCheckById}$checkId/fire-kitchen',
      {'course': course},
    );
    return _decode(res);
  }

  Future<Map<String, dynamic>> closeRestaurantCheck({
    required int checkId,
    required int saleId,
    required String invoiceNo,
  }) async {
    final res = await _post(
      '${LanApiPaths.restaurantCheckById}$checkId/close',
      {'saleId': saleId, 'invoiceNo': invoiceNo},
    );
    return _decode(res);
  }

  Future<List<Map<String, dynamic>>> fetchKitchenTickets({
    bool openOnly = true,
  }) async {
    final res = await _get(LanApiPaths.restaurantKitchenTickets, {
      'openOnly': openOnly ? '1' : '0',
    });
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> bumpKitchenTicket(int ticketId, {String to = 'ready'}) async {
    final res = await _post(
      '${LanApiPaths.restaurantKitchenTicketById}$ticketId/bump',
      {'to': to},
    );
    await _decode(res);
  }

  Future<Map<String, dynamic>> processSaleReturn({
    required int saleId,
    required Map<String, dynamic> payload,
  }) async {
    final res = await _post('${LanApiPaths.saleReturn}$saleId/returns', payload);
    return _decode(res);
  }

  Future<List<Map<String, dynamic>>> fetchHeldSales() async {
    final res = await _get(LanApiPaths.heldSales);
    final body = await _decode(res);
    final items = body['items'];
    if (items is! List) return const [];
    return items.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>> createHeldSale(Map<String, dynamic> payload) async {
    final res = await _post(LanApiPaths.heldSales, payload);
    return _decode(res);
  }

  Future<Map<String, dynamic>?> fetchHeldSale(int id) async {
    final res = await _get('${LanApiPaths.heldSaleById}$id');
    return _decode(res);
  }

  Future<void> deleteHeldSale(int id) async {
    final res = await _delete('${LanApiPaths.heldSaleById}$id');
    await _decode(res);
  }

  Future<Map<String, dynamic>> fetchDashboardSummary() async {
    final res = await _get(LanApiPaths.dashboardSummary);
    return _decode(res);
  }
}
