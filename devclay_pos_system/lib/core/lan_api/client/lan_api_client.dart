import 'dart:convert';

import 'package:http/http.dart' as http;

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

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = Uri.parse('${_lanMode.clientBaseUrl}$path');
    if (query == null || query.isEmpty) return base;
    return base.replace(queryParameters: query);
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
          .get(_uri(path, query))
          .timeout(_callTimeout);
    } catch (e) {
      throw LanApiException.hostOffline('$e');
    }
  }

  Future<http.Response> _post(String path, Object body) async {
    try {
      return await http
          .post(
            _uri(path),
            headers: const {'Content-Type': 'application/json'},
            body: body is String ? body : jsonEncode(body),
          )
          .timeout(_callTimeout);
    } catch (e) {
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
    return LanAuthUserDto.fromJson(await _decode(res));
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
}
