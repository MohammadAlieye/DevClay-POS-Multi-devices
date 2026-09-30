import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../../database/collections/account.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/customer_ledger_entry.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/product_batch.dart';
import '../../../../database/collections/product_variant.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/collections/user_account.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/product_batch_store.dart';
import '../../../../modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import '../../../auth/password_hasher.dart';
import '../../dtos/lan_dtos.dart';
import '../../lan_api_errors.dart';
import '../../lan_api_paths.dart';
import '../lan_auth_token_store.dart';
import '../sale_write_service.dart';
import 'lan_host_ops.dart';
import 'lan_restaurant_routes.dart';

/// Registers all /api/v1 host routes on [router].
void mountLanHostRoutes(
  Router router, {
  required IsarService isarService,
  required SaleWriteService saleWrite,
  required LanAuthTokenStore tokens,
  RestaurantLocalDataSource? restaurant,
}) {
  final isar = isarService.instance;
  final ops = LanHostOps(isarService);

  router.get(LanApiPaths.health, (Request request) async {
    final settings = await _settings(isar);
    return _ok(
      LanHealthDto(
        ok: true,
        businessName: settings?.businessName ?? 'DevClayPOS Host',
        storeProfile: settings?.storeProfile ?? '',
        apiVersion: LanApiPaths.apiVersion,
        serverTime: DateTime.now().toIso8601String(),
      ).toJson(),
    );
  });

  router.post(LanApiPaths.login, (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final username = '${body['username'] ?? ''}'.trim().toLowerCase();
      final password = '${body['password'] ?? ''}';
      if (username.isEmpty || password.isEmpty) {
        return _err('Username and password required', status: 400);
      }
      final user = await isar.userAccounts
          .filter()
          .usernameEqualTo(username)
          .findFirst();
      if (user == null || user.deletedAt != null || !user.isActive) {
        return _err('Invalid credentials', status: 401, code: 'auth_failed');
      }
      if (!PasswordHasher.verify(
        password: password,
        salt: user.passwordSalt,
        expectedHash: user.passwordHash,
      )) {
        return _err('Invalid credentials', status: 401, code: 'auth_failed');
      }
      final session = tokens.issue(
        userId: user.id,
        username: user.username,
        displayName: user.displayName,
        role: user.role,
        permissions: user.permissions,
      );
      return _ok({
        'id': user.id,
        'username': user.username,
        'displayName': user.displayName,
        'role': user.role,
        'permissions': user.permissions,
        'token': session.token,
      });
    } catch (e) {
      return _err(e.toString(), status: 400);
    }
  });

  router.get(LanApiPaths.profile, (Request request) async {
    final settings = await _settings(isar);
    if (settings == null) {
      return _err('Settings missing', status: 404);
    }
    return _ok(
      LanProfileDto(
        storeProfile: settings.storeProfile,
        storeProfileConfigured: settings.storeProfileConfigured,
        enableBatchesExpiry: settings.enableBatchesExpiry,
        batchesExpiryRequired: settings.batchesExpiryRequired,
        enableProductVariants: settings.enableProductVariants,
        enableVariableMeasureSales: settings.enableVariableMeasureSales,
        preferVolumeUnits: settings.preferVolumeUnits,
        productCategoriesCsv: settings.productCategoriesCsv,
        productUnitsCsv: settings.productUnitsCsv,
        preferredLabelStoreType: settings.preferredLabelStoreType,
      ).toJson(),
    );
  });

  router.get(LanApiPaths.products, (Request request) async {
    final products =
        await isar.products.filter().deletedAtIsNull().findAll();
    final variants = await isar.productVariants
        .filter()
        .deletedAtIsNull()
        .findAll();
    final byProduct = <int, List<ProductVariant>>{};
    for (final v in variants.where((v) => v.isActive)) {
      byProduct.putIfAbsent(v.productId, () => []).add(v);
    }
    final items = <Map<String, dynamic>>[];
    for (final p in products.where((p) => p.isActive)) {
      final lots = await ProductBatchStore.batchesForProduct(isar, p.id);
      items.add(_productJson(p, byProduct[p.id] ?? const [], lots));
    }
    return _ok({'items': items});
  });

  router.get('${LanApiPaths.productById}<id|[0-9]+>', (
    Request request,
    String id,
  ) async {
    final productId = int.tryParse(id);
    if (productId == null) return _err('Invalid id', status: 400);
    final product = await isar.products.get(productId);
    if (product == null || product.deletedAt != null || !product.isActive) {
      return _err('Not found', status: 404);
    }
    final variants = await isar.productVariants
        .filter()
        .productIdEqualTo(productId)
        .deletedAtIsNull()
        .findAll();
    final lots = await ProductBatchStore.batchesForProduct(isar, productId);
    return _ok(_productJson(product, variants, lots));
  });

  router.get(LanApiPaths.customers, (Request request) async {
    final customers =
        await isar.customers.filter().isActiveEqualTo(true).findAll();
    customers.sort((a, b) => a.name.compareTo(b.name));
    return _ok({
      'items': [
        for (final c in customers)
          {
            'id': c.id,
            'name': c.name,
            'phone': c.phone,
            'email': c.email,
            'address': c.address,
            'balance': c.balance,
            'creditLimit': c.creditLimit,
            'isActive': c.isActive,
          },
      ],
    });
  });

  router.post(LanApiPaths.customers, (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final name = '${body['name'] ?? ''}'.trim();
      if (name.isEmpty) return _err('Name required', status: 400);
      final now = DateTime.now();
      late int id;
      await isar.writeTxn(() async {
        id = await isar.customers.put(
          Customer()
            ..name = name
            ..phone = '${body['phone'] ?? ''}'.trim()
            ..email = (body['email'] as String?)?.trim()
            ..address = (body['address'] as String?)?.trim()
            ..notes = (body['notes'] as String?)?.trim()
            ..balance = 0
            ..creditLimit = (body['creditLimit'] as num?)?.toDouble() ?? 0
            ..isActive = true
            ..createdAt = now,
        );
      });
      return _ok({'id': id, 'name': name});
    } catch (e) {
      return _err(e.toString(), status: 400);
    }
  });

  router.post('${LanApiPaths.customerPayment}<id|[0-9]+>/payments', (
    Request request,
    String id,
  ) async {
    try {
      final customerId = int.tryParse(id);
      if (customerId == null) return _err('Invalid id', status: 400);
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final amount = (body['amount'] as num?)?.toDouble() ?? 0;
      final note = body['note'] as String?;
      final result = await ops.recordCustomerPayment(
        customerId: customerId,
        amount: amount,
        note: note,
      );
      return _ok(result);
    } on LanApiException catch (e) {
      return _err(e.message, status: e.statusCode ?? 400, code: e.code);
    } catch (e) {
      return _err(e.toString(), status: 400);
    }
  });

  router.get('${LanApiPaths.customerById}<id|[0-9]+>/ledger', (
    Request request,
    String id,
  ) async {
    final customerId = int.tryParse(id);
    if (customerId == null) return _err('Invalid id', status: 400);
    final rows = await isar.customerLedgerEntrys
        .filter()
        .customerIdEqualTo(customerId)
        .sortByEntryDateDesc()
        .findAll();
    return _ok({
      'items': [
        for (final row in rows)
          {
            'id': row.id,
            'type': row.type,
            'amount': row.amount,
            'balanceAfter': row.balanceAfter,
            'entryDate': row.entryDate.toIso8601String(),
            'reference': row.reference,
            'note': row.note,
          },
      ],
    });
  });

  router.get('${LanApiPaths.customerById}<id|[0-9]+>/sales', (
    Request request,
    String id,
  ) async {
    final customerId = int.tryParse(id);
    if (customerId == null) return _err('Invalid id', status: 400);
    final customer = await isar.customers.get(customerId);
    if (customer == null) return _err('Not found', status: 404);
    final nameKey = customer.name.trim().toLowerCase();
    final sales = await isar.sales.where().sortBySoldAtDesc().findAll();
    final matched = sales.where((s) {
      if (s.customerId == customerId) return true;
      return s.customerName.trim().toLowerCase() == nameKey;
    });
    return _ok({
      'items': [
        for (final sale in matched)
          {
            'invoiceNo': sale.invoiceNo,
            'total': sale.total,
            'soldAt': sale.soldAt.toIso8601String(),
            'paymentMethod': sale.paymentMethod,
          },
      ],
    });
  });

  router.get(LanApiPaths.paymentAccounts, (Request request) async {
    final accounts =
        await isar.accounts.filter().isActiveEqualTo(true).findAll();
    accounts.sort((a, b) {
      if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    return _ok({
      'items': [
        for (final a in accounts)
          {
            'id': a.id,
            'name': a.name,
            'type': a.type,
            'balance': a.balance,
            'isDefault': a.isDefault,
            'isActive': a.isActive,
          },
      ],
    });
  });

  router.get(LanApiPaths.nextInvoicePreview, (Request request) async {
    final preview = await saleWrite.previewNextInvoiceNo();
    return _ok({'invoiceNo': preview});
  });

  router.get(LanApiPaths.sales, (Request request) async {
    final q = (request.url.queryParameters['q'] ?? '').trim().toLowerCase();
    final limit =
        int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 100;
    final sales = await isar.sales.where().sortBySoldAtDesc().findAll();
    final filtered = q.isEmpty
        ? sales
        : sales.where((s) {
            return s.invoiceNo.toLowerCase().contains(q) ||
                s.customerName.toLowerCase().contains(q);
          });
    final items = filtered.take(limit).map(_saleSummaryJson).toList();
    return _ok({'items': items});
  });

  router.get('${LanApiPaths.saleById}<id|[0-9]+>', (
    Request request,
    String id,
  ) async {
    final saleId = int.tryParse(id);
    if (saleId == null) return _err('Invalid id', status: 400);
    final sale = await isar.sales.get(saleId);
    if (sale == null) return _err('Not found', status: 404);
    return _ok(_saleDetailJson(sale));
  });

  router.post(LanApiPaths.sales, (Request request) async {
    try {
      final body = LanCreateSaleDto.fromJson(
        jsonDecode(await request.readAsString()) as Map<String, dynamic>,
      );
      final result = await saleWrite.createSale(body);
      return _ok(result);
    } on LanApiException catch (e) {
      return _err(e.message, status: e.statusCode ?? 400, code: e.code);
    } catch (e) {
      return _err(e.toString(), status: 400);
    }
  });

  router.post('${LanApiPaths.saleReturn}<id|[0-9]+>/returns', (
    Request request,
    String id,
  ) async {
    try {
      final saleId = int.tryParse(id);
      if (saleId == null) return _err('Invalid id', status: 400);
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await ops.processReturn(
        saleId: saleId,
        body: body,
      );
      return _ok(result);
    } on LanApiException catch (e) {
      return _err(e.message, status: e.statusCode ?? 400, code: e.code);
    } catch (e) {
      return _err(e.toString(), status: 400);
    }
  });

  router.get(LanApiPaths.heldSales, (Request request) async {
    return _ok({'items': await ops.listHeldSales()});
  });

  router.post(LanApiPaths.heldSales, (Request request) async {
    try {
      final body =
          jsonDecode(await request.readAsString()) as Map<String, dynamic>;
      final result = await ops.createHeldSale(body);
      return _ok(result);
    } on LanApiException catch (e) {
      return _err(e.message, status: e.statusCode ?? 400, code: e.code);
    } catch (e) {
      return _err(e.toString(), status: 400);
    }
  });

  router.delete('${LanApiPaths.heldSaleById}<id|[0-9]+>', (
    Request request,
    String id,
  ) async {
    final heldId = int.tryParse(id);
    if (heldId == null) return _err('Invalid id', status: 400);
    await ops.deleteHeldSale(heldId);
    return _ok({'ok': true});
  });

  router.get('${LanApiPaths.heldSaleById}<id|[0-9]+>', (
    Request request,
    String id,
  ) async {
    final heldId = int.tryParse(id);
    if (heldId == null) return _err('Invalid id', status: 400);
    final detail = await ops.getHeldSale(heldId);
    if (detail == null) return _err('Not found', status: 404);
    return _ok(detail);
  });

  router.get(LanApiPaths.dashboardSummary, (Request request) async {
    return _ok(await ops.dashboardSummary());
  });

  if (restaurant != null) {
    mountLanRestaurantRoutes(router, restaurant: restaurant);
  }
}

Future<AppSetting?> _settings(Isar isar) {
  return isar.appSettings.filter().keyEqualTo('default').findFirst();
}

Map<String, dynamic> _productJson(
  Product p,
  List<ProductVariant> variants,
  List<ProductBatch> lots,
) {
  final stock = p.hasVariants
      ? variants.fold<int>(0, (s, v) => s + v.stock)
      : p.stock;
  return {
    'id': p.id,
    'sku': p.sku,
    'barcode': p.barcode,
    'name': p.name,
    'category': p.category,
    'brand': p.brand,
    'manufacturer': p.manufacturer,
    'strength': p.strength,
    'hasVariants': p.hasVariants,
    'unit': p.unit,
    'sellType': p.sellType,
    'itemsPerBox': p.itemsPerBox,
    'sellingPrice': p.sellingPrice,
    'wholesalePrice': p.wholesalePrice,
    'purchasePrice': p.purchasePrice,
    'taxRate': p.taxRate,
    'taxInclusive': p.taxInclusive,
    'stock': stock,
    'lowStockThreshold': p.lowStockThreshold,
    'isActive': p.isActive,
    'expiryDate': p.expiryDate?.toIso8601String(),
    'imagePath': p.imagePath,
    'variants': [
      for (final v in variants)
        {
          'id': v.id,
          'productId': v.productId,
          'size': v.size,
          'color': v.color,
          'barcode': v.barcode,
          'sku': v.sku,
          'stock': v.stock,
          'priceOverride': v.priceOverride,
          'isActive': v.isActive,
        },
    ],
    'batches': [
      for (final lot in lots)
        {
          'id': lot.id,
          'batchCode': lot.batchCode,
          'quantity': lot.quantity,
          'receivedAt': lot.receivedAt.toIso8601String(),
          'manufactureDate': lot.manufactureDate?.toIso8601String(),
          'expiryDate': lot.expiryDate?.toIso8601String(),
        },
    ],
  };
}

Map<String, dynamic> _saleSummaryJson(Sale s) => {
      'id': s.id,
      'invoiceNo': s.invoiceNo,
      'customerName': s.customerName,
      'customerId': s.customerId,
      'paymentMethod': s.paymentMethod,
      'subtotal': s.subtotal,
      'discount': s.discount,
      'tax': s.tax,
      'total': s.total,
      'amountPaid': s.amountPaid,
      'changeAmount': s.changeAmount,
      'itemCount': s.itemCount,
      'cashierName': s.cashierName,
      'status': s.status,
      'soldAt': s.soldAt.toIso8601String(),
    };

Map<String, dynamic> _saleDetailJson(Sale s) => {
      ..._saleSummaryJson(s),
      'linesJson': s.linesJson,
      'notes': s.notes,
      'returnedAmount': s.returnedAmount,
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
