import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:io';

import '../../../database/isar_service.dart';
import '../../../modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import '../lan_api_paths.dart';
import '../lan_mode_service.dart';
import 'lan_auth_token_store.dart';
import 'routes/lan_guest_routes.dart';
import 'routes/lan_host_routes.dart';
import 'sale_write_service.dart';

/// Production shop-host HTTP server (Shelf) — bootstrap only.
class ShopHostServer {
  ShopHostServer(
    this._isarService,
    this._lanMode,
    this._saleWrite,
    this._restaurant,
  ) : tokens = LanAuthTokenStore();

  final IsarService _isarService;
  final LanModeService _lanMode;
  final SaleWriteService _saleWrite;
  final RestaurantLocalDataSource _restaurant;
  final LanAuthTokenStore tokens;

  HttpServer? _server;
  bool _starting = false;

  bool get isRunning => _server != null;
  int? get boundPort => _server?.port;

  Future<void> start() async {
    if (_server != null || _starting) return;
    _starting = true;
    try {
      final router = Router();
      mountLanHostRoutes(
        router,
        isarService: _isarService,
        saleWrite: _saleWrite,
        tokens: tokens,
        restaurant: _restaurant,
      );
      mountLanGuestRoutes(
        router,
        isarService: _isarService,
        restaurant: _restaurant,
      );

      final handler = const Pipeline()
          .addMiddleware(logRequests())
          .addMiddleware(_cors())
          .addMiddleware(_auth())
          .addHandler(router.call);

      _server = await shelf_io.serve(
        handler,
        InternetAddress.anyIPv4,
        _lanMode.bindPort,
      );
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    final server = _server;
    _server = null;
    tokens.clear();
    await server?.close(force: true);
  }

  Middleware _auth() {
    return (inner) {
      return (request) async {
        final path = '/${request.url.path}'.replaceAll('//', '/');
        final isPublic = path == LanApiPaths.health ||
            path == LanApiPaths.login ||
            path == '/guest' ||
            path == '/guest/' ||
            path.startsWith('/guest/') ||
            request.method == 'OPTIONS';
        if (isPublic) {
          return inner(request);
        }
        final session = tokens.resolve(request.headers['authorization']);
        if (session == null) {
          return Response(
            401,
            body: jsonEncode({
              'error': 'Authentication required',
              'code': 'auth_required',
            }),
            headers: const {'Content-Type': 'application/json'},
          );
        }
        return inner(
          request.change(
            context: {
              ...request.context,
              LanRequestContext.authSession: session,
            },
          ),
        );
      };
    };
  }

  Middleware _cors() {
    return (inner) {
      return (request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: _corsHeaders);
        }
        final response = await inner(request);
        return response.change(headers: _corsHeaders);
      };
    };
  }

  static const _corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers':
        'Origin, Content-Type, Authorization, Accept',
  };
}
