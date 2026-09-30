import 'dart:convert';
import 'dart:io';

import 'package:devclay_pos_system/core/auth/password_hasher.dart';
import 'package:devclay_pos_system/core/lan_api/client/lan_api_client.dart';
import 'package:devclay_pos_system/core/lan_api/host/lan_auth_token_store.dart';
import 'package:devclay_pos_system/core/lan_api/host/routes/lan_guest_routes.dart';
import 'package:devclay_pos_system/core/lan_api/host/routes/lan_host_routes.dart';
import 'package:devclay_pos_system/core/lan_api/host/sale_write_service.dart';
import 'package:devclay_pos_system/core/lan_api/lan_api_paths.dart';
import 'package:devclay_pos_system/core/lan_api/lan_mode_service.dart';
import 'package:devclay_pos_system/database/collections/account.dart';
import 'package:devclay_pos_system/database/collections/app_setting.dart';
import 'package:devclay_pos_system/database/collections/customer.dart';
import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/collections/product_variant.dart';
import 'package:devclay_pos_system/database/collections/user_account.dart';
import 'package:devclay_pos_system/database/isar_service.dart';
import 'package:devclay_pos_system/database/product_batch_store.dart';
import 'package:devclay_pos_system/modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class TestIsarService extends IsarService {
  TestIsarService(this._isar);

  final Isar _isar;

  @override
  Isar get instance => _isar;
}

/// In-process Shop Host + seeded Isar for production-style LAN API tests.
class LanTestHarness {
  LanTestHarness._({
    required this.directory,
    required this.isar,
    required this.isarService,
    required this.saleWrite,
    required this.lanMode,
    required this.server,
    required this.client,
    required this.fixtures,
    required this.tokens,
  });

  final Directory directory;
  final Isar isar;
  final TestIsarService isarService;
  final SaleWriteService saleWrite;
  final LanModeService lanMode;
  final HttpServer server;
  final LanApiClient client;
  final LanFixtures fixtures;
  final LanAuthTokenStore tokens;

  String? authToken;

  String get baseUrl => 'http://127.0.0.1:${server.port}';

  static Future<LanTestHarness> start() async {
    SharedPreferences.setMockInitialValues({});

    final directory = await Directory.systemTemp.createTemp('lan_api_harness_');
    final isar = await Isar.open(
      IsarService.schemas,
      directory: directory.path,
      name: 'lan_${DateTime.now().microsecondsSinceEpoch}',
    );
    final isarService = TestIsarService(isar);
    final fixtures = await LanFixtures.seed(isar);
    final saleWrite = SaleWriteService(isarService);
    final tokens = LanAuthTokenStore();

    final lanMode = LanModeService();
    await lanMode.load();
    await lanMode.setMode(LanDeviceMode.host);
    await lanMode.setBindPort(0);

    final restaurant = RestaurantLocalDataSource(isarService, forceLocal: true);

    final router = Router();
    mountLanHostRoutes(
      router,
      isarService: isarService,
      saleWrite: saleWrite,
      tokens: tokens,
      restaurant: restaurant,
    );
    mountLanGuestRoutes(
      router,
      isarService: isarService,
      restaurant: restaurant,
    );
    final handler = const Pipeline()
        .addMiddleware(_cors())
        .addMiddleware(_auth(tokens))
        .addHandler(router.call);
    final server = await shelf_io.serve(
      handler,
      InternetAddress.loopbackIPv4,
      0,
    );

    await lanMode.setHostAddress(ip: '127.0.0.1', port: server.port);
    await lanMode.setMode(LanDeviceMode.client);

    final harness = LanTestHarness._(
      directory: directory,
      isar: isar,
      isarService: isarService,
      saleWrite: saleWrite,
      lanMode: lanMode,
      server: server,
      client: LanApiClient(lanMode),
      fixtures: fixtures,
      tokens: tokens,
    );
    await harness.loginAsAdmin();
    return harness;
  }

  Future<void> loginAsAdmin() async {
    final user = await client.login(
      username: LanFixtures.adminUsername,
      password: LanFixtures.adminPassword,
    );
    authToken = client.authToken;
    assert(user.id == fixtures.adminUserId);
  }

  Map<String, String> _authHeaders({bool json = false}) => {
        if (json) 'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
      };

  Future<http.Response> get(
    String path, {
    Map<String, String>? query,
    bool authed = true,
  }) {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    return http.get(
      uri,
      headers: authed ? _authHeaders() : const {},
    );
  }

