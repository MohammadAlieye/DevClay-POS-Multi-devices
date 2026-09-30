import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../../../database/isar_service.dart';
import '../lan_mode_service.dart';
import 'routes/lan_host_routes.dart';
import 'sale_write_service.dart';

/// Production shop-host HTTP server (Shelf) — bootstrap only.
class ShopHostServer {
  ShopHostServer(this._isarService, this._lanMode, this._saleWrite);

  final IsarService _isarService;
  final LanModeService _lanMode;
  final SaleWriteService _saleWrite;

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
      );

      final handler = const Pipeline()
          .addMiddleware(logRequests())
          .addMiddleware(_cors())
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
    await server?.close(force: true);
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
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
  };
}