  Future<http.Response> post(
    String path,
    Object body, {
    bool authed = true,
  }) {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: authed
          ? _authHeaders(json: true)
          : const {'Content-Type': 'application/json'},
      body: body is String ? body : jsonEncode(body),
    );
  }

  Future<Map<String, dynamic>> decodeOk(http.Response res) async {
    expectStatus(res, 200);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  void expectStatus(http.Response res, int status) {
    if (res.statusCode != status) {
      throw TestFailure(
        'Expected HTTP $status but got ${res.statusCode}: ${res.body}',
      );
    }
  }

  Future<void> dispose() async {
    await server.close(force: true);
    if (isar.isOpen) {
      await isar.close(deleteFromDisk: true);
    }
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  static Middleware _auth(LanAuthTokenStore tokens) {
    return (inner) {
      return (request) async {
        final path = '/${request.url.path}'.replaceAll('//', '/');
        final isPublic = path == LanApiPaths.health ||
            path == LanApiPaths.login ||
            path == '/guest' ||
            path == '/guest/' ||
            path.startsWith('/guest/') ||
            request.method == 'OPTIONS';
        if (isPublic) return inner(request);
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
        return inner(request);
      };
    };
  }

  static Middleware _cors() {
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

class LanFixtures {
  LanFixtures({
    required this.adminUserId,
    required this.inactiveUserId,
    required this.productId,
    required this.lowStockProductId,
    required this.inactiveProductId,
    required this.deletedProductId,
    required this.variantProductId,
    required this.variantId,
    required this.batchEarlyId,
    required this.batchLateId,
    required this.customerId,
    required this.cashAccountId,
    required this.bankAccountId,
  });

  final int adminUserId;
  final int inactiveUserId;
  final int productId;
  final int lowStockProductId;
  final int inactiveProductId;
  final int deletedProductId;
  final int variantProductId;
  final int variantId;
  final int batchEarlyId;
  final int batchLateId;
  final int customerId;
  final int cashAccountId;
  final int bankAccountId;

  static const adminUsername = 'admin';
  static const adminPassword = 'admin123';
  static const inactiveUsername = 'inactive';
  static const inactivePassword = 'secret';

  static Future<LanFixtures> seed(Isar isar) async {
    final now = DateTime.now();
    late int adminUserId;
    late int inactiveUserId;
    late int productId;
    late int lowStockProductId;
    late int inactiveProductId;
    late int deletedProductId;
    late int variantProductId;
    late int variantId;
    late int batchEarlyId;
    late int batchLateId;
    late int customerId;
    late int cashAccountId;
    late int bankAccountId;

    await isar.writeTxn(() async {
      await isar.appSettings.put(
        AppSetting()
          ..key = 'default'
          ..businessName = 'LAN Test Host'
          ..businessPhone = '0300'
          ..businessEmail = 'host@test.local'
          ..businessAddress = 'Test Street'
          ..taxNumber = 'TAX-1'
          ..defaultTaxRate = 0
          ..defaultTaxInclusive = true
          ..receiptFooter = 'Thanks'
          ..showBusinessInfoOnReceipt = true
          ..printerName = ''
          ..autoPrintReceipt = false
          ..paperWidthMm = 80
          ..storeProfile = 'general_retail'
          ..storeProfileConfigured = true
          ..enableBatchesExpiry = true
          ..enableProductVariants = true
          ..productCategoriesCsv = 'Grocery,Drinks'
          ..productUnitsCsv = 'pcs,box',
      );

      final adminSalt = 'salt-admin';
      adminUserId = await isar.userAccounts.put(
        UserAccount()
          ..username = adminUsername
          ..displayName = 'Admin'
          ..role = 'owner'
          ..permissions = const ['*']
          ..passwordSalt = adminSalt
          ..passwordHash = PasswordHasher.hash(adminPassword, adminSalt)
          ..isActive = true
          ..createdAt = now,
      );

      final inactiveSalt = 'salt-inactive';
      inactiveUserId = await isar.userAccounts.put(
        UserAccount()
          ..username = inactiveUsername
          ..displayName = 'Inactive'
          ..role = 'cashier'
          ..permissions = const ['pos']
          ..passwordSalt = inactiveSalt
          ..passwordHash = PasswordHasher.hash(inactivePassword, inactiveSalt)
          ..isActive = false
          ..createdAt = now,
      );

      final product = Product()
        ..sku = 'SKU-TEA'
        ..barcode = '1001'
        ..name = 'Green Tea'
        ..category = 'Grocery'
        ..unit = 'pcs'
        ..sellingPrice = 100
        ..purchasePrice = 60
        ..taxRate = 0
        ..taxInclusive = true
        ..stock = 0
        ..isActive = true;
      productId = await isar.products.put(product);
      product.id = productId;

      final early = await ProductBatchStore.receive(
        isar: isar,
        product: product,
        quantity: 5,
        batchCode: 'B-EARLY',
        expiryDate: DateTime(2026, 3, 1),
      );
      final late = await ProductBatchStore.receive(
        isar: isar,
        product: product,
        quantity: 5,
        batchCode: 'B-LATE',
        expiryDate: DateTime(2027, 3, 1),
      );
      batchEarlyId = early.id;
      batchLateId = late.id;

      final low = Product()
        ..sku = 'SKU-LOW'
        ..barcode = '1002'
        ..name = 'Low Stock Item'
        ..category = 'Grocery'
        ..unit = 'pcs'
        ..sellingPrice = 50
        ..purchasePrice = 30
        ..taxRate = 0
        ..taxInclusive = true
        ..stock = 0
        ..isActive = true;
      lowStockProductId = await isar.products.put(low);
      low.id = lowStockProductId;
      await ProductBatchStore.receive(
        isar: isar,
        product: low,
        quantity: 2,
        batchCode: 'B-LOW',
      );

      inactiveProductId = await isar.products.put(
        Product()
          ..sku = 'SKU-OFF'
          ..barcode = '1003'
          ..name = 'Inactive Product'
          ..category = 'Grocery'
          ..sellingPrice = 10
          ..purchasePrice = 5
          ..taxRate = 0
          ..taxInclusive = true
          ..stock = 10
          ..isActive = false,
      );

      deletedProductId = await isar.products.put(
        Product()
          ..sku = 'SKU-DEL'
          ..barcode = '1004'
          ..name = 'Deleted Product'
          ..category = 'Grocery'
          ..sellingPrice = 10
          ..purchasePrice = 5
          ..taxRate = 0
          ..taxInclusive = true
          ..stock = 10
          ..isActive = true
          ..deletedAt = now,
      );

      final variantParent = Product()
        ..sku = 'SKU-SHIRT'
        ..barcode = '2001'
        ..name = 'T-Shirt'
        ..category = 'Clothing'
        ..hasVariants = true
        ..sellingPrice = 800
        ..purchasePrice = 400
        ..taxRate = 0
        ..taxInclusive = true
        ..stock = 0
        ..isActive = true;
      variantProductId = await isar.products.put(variantParent);
      variantParent.id = variantProductId;
      await ProductBatchStore.receive(
        isar: isar,
        product: variantParent,
        quantity: 4,
        batchCode: 'B-VAR',
      );
      variantId = await isar.productVariants.put(
        ProductVariant()
          ..productId = variantProductId
          ..size = 'M'
          ..color = 'Blue'
          ..sku = 'SHIRT-M-BLU'
          ..barcode = '2001-M'
          ..stock = 4
          ..isActive = true,
      );
      variantParent.stock = 4;
      await isar.products.put(variantParent);

      customerId = await isar.customers.put(
        Customer()
          ..name = 'Ali Khan'
          ..phone = '03001234567'
          ..email = 'ali@test.local'
          ..address = 'Lahore'
          ..balance = 0
          ..creditLimit = 5000
          ..isActive = true
          ..createdAt = now,
      );

      cashAccountId = await isar.accounts.put(
        Account()
          ..name = 'Cash Drawer'
          ..type = 'cash'
          ..balance = 1000
          ..isDefault = true
          ..isActive = true
          ..createdAt = now,
      );
      bankAccountId = await isar.accounts.put(
        Account()
          ..name = 'HBL'
          ..type = 'bank'
          ..balance = 5000
          ..isDefault = false
          ..isActive = true
          ..createdAt = now,
      );
    });

    return LanFixtures(
      adminUserId: adminUserId,
      inactiveUserId: inactiveUserId,
      productId: productId,
      lowStockProductId: lowStockProductId,
      inactiveProductId: inactiveProductId,
      deletedProductId: deletedProductId,
      variantProductId: variantProductId,
      variantId: variantId,
      batchEarlyId: batchEarlyId,
      batchLateId: batchLateId,
      customerId: customerId,
      cashAccountId: cashAccountId,
      bankAccountId: bankAccountId,
    );
  }
}

class TestFailure implements Exception {
  TestFailure(this.message);
  final String message;
  @override
  String toString() => message;
}
