import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../core/auth/password_hasher.dart';
import '../core/auth/permissions.dart';
import '../modules/labels/domain/entities/label_entities.dart';
import '../modules/settings/domain/entities/settings_entities.dart';
import '../services/labels/barcode_validator.dart';
import 'product_batch_store.dart';
import 'collections/label_template.dart';
import 'collections/app_setting.dart';
import 'collections/app_notification.dart';
import 'collections/dashboard_metric.dart';
import 'collections/low_stock_item.dart';
import 'collections/product.dart';
import 'collections/product_batch.dart';
import 'collections/account.dart';
import 'collections/auth_session.dart';
import 'collections/customer.dart';
import 'collections/customer_ledger_entry.dart';
import 'collections/held_sale.dart';
import 'collections/label_print_job.dart';
import 'collections/ledger_entry.dart';
import 'collections/employee.dart';
import 'collections/employee_attendance.dart';
import 'collections/finance_expense.dart';
import 'collections/employee_advance.dart';
import 'collections/employee_commission.dart';
import 'collections/purchase.dart';
import 'collections/recent_sale.dart';
import 'collections/sale.dart';
import 'collections/sales_point.dart';
import 'collections/stock_movement.dart';
import 'collections/store.dart';
import 'collections/supplier.dart';
import 'collections/top_product.dart';
import 'collections/user_account.dart';

/// Seeds Lahore-flavored demo data when the database is empty.
abstract final class SeedData {
  static const _demoRevision = 'demo-v10-catalog-lots';
  static const _emptyDatabaseRevision = 'empty-v1';

  /// Wipes business data for owner "clear data". User accounts are kept; no demo re-seed.
  static Future<void> resetCustomerDatabase(Isar isar) async {
    await _wipeBusinessData(isar);
    await _ensureDefaultStore(isar);
    await _ensureSettingsSeeded(isar);
    await _ensureLabelTemplatesSeeded(isar);
    await _putEmptyDatabaseFlag(isar);
  }

  static Future<void> _wipeBusinessData(Isar isar) async {
    await isar.writeTxn(() async {
      await isar.dashboardMetrics.clear();
      await isar.salesPoints.clear();
      await isar.topProducts.clear();
      await isar.recentSales.clear();
      await isar.lowStockItems.clear();
      await isar.appNotifications.clear();
      await isar.products.clear();
      await isar.productBatchs.clear();
      await isar.heldSales.clear();
      await isar.stockMovements.clear();
      await isar.suppliers.clear();
      await isar.purchases.clear();
      await isar.sales.clear();
      await isar.customers.clear();
      await isar.customerLedgerEntrys.clear();
      await isar.accounts.clear();
      await isar.ledgerEntrys.clear();
      await isar.employees.clear();
      await isar.employeeAttendances.clear();
      await isar.financeExpenses.clear();
      await isar.employeeAdvances.clear();
      await isar.employeeCommissions.clear();
      await isar.labelPrintJobs.clear();
      await isar.authSessions.clear();
      await isar.stores.clear();
      await isar.appSettings.clear();
      await isar.labelTemplates.clear();
    });
  }

  static Future<void> ensureSeeded(Isar isar) async {
    await _ensureAuthSeeded(isar);
    await _patchSingleStore(isar);
    await _patchUserPermissions(isar);
    await _ensureSettingsSeeded(isar);
    await _ensureLabelTemplatesSeeded(isar);
    await _ensureDemoRevision(isar);
  }

  static Future<void> _ensureDemoRevision(Isar isar) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null) {
      throw StateError('Database settings could not be initialized.');
    }

    // One-time migration from the old notification-based marker. That marker
    // was user-clearable and could previously cause a destructive reseed.
    final legacyFlag = await isar.appNotifications
        .filter()
        .typeEqualTo('seed')
        .findFirst();
    if (settings.seedRevision.isEmpty && legacyFlag != null) {
      settings.seedRevision = legacyFlag.title;
      await isar.writeTxn(() async => isar.appSettings.put(settings));
    }

    if (settings.seedRevision == _emptyDatabaseRevision) {
      await _removeLegacySeedFlags(isar);
      return;
    }

    if (settings.seedRevision.isNotEmpty) {
      await _patchProductBarcodes(isar);
      await ProductBatchStore.migrateAllLegacyStock(isar);
      await _setSeedRevision(isar, _demoRevision);
      await _removeLegacySeedFlags(isar);
      return;
    }

    // A missing marker is never permission to erase data. Existing business
    // rows are preserved and only safe migrations are applied.
    final hasBusinessData =
        await isar.products.count() > 0 ||
        await isar.purchases.count() > 0 ||
        await isar.sales.count() > 0 ||
        await isar.customers.count() > 0 ||
        await isar.suppliers.count() > 0 ||
        await isar.accounts.count() > 0;
    if (hasBusinessData) {
      await _patchProductBarcodes(isar);
      await ProductBatchStore.migrateAllLegacyStock(isar);
      await _setSeedRevision(isar, _demoRevision);
      await _removeLegacySeedFlags(isar);
      return;
    }

    await _seedDemoBusiness(isar);
  }

  static Future<void> _seedDemoBusiness(Isar isar) async {
    await _ensureProductsSeeded(isar);
    await _patchProductBarcodes(isar);
    await ProductBatchStore.migrateAllLegacyStock(isar);
    await _ensurePurchasesSeeded(isar);
    await _ensureSalesSeeded(isar);
    await _ensureHeldSalesSeeded(isar);
    await _ensureCustomersSeeded(isar);
    await _ensureAccountsSeeded(isar);
    await _ensureEmployeesSeeded(isar);
    await _ensureAttendanceSeeded(isar);
    await _ensureFinanceDemoSeeded(isar);
    await _putDemoRevisionFlag(isar);
  }

  static Future<void> _putDemoRevisionFlag(Isar isar) async {
    await _setSeedRevision(isar, _demoRevision);
    await _removeLegacySeedFlags(isar);
  }

  static Future<void> _putEmptyDatabaseFlag(Isar isar) async {
    await _setSeedRevision(isar, _emptyDatabaseRevision);
    await _removeLegacySeedFlags(isar);
  }

  static Future<void> _setSeedRevision(Isar isar, String revision) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null) return;
    await isar.writeTxn(() async {
      settings.seedRevision = revision;
      await isar.appSettings.put(settings);
    });
  }

  static Future<void> _removeLegacySeedFlags(Isar isar) async {
    final flags = await isar.appNotifications
        .filter()
        .typeEqualTo('seed')
        .findAll();
    if (flags.isEmpty) return;
    await isar.writeTxn(() async {
      for (final flag in flags) {
        await isar.appNotifications.delete(flag.id);
      }
    });
  }

  static Future<void> _ensureAuthSeeded(Isar isar) async {
    final userCount = await isar.userAccounts.count();
    if (userCount > 0) return;

    await isar.writeTxn(() async {
      await isar.stores.putAll([
        Store()
          ..code = 'MAIN'
          ..name = 'My Store'
          ..city = ''
          ..address = ''
          ..isActive = true,
      ]);

      const adminSalt = 'salt_admin_01';
      const cashierSalt = 'salt_cashier_01';
      const managerSalt = 'salt_manager_01';

      await isar.userAccounts.putAll([
        UserAccount()
          ..username = 'admin'
          ..displayName = 'Ali Owner'
          ..role = AppRoles.owner
          ..permissions = AppRoles.permissionsFor(AppRoles.owner)
          ..passwordSalt = adminSalt
          ..passwordHash = PasswordHasher.hash('admin123', adminSalt)
          ..isActive = true
          ..createdAt = DateTime.now(),
        UserAccount()
          ..username = 'manager'
          ..displayName = 'Sara Manager'
          ..role = AppRoles.manager
          ..permissions = AppRoles.permissionsFor(AppRoles.manager)
          ..passwordSalt = managerSalt
          ..passwordHash = PasswordHasher.hash('manager123', managerSalt)
          ..isActive = true
          ..createdAt = DateTime.now(),
        UserAccount()
          ..username = 'cashier'
          ..displayName = 'Hassan Cashier'
          ..role = AppRoles.cashier
          ..permissions = AppRoles.permissionsFor(AppRoles.cashier)
          ..passwordSalt = cashierSalt
          ..passwordHash = PasswordHasher.hash('cashier123', cashierSalt)
          ..isActive = true
          ..createdAt = DateTime.now(),
      ]);
    });
  }

  static Future<void> _ensureDefaultStore(Isar isar) async {
    final count = await isar.stores.count();
    if (count > 0) return;

    await isar.writeTxn(() async {
      await isar.stores.put(
        Store()
          ..code = 'MAIN'
          ..name = 'My Store'
          ..city = ''
          ..address = ''
          ..isActive = true,
      );
    });
  }

  /// Keeps one active store for single-store mode; deactivates extra demo branches.
  static Future<void> _patchSingleStore(Isar isar) async {
    var activeStores = await isar.stores
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    activeStores.sort((a, b) => a.id.compareTo(b.id));

    if (activeStores.isEmpty) {
      await isar.writeTxn(() async {
        await isar.stores.put(
          Store()
            ..code = 'MAIN'
            ..name = 'My Store'
            ..city = ''
            ..address = ''
            ..isActive = true,
        );
      });
      return;
    }

    if (activeStores.length == 1) return;

    final primary = activeStores.first;
    final deactivatedIds = <int>{};
    var changed = false;

    for (var i = 1; i < activeStores.length; i++) {
      final store = activeStores[i];
      store.isActive = false;
      deactivatedIds.add(store.id);
      changed = true;
    }

    final sessions = await isar.authSessions.where().findAll();
    for (final session in sessions) {
      if (session.storeId != null && deactivatedIds.contains(session.storeId)) {
        session.storeId = primary.id;
        changed = true;
      }
    }

    if (!changed) return;
    await isar.writeTxn(() async {
      await isar.stores.putAll(activeStores);
      if (sessions.isNotEmpty) {
        await isar.authSessions.putAll(sessions);
      }
    });
  }

  /// Fills empty permission lists from role defaults (does not override customs).
  static Future<void> _patchUserPermissions(Isar isar) async {
    final users = await isar.userAccounts.where().findAll();
    if (users.isEmpty) return;

    final toUpdate = <UserAccount>[];
    for (final user in users) {
      if (user.permissions.isNotEmpty) continue;
      user.permissions = AppRoles.permissionsFor(user.role);
      toUpdate.add(user);
    }

    if (toUpdate.isEmpty) return;
    await isar.writeTxn(() async {
      await isar.userAccounts.putAll(toUpdate);
    });
  }

  static DateTime _dayOffset(int days) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).add(Duration(days: days));
  }

  static String _ean(String twelveDigits) {
    return BarcodeValidator.encode(twelveDigits, LabelSymbology.ean13);
  }

  static Future<void> _ensureProductsSeeded(Isar isar) async {
    final count = await isar.products.count();
    if (count > 0) return;

    Product catalog({
      required String sku,
      required String barcode,
      required String name,
      required String category,
      String? brand,
      String? manufacturer,
      String unit = 'pcs',
      double tax = 17,
      int lowStock = 0,
    }) {
      return Product()
        ..sku = sku
        ..barcode = barcode
        ..name = name
        ..category = category
        ..brand = brand
        ..manufacturer = manufacturer
        ..unit = unit
        ..sellingPrice = 0
        ..wholesalePrice = 0
        ..purchasePrice = 0
        ..taxRate = tax
        ..taxInclusive = true
        ..stock = 0
        ..lowStockThreshold = lowStock
        ..isActive = true
        ..imagePath = null;
    }

    Future<Product> priced(
      Product product, {
      required double selling,
      required double purchase,
      double wholesale = 0,
    }) async {
      product
        ..sellingPrice = selling
        ..purchasePrice = purchase
        ..wholesalePrice = wholesale;
      await isar.products.put(product);
      return product;
    }

    Future<void> receiveLot(
      Product product, {
      required int qty,
      required double cost,
      DateTime? expiry,
      DateTime? manufacture,
      String? batch,
      String note = 'Opening lot',
    }) async {
      await ProductBatchStore.receive(
        isar: isar,
        product: product,
        quantity: qty,
        expiryDate: expiry,
        manufactureDate: manufacture,
        batchCode: batch,
        unitCost: cost,
        note: note,
      );
    }

    await isar.writeTxn(() async {
      await isar.products.putAll([
        catalog(
          sku: 'TPL-950',
          barcode: _ean('896400012345'),
          name: 'Tapal Danedar 950g',
          category: 'Grocery',
          brand: 'Tapal',
          manufacturer: 'Tapal Tea (Pvt) Ltd',
        ),
        catalog(
          sku: 'OLP-1L',
          barcode: _ean('896400012346'),
          name: "Olper's Milk 1L",
          category: 'Dairy',
          brand: "Olper's",
          manufacturer: 'Engro Foods',
          unit: 'L',
        ),
        catalog(
          sku: 'SHN-BRY',
          barcode: _ean('896400012347'),
          name: 'Shan Biryani Masala',
          category: 'Spices',
          brand: 'Shan',
        ),
        catalog(
          sku: 'LUX-BAR',
          barcode: _ean('896400012348'),
          name: 'Lux Soap Bar',
          category: 'Personal Care',
          brand: 'Lux',
        ),
        catalog(
          sku: 'NST-400',
          barcode: _ean('896400012349'),
          name: 'Nestle Everyday 400g',
          category: 'Dairy',
          brand: 'Nestle',
          manufacturer: 'Nestle Pakistan',
        ),
        catalog(
          sku: 'SFX-1KG',
          barcode: _ean('896400012350'),
          name: 'Surf Excel 1kg',
          category: 'Household',
          brand: 'Surf Excel',
          unit: 'kg',
          lowStock: 20,
        ),
        catalog(
          sku: 'DLD-5L',
          barcode: _ean('896400012351'),
          name: 'Dalda Cooking Oil 5L',
          category: 'Grocery',
          brand: 'Dalda',
          unit: 'L',
          lowStock: 15,
        ),
        catalog(
          sku: 'CC-15L',
          barcode: _ean('896400012352'),
          name: 'Coca-Cola 1.5L',
          category: 'Beverages',
          brand: 'Coca-Cola',
          unit: 'L',
          lowStock: 40,
        ),
        catalog(
          sku: 'LFB-HW',
          barcode: _ean('896400012353'),
          name: 'Lifebuoy Handwash',
          category: 'Personal Care',
          brand: 'Lifebuoy',
          lowStock: 25,
        ),
        catalog(
          sku: 'NIDO-400',
          barcode: _ean('896400012354'),
          name: 'Nido Fortified 400g',
          category: 'Dairy',
          brand: 'Nido',
          manufacturer: 'Nestle Pakistan',
        ),
        catalog(
          sku: 'LAYS-R',
          barcode: _ean('896400012355'),
          name: 'Lays Classic Regular',
          category: 'Snacks',
          brand: 'Lays',
        ),
        catalog(
          sku: 'COLG-100',
          barcode: _ean('896400012356'),
          name: 'Colgate MaxFresh 100g',
          category: 'Personal Care',
          brand: 'Colgate',
        ),
        catalog(
          sku: 'PFR-SV',
          barcode: _ean('896400012357'),
          name: 'Peek Freans Rio Strawberry',
          category: 'Snacks',
          brand: 'Peek Freans',
          manufacturer: 'English Biscuit Manufacturers',
        ),
        catalog(
          sku: 'YGT-500',
          barcode: _ean('896400012358'),
          name: 'Nestle Yogurt 500g',
          category: 'Dairy',
          brand: 'Nestle',
          unit: 'g',
        ),
        catalog(
          sku: 'BRD-W',
          barcode: _ean('896400012359'),
          name: 'Dawn Bread White',
          category: 'Bakery',
          brand: 'Dawn',
        ),
        catalog(
          sku: 'NAT-KCH',
          barcode: _ean('896400012360'),
          name: 'National Tomato Ketchup',
          category: 'Grocery',
          brand: 'National',
        ),
      ]);

      final bySku = {
        for (final product in await isar.products.where().findAll())
          product.sku: product,
      };

      Future<void> stock(
        String sku, {
        required double selling,
        required double purchase,
        double wholesale = 0,
        required List<({int qty, int expiryDays, String? batch})> lots,
        int? manufactureDays,
      }) async {
        final product = bySku[sku];
        if (product == null) return;
        await priced(
          product,
          selling: selling,
          purchase: purchase,
          wholesale: wholesale,
        );
        for (final lot in lots) {
          await receiveLot(
            product,
            qty: lot.qty,
            cost: purchase,
            expiry: lot.expiryDays == 9999 ? null : _dayOffset(lot.expiryDays),
            manufacture: manufactureDays == null
                ? null
                : _dayOffset(manufactureDays),
            batch: lot.batch,
          );
        }
      }

      await stock(
        'TPL-950',
        selling: 620,
        purchase: 480,
        wholesale: 540,
        manufactureDays: -40,
        lots: [
          (qty: 50, expiryDays: 180, batch: 'TPL-A'),
          (qty: 36, expiryDays: 240, batch: 'TPL-B'),
        ],
      );
      await stock(
        'OLP-1L',
        selling: 300,
        purchase: 240,
        wholesale: 270,
        manufactureDays: -12,
        lots: [
          (qty: 24, expiryDays: 8, batch: 'OLP-SOON'),
          (qty: 96, expiryDays: 45, batch: 'OLP-OK'),
        ],
      );
      await stock(
        'SHN-BRY',
        selling: 300,
        purchase: 210,
        wholesale: 250,
        lots: [(qty: 64, expiryDays: 9999, batch: null)],
      );
      await stock(
        'LUX-BAR',
        selling: 200,
        purchase: 140,
        wholesale: 165,
        manufactureDays: -400,
        lots: [
          (qty: 18, expiryDays: -12, batch: 'LUX-EXP'),
          (qty: 77, expiryDays: 200, batch: 'LUX-OK'),
        ],
      );
      await stock(
        'NST-400',
        selling: 600,
        purchase: 470,
        wholesale: 520,
        manufactureDays: -20,
        lots: [(qty: 48, expiryDays: 6, batch: 'NST-JUN')],
      );
      await stock(
        'SFX-1KG',
        selling: 780,
        purchase: 620,
        wholesale: 690,
        lots: [(qty: 4, expiryDays: 90, batch: 'SFX-LOW')],
      );
      await stock(
        'DLD-5L',
        selling: 2450,
        purchase: 2100,
        wholesale: 2250,
        lots: [(qty: 2, expiryDays: 120, batch: 'DLD-LOW')],
      );
      await stock(
        'CC-15L',
        selling: 220,
        purchase: 160,
        wholesale: 185,
        manufactureDays: -30,
        lots: [
          (qty: 9, expiryDays: 18, batch: 'CC-SOON'),
          (qty: 40, expiryDays: 90, batch: 'CC-OK'),
        ],
      );
      await stock(
        'LFB-HW',
        selling: 350,
        purchase: 260,
        wholesale: 300,
        lots: [(qty: 7, expiryDays: 150, batch: 'LFB-LOW')],
      );
      await stock(
        'NIDO-400',
        selling: 1250,
        purchase: 980,
        wholesale: 1100,
        manufactureDays: -10,
        lots: [(qty: 35, expiryDays: 300, batch: 'NIDO-A')],
      );
      await stock(
        'LAYS-R',
        selling: 60,
        purchase: 42,
        wholesale: 50,
        lots: [(qty: 200, expiryDays: 60, batch: 'LAYS-1')],
      );
      await stock(
        'COLG-100',
        selling: 280,
        purchase: 190,
        wholesale: 230,
        lots: [(qty: 55, expiryDays: 400, batch: 'COLG-A')],
      );
      await stock(
        'PFR-SV',
        selling: 55,
        purchase: 40,
        wholesale: 48,
        manufactureDays: -15,
        lots: [(qty: 60, expiryDays: 90, batch: 'RIO-BOX')],
      );
      await stock(
        'YGT-500',
        selling: 180,
        purchase: 130,
        wholesale: 150,
        manufactureDays: -25,
        lots: [(qty: 14, expiryDays: -3, batch: 'YGT-EXP')],
      );
      await stock(
        'BRD-W',
        selling: 160,
        purchase: 110,
        wholesale: 130,
        manufactureDays: -1,
        lots: [(qty: 16, expiryDays: 1, batch: 'BRD-TODAY')],
      );

      final now = DateTime.now();
      await isar.appNotifications.putAll([
        AppNotification()
          ..title = 'Expired stock'
          ..body = 'Nestle Yogurt 500g and Lux Soap (old lot) are past expiry.'
          ..type = 'warning'
          ..createdAt = now.subtract(const Duration(minutes: 12))
          ..isRead = false,
        AppNotification()
          ..title = 'Expiring soon'
          ..body =
              'Olper\'s Milk, Nestle Everyday, and Dawn Bread expire within 30 days.'
          ..type = 'warning'
          ..createdAt = now.subtract(const Duration(minutes: 20))
          ..isRead = false,
        AppNotification()
          ..title = 'Low stock'
          ..body =
              'Surf Excel, Dalda 5L, and Lifebuoy are below their alert levels.'
          ..type = 'warning'
          ..createdAt = now.subtract(const Duration(minutes: 25))
          ..isRead = false,
        AppNotification()
          ..title = 'Catalog item needs a purchase'
          ..body =
              'National Tomato Ketchup has no stock or prices yet — receive it in Purchases.'
          ..type = 'info'
          ..createdAt = now.subtract(const Duration(hours: 1))
          ..isRead = false,
      ]);
    });
  }

  /// Fixes demo EAN-13 check digits for databases seeded before barcode correction.
  static Future<void> _patchProductBarcodes(Isar isar) async {
    final products = await isar.products.where().findAll();
    if (products.isEmpty) return;

    var changed = false;
    for (final product in products) {
      final raw = product.barcode.trim();
      if (raw.isEmpty) continue;
      final encoded = BarcodeValidator.encode(raw, LabelSymbology.ean13);
      if (encoded != raw) {
        product.barcode = encoded;
        changed = true;
      }
    }

    if (!changed) return;
    await isar.writeTxn(() async {
      await isar.products.putAll(products);
    });
  }

  static Future<void> _ensurePurchasesSeeded(Isar isar) async {
    final supplierCount = await isar.suppliers.count();
    if (supplierCount > 0) return;

    final products = await isar.products.where().findAll();
    final bySku = {for (final product in products) product.sku: product};
    final now = DateTime.now();

    Map<String, dynamic> line(
      String sku, {
      required int qty,
      required double cost,
      int? boxes,
      int pcsPerBox = 1,
      DateTime? expiry,
      DateTime? manufacture,
      String? batch,
    }) {
      final product = bySku[sku]!;
      final packageQty = boxes ?? qty;
      final units = boxes == null ? 1 : pcsPerBox;
      return {
        'productId': product.id,
        'productName': product.name,
        'productSku': product.sku,
        'quantity': qty,
        'unitCost': cost,
        'sellingPrice': product.sellingPrice,
        'wholesalePrice': product.wholesalePrice,
        if (expiry != null) 'expiryDate': expiry.toIso8601String(),
        if (manufacture != null)
          'manufactureDate': manufacture.toIso8601String(),
        'batchCode': ?batch,
        'packageQuantity': packageQty,
        'packageUnit': boxes == null ? (product.unit ?? 'Item') : 'Box',
        'unitsPerPackage': units,
        'packageUnitCost': cost * units,
      };
    }

    await isar.writeTxn(() async {
      final metroId = await isar.suppliers.put(
        Supplier()
          ..name = 'Metro Cash & Carry Lahore'
          ..phone = '042-111-622-622'
          ..email = 'lahore@metro.pk'
          ..address = 'Model Town Link Road, Lahore'
          ..isActive = true
          ..createdAt = now,
      );
      final nestleId = await isar.suppliers.put(
        Supplier()
          ..name = 'Nestle Distributor Punjab'
          ..phone = '0300-4455667'
          ..address = 'Industrial Area, Lahore'
          ..isActive = true
          ..createdAt = now,
      );
      final ittefaqId = await isar.suppliers.put(
        Supplier()
          ..name = 'Ittefaq Wholesale Grocery'
          ..phone = '0321-9988776'
          ..address = 'Anarkali Bazaar, Lahore'
          ..notes = 'Net 7 days credit'
          ..isActive = true
          ..createdAt = now,
      );

      final metroLines = [
        line(
          'TPL-950',
          qty: 50,
          cost: 480,
          expiry: _dayOffset(180),
          batch: 'TPL-A',
        ),
        line('SHN-BRY', qty: 64, cost: 210),
        line(
          'DLD-5L',
          qty: 2,
          cost: 2100,
          expiry: _dayOffset(120),
          batch: 'DLD-LOW',
        ),
      ];
      final metroTotal = 50 * 480 + 64 * 210 + 2 * 2100.0;
      await isar.purchases.put(
        Purchase()
          ..supplierId = metroId
          ..supplierName = 'Metro Cash & Carry Lahore'
          ..invoiceNo = 'PUR-SEED-001'
          ..purchaseDate = now.subtract(const Duration(days: 3))
          ..linesJson = jsonEncode(metroLines)
          ..subtotal = metroTotal
          ..taxAmount = 0
          ..total = metroTotal
          ..paidAmount = 15000
          ..dueAmount = metroTotal - 15000
          ..status = 'open'
          ..notes = 'Weekly grocery restock · pay remaining due'
          ..createdAt = now.subtract(const Duration(days: 3)),
      );

      final nestleLines = [
        line(
          'NST-400',
          qty: 48,
          cost: 470,
          expiry: _dayOffset(6),
          manufacture: _dayOffset(-20),
          batch: 'NST-JUN',
        ),
        line(
          'OLP-1L',
          qty: 120,
          cost: 240,
          expiry: _dayOffset(8),
          manufacture: _dayOffset(-12),
          batch: 'OLP-SOON',
        ),
        line(
          'YGT-500',
          qty: 14,
          cost: 130,
          expiry: _dayOffset(-3),
          batch: 'YGT-EXP',
        ),
      ];
      final nestleTotal = 48 * 470 + 120 * 240 + 14 * 130.0;
      await isar.purchases.put(
        Purchase()
          ..supplierId = nestleId
          ..supplierName = 'Nestle Distributor Punjab'
          ..invoiceNo = 'PUR-SEED-002'
          ..purchaseDate = now.subtract(const Duration(days: 1))
          ..linesJson = jsonEncode(nestleLines)
          ..subtotal = nestleTotal
          ..taxAmount = 0
          ..total = nestleTotal
          ..paidAmount = nestleTotal
          ..dueAmount = 0
          ..status = 'paid'
          ..notes = 'Dairy lots with mixed expiry'
          ..createdAt = now.subtract(const Duration(days: 1)),
      );

      final ittefaqLines = [
        line(
          'PFR-SV',
          qty: 60,
          cost: 40,
          boxes: 10,
          pcsPerBox: 6,
          expiry: _dayOffset(90),
          batch: 'RIO-BOX',
        ),
        line(
          'LAYS-R',
          qty: 200,
          cost: 42,
          expiry: _dayOffset(60),
          batch: 'LAYS-1',
        ),
        line(
          'BRD-W',
          qty: 16,
          cost: 110,
          expiry: _dayOffset(1),
          batch: 'BRD-TODAY',
        ),
      ];
      final ittefaqTotal = 60 * 40 + 200 * 42 + 16 * 110.0;
      await isar.purchases.put(
        Purchase()
          ..supplierId = ittefaqId
          ..supplierName = 'Ittefaq Wholesale Grocery'
          ..invoiceNo = 'PUR-SEED-003'
          ..purchaseDate = now.subtract(const Duration(days: 2))
          ..linesJson = jsonEncode(ittefaqLines)
          ..subtotal = ittefaqTotal
          ..taxAmount = 0
          ..total = ittefaqTotal
          ..paidAmount = 5000
          ..dueAmount = ittefaqTotal - 5000
          ..status = 'open'
          ..notes = '10 boxes of Rio (6 pcs) · test Pay due'
          ..createdAt = now.subtract(const Duration(days: 2)),
      );
    });
  }

  static Future<void> _ensureSalesSeeded(Isar isar) async {
    final count = await isar.sales.count();
    if (count > 0) return;

    final products = await isar.products.where().findAll();
    if (products.isEmpty) return;
    final bySku = {for (final product in products) product.sku: product};
    final now = DateTime.now();

    Map<String, dynamic> saleLine(String sku, int qty) {
      final product = bySku[sku]!;
      final unitPrice = product.sellingPrice;
      return {
        'productId': product.id,
        'productName': product.name,
        'productSku': product.sku,
        'quantity': qty,
        'unitPrice': unitPrice,
        'lineDiscount': 0,
        'lineTotal': unitPrice * qty,
      };
    }

    Sale seedSale({
      required String invoiceNo,
      required String customerName,
      required String paymentMethod,
      required DateTime soldAt,
      required List<Map<String, dynamic>> lines,
      double paidAmount = 0,
      double changeAmount = 0,
    }) {
      final subtotal = lines.fold<double>(
        0,
        (sum, line) => sum + (line['lineTotal'] as num).toDouble(),
      );
      final tax = subtotal * 0.17 / 1.17;
      final total = subtotal;
      final itemCount = lines.fold<int>(
        0,
        (sum, line) => sum + (line['quantity'] as int),
      );
      final paid = paidAmount > 0 ? paidAmount : total;

      return Sale()
        ..invoiceNo = invoiceNo
        ..customerName = customerName
        ..paymentMethod = paymentMethod
        ..subtotal = subtotal - tax
        ..discount = 0
        ..tax = tax
        ..total = total
        ..amountPaid = paid
        ..changeAmount = changeAmount
        ..itemCount = itemCount
        ..linesJson = jsonEncode(lines)
        ..soldAt = soldAt;
    }

    final sales = <Sale>[
      seedSale(
        invoiceNo: 'INV-10482',
        customerName: 'Walk-in',
        paymentMethod: 'Cash',
        soldAt: now.subtract(const Duration(minutes: 8)),
        paidAmount: 800,
        changeAmount: 100,
        lines: [saleLine('LUX-BAR', 2), saleLine('LAYS-R', 5)],
      ),
      seedSale(
        invoiceNo: 'INV-10481',
        customerName: 'Ayesha Khan',
        paymentMethod: 'Card',
        soldAt: now.subtract(const Duration(minutes: 22)),
        lines: [saleLine('TPL-950', 2), saleLine('OLP-1L', 4)],
      ),
      seedSale(
        invoiceNo: 'INV-10480',
        customerName: 'Hamza Traders',
        paymentMethod: 'Khata',
        soldAt: now.subtract(const Duration(minutes: 41)),
        paidAmount: 2000,
        lines: [saleLine('NST-400', 4), saleLine('SHN-BRY', 6)],
      ),
      seedSale(
        invoiceNo: 'INV-10479',
        customerName: 'Walk-in',
        paymentMethod: 'Cash',
        soldAt: now.subtract(const Duration(hours: 1, minutes: 5)),
        lines: [saleLine('PFR-SV', 6), saleLine('LAYS-R', 3)],
      ),
      seedSale(
        invoiceNo: 'INV-10478',
        customerName: 'Bilal Ahmed',
        paymentMethod: 'Card',
        soldAt: now.subtract(const Duration(hours: 1, minutes: 38)),
        lines: [saleLine('COLG-100', 3), saleLine('LFB-HW', 1)],
      ),
      seedSale(
        invoiceNo: 'INV-10477',
        customerName: 'Sana Malik',
        paymentMethod: 'Cash',
        soldAt: now.subtract(const Duration(hours: 2, minutes: 10)),
        lines: [saleLine('OLP-1L', 2), saleLine('BRD-W', 2)],
      ),
    ];

    for (var i = 1; i <= 13; i++) {
      final day = now.subtract(Duration(days: i, hours: 4));
      sales.add(
        seedSale(
          invoiceNo: 'INV-${10476 - i}',
          customerName: i.isEven ? 'Walk-in' : 'Hamza Traders',
          paymentMethod: i % 3 == 0 ? 'Card' : 'Cash',
          soldAt: day,
          lines: [
            saleLine('TPL-950', 1 + (i % 3)),
            saleLine('CC-15L', 2 + (i % 2)),
            if (i.isOdd) saleLine('LAYS-R', 4),
          ],
        ),
      );
    }

    await isar.writeTxn(() async {
      await isar.sales.putAll(sales);
    });
  }

  static Future<void> _ensureHeldSalesSeeded(Isar isar) async {
    final count = await isar.heldSales.count();
    if (count > 0) return;

    final products = await isar.products.where().findAll();
    if (products.isEmpty) return;
    final bySku = {for (final product in products) product.sku: product};
    final milk = bySku['OLP-1L'];
    final bread = bySku['BRD-W'];
    if (milk == null || bread == null) return;

    await isar.writeTxn(() async {
      await isar.heldSales.put(
        HeldSale()
          ..holdCode = 'H-10001'
          ..customerName = 'Ayesha Khan'
          ..notes = 'Waiting for more items'
          ..itemsJson = jsonEncode([
            {
              'productId': milk.id,
              'quantity': 2,
              'lineDiscount': 0,
              'unitPrice': milk.sellingPrice,
              'lineTotal': milk.sellingPrice * 2,
            },
            {
              'productId': bread.id,
              'quantity': 1,
              'lineDiscount': 0,
              'unitPrice': bread.sellingPrice,
              'lineTotal': bread.sellingPrice,
            },
          ])
          ..discountAmount = 0
          ..discountIsPercent = true
          ..heldAt = DateTime.now().subtract(const Duration(minutes: 18)),
      );
    });
  }

  static Future<void> _ensureCustomersSeeded(Isar isar) async {
    final count = await isar.customers.count();
    if (count > 0) return;

    final now = DateTime.now();

    await isar.writeTxn(() async {
      await isar.customers.putAll([
        Customer()
          ..name = 'Ayesha Khan'
          ..phone = '0301-5551234'
          ..email = 'ayesha.khan@email.com'
          ..address = 'Gulberg III, Lahore'
          ..balance = 0
          ..creditLimit = 25000
          ..isActive = true
          ..createdAt = now,
        Customer()
          ..name = 'Hamza Traders'
          ..phone = '0321-7778899'
          ..address = 'Multan Road, Lahore'
          ..notes = 'Wholesale buyer'
          ..balance = 8500
          ..creditLimit = 50000
          ..isActive = true
          ..createdAt = now,
        Customer()
          ..name = 'Bilal Ahmed'
          ..phone = '0333-4567890'
          ..balance = 3200
          ..creditLimit = 15000
          ..isActive = true
          ..createdAt = now,
        Customer()
          ..name = 'Sana Malik'
          ..phone = '0345-9988776'
          ..balance = 0
          ..creditLimit = 10000
          ..isActive = true
          ..createdAt = now,
        Customer()
          ..name = 'Faisal Bookshop'
          ..phone = '042-37112233'
          ..address = 'Liberty Market, Lahore'
          ..balance = 12000
          ..creditLimit = 40000
          ..isActive = true
          ..createdAt = now,
      ]);
    });
  }

  static Future<void> _ensureAccountsSeeded(Isar isar) async {
    final count = await isar.accounts.count();
    if (count > 0) return;

    final now = DateTime.now();

    await isar.writeTxn(() async {
      final cashId = await isar.accounts.put(
        Account()
          ..name = 'Cash Drawer'
          ..type = 'cash'
          ..balance = 125000
          ..isDefault = true
          ..isActive = true
          ..notes = 'Main counter cash'
          ..createdAt = now,
      );
      final bankId = await isar.accounts.put(
        Account()
          ..name = 'HBL Business Account'
          ..type = 'bank'
          ..balance = 450000
          ..isDefault = false
          ..isActive = true
          ..createdAt = now,
      );
      final mobileId = await isar.accounts.put(
        Account()
          ..name = 'JazzCash Merchant'
          ..type = 'mobile'
          ..balance = 38500
          ..isDefault = false
          ..isActive = true
          ..createdAt = now,
      );

      await isar.ledgerEntrys.putAll([
        LedgerEntry()
          ..accountId = cashId
          ..accountName = 'Cash Drawer'
          ..type = 'income'
          ..category = 'Sales deposit'
          ..amount = 45000
          ..reference = 'Daily closing'
          ..entryDate = now.subtract(const Duration(days: 1))
          ..createdAt = now.subtract(const Duration(days: 1)),
        LedgerEntry()
          ..accountId = bankId
          ..accountName = 'HBL Business Account'
          ..type = 'expense'
          ..category = 'Owner Withdrawal'
          ..amount = 25000
          ..note = 'Owner drawing'
          ..movementKind = 'ownerWithdrawal'
          ..entryDate = now.subtract(const Duration(days: 1))
          ..createdAt = now.subtract(const Duration(days: 1)),
        LedgerEntry()
          ..accountId = cashId
          ..accountName = 'Cash Drawer'
          ..type = 'income'
          ..category = 'Cash In'
          ..amount = 15000
          ..note = 'Opening float top-up'
          ..movementKind = 'cashIn'
          ..entryDate = now.subtract(const Duration(days: 2))
          ..createdAt = now.subtract(const Duration(days: 2)),
        LedgerEntry()
          ..accountId = cashId
          ..accountName = 'Cash Drawer'
          ..type = 'expense'
          ..category = 'Cash Out'
          ..amount = 3200
          ..note = 'Petty cash'
          ..movementKind = 'cashOut'
          ..entryDate = now.subtract(const Duration(days: 2))
          ..createdAt = now.subtract(const Duration(days: 2)),
        LedgerEntry()
          ..accountId = bankId
          ..accountName = 'HBL Business Account'
          ..type = 'expense'
          ..category = 'Rent'
          ..amount = 85000
          ..note = 'August shop rent'
          ..entryDate = now.subtract(const Duration(days: 2))
          ..createdAt = now.subtract(const Duration(days: 2)),
        LedgerEntry()
          ..accountId = cashId
          ..accountName = 'Cash Drawer'
          ..type = 'expense'
          ..category = 'Electricity'
          ..amount = 12500
          ..note = 'LESCO bill'
          ..entryDate = now.subtract(const Duration(days: 3))
          ..createdAt = now.subtract(const Duration(days: 3)),
        LedgerEntry()
          ..accountId = bankId
          ..accountName = 'HBL Business Account'
          ..type = 'expense'
          ..category = 'Salary'
          ..amount = 45000
          ..reference = 'Aug salaries'
          ..note = 'Cashier salary'
          ..movementKind = 'salary'
          ..employeeName = 'Ayesha Raza'
          ..entryDate = now.subtract(const Duration(days: 4))
          ..createdAt = now.subtract(const Duration(days: 4)),
        LedgerEntry()
          ..accountId = cashId
          ..accountName = 'Cash Drawer'
          ..type = 'expense'
          ..category = 'Internet / Phone'
          ..amount = 4500
          ..note = 'Shop internet'
          ..entryDate = now.subtract(const Duration(days: 5))
          ..createdAt = now.subtract(const Duration(days: 5)),
        LedgerEntry()
          ..accountId = cashId
          ..accountName = 'Cash Drawer'
          ..type = 'expense'
          ..category = 'Fuel / Transport'
          ..amount = 6800
          ..note = 'Delivery fuel'
          ..entryDate = now.subtract(const Duration(days: 6))
          ..createdAt = now.subtract(const Duration(days: 6)),
        LedgerEntry()
          ..accountId = mobileId
          ..accountName = 'JazzCash Merchant'
          ..type = 'income'
          ..category = 'Customer payment'
          ..amount = 8500
          ..reference = 'Hamza Traders'
          ..entryDate = now.subtract(const Duration(hours: 6))
          ..createdAt = now.subtract(const Duration(hours: 6)),
      ]);
    });
  }

  static Future<void> _ensureEmployeesSeeded(Isar isar) async {
    final count = await isar.employees.count();
    if (count > 0) return;

    final now = DateTime.now();
    await isar.writeTxn(() async {
      await isar.employees.putAll([
        Employee()
          ..name = 'Ayesha Raza'
          ..phone = '03001234567'
          ..designation = 'Cashier'
          ..monthlySalary = 45000
          ..isActive = true
          ..joinedAt = now.subtract(const Duration(days: 220))
          ..createdAt = now.subtract(const Duration(days: 220)),
        Employee()
          ..name = 'Bilal Hussain'
          ..phone = '03219876543'
          ..designation = 'Store Helper'
          ..monthlySalary = 35000
          ..isActive = true
          ..joinedAt = now.subtract(const Duration(days: 140))
          ..createdAt = now.subtract(const Duration(days: 140)),
        Employee()
          ..name = 'Sana Malik'
          ..phone = '03331221122'
          ..designation = 'Inventory Clerk'
          ..monthlySalary = 40000
          ..isActive = true
          ..joinedAt = now.subtract(const Duration(days: 90))
          ..notes = 'Evening shift'
          ..createdAt = now.subtract(const Duration(days: 90)),
      ]);
    });
  }

  static Future<void> _ensureAttendanceSeeded(Isar isar) async {
    final count = await isar.employeeAttendances.count();
    if (count > 0) return;

    final employees = await isar.employees.where().sortByName().findAll();
    if (employees.isEmpty) return;

    Employee? named(String name) {
      for (final employee in employees) {
        if (employee.name == name) return employee;
      }
      return null;
    }

    final ayesha = named('Ayesha Raza') ?? employees.first;
    final bilal =
        named('Bilal Hussain') ??
        (employees.length > 1 ? employees[1] : employees.first);
    final sana = named('Sana Malik') ?? employees.last;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day, 9, 5);

    await isar.writeTxn(() async {
      await isar.employeeAttendances.putAll([
        EmployeeAttendance()
          ..employeeId = ayesha.id
          ..employeeName = ayesha.name
          ..clockInAt = todayStart
          ..note = 'Morning shift'
          ..createdAt = todayStart,
        EmployeeAttendance()
          ..employeeId = bilal.id
          ..employeeName = bilal.name
          ..clockInAt = todayStart.subtract(const Duration(days: 1))
          ..clockOutAt = todayStart
              .subtract(const Duration(days: 1))
              .add(const Duration(hours: 8, minutes: 20))
          ..note = 'Full day'
          ..createdAt = todayStart.subtract(const Duration(days: 1)),
        EmployeeAttendance()
          ..employeeId = sana.id
          ..employeeName = sana.name
          ..clockInAt = DateTime(now.year, now.month, now.day, 14, 0)
          ..clockOutAt = DateTime(now.year, now.month, now.day, 18, 10)
          ..note = 'Evening shift'
          ..createdAt = DateTime(now.year, now.month, now.day, 14, 0),
      ]);
    });
  }

  static Future<void> _ensureFinanceDemoSeeded(Isar isar) async {
    final expenseCount = await isar.financeExpenses.count();
    if (expenseCount > 0) return;

    final accounts = await isar.accounts.where().findAll();
    if (accounts.isEmpty) return;

    final cash = accounts.firstWhere(
      (a) => a.type == 'cash',
      orElse: () => accounts.first,
    );
    final bank = accounts.firstWhere(
      (a) => a.type == 'bank',
      orElse: () => accounts.first,
    );
    final employees = await isar.employees.where().findAll();
    final now = DateTime.now();

    await isar.writeTxn(() async {
      Future<int> addExpenseLedger({
        required Account account,
        required String category,
        required double amount,
        required DateTime entryDate,
        String? note,
        String? paidBy,
        String movementKind = 'expense',
      }) async {
        return isar.ledgerEntrys.put(
          LedgerEntry()
            ..accountId = account.id
            ..accountName = account.name
            ..type = 'expense'
            ..category = category
            ..amount = amount
            ..note = note
            ..reference = paidBy
            ..movementKind = movementKind
            ..entryDate = entryDate
            ..createdAt = now,
        );
      }

      final rentLedgerId = await addExpenseLedger(
        account: bank,
        category: 'Shop rent',
        amount: 85000,
        entryDate: now.subtract(const Duration(days: 2)),
        note: 'August shop rent',
        paidBy: 'Owner',
      );
      await isar.financeExpenses.put(
        FinanceExpense()
          ..category = 'Shop rent'
          ..amount = 85000
          ..accountId = bank.id
          ..accountName = bank.name
          ..entryDate = now.subtract(const Duration(days: 2))
          ..description = 'August shop rent'
          ..paidBy = 'Owner'
          ..ledgerEntryId = rentLedgerId
          ..createdAt = now,
      );

      final elecLedgerId = await addExpenseLedger(
        account: cash,
        category: 'Electricity',
        amount: 12500,
        entryDate: now.subtract(const Duration(days: 3)),
        note: 'LESCO bill',
        paidBy: 'Bilal Hussain',
      );
      await isar.financeExpenses.put(
        FinanceExpense()
          ..category = 'Electricity'
          ..amount = 12500
          ..accountId = cash.id
          ..accountName = cash.name
          ..entryDate = now.subtract(const Duration(days: 3))
          ..description = 'LESCO bill'
          ..paidBy = 'Bilal Hussain'
          ..ledgerEntryId = elecLedgerId
          ..createdAt = now,
      );

      final netLedgerId = await addExpenseLedger(
        account: cash,
        category: 'Internet',
        amount: 4500,
        entryDate: now.subtract(const Duration(days: 5)),
        note: 'Shop internet',
      );
      await isar.financeExpenses.put(
        FinanceExpense()
          ..category = 'Internet'
          ..amount = 4500
          ..accountId = cash.id
          ..accountName = cash.name
          ..entryDate = now.subtract(const Duration(days: 5))
          ..description = 'Shop internet'
          ..ledgerEntryId = netLedgerId
          ..createdAt = now,
      );

      final transportLedgerId = await addExpenseLedger(
        account: cash,
        category: 'Transport',
        amount: 6800,
        entryDate: now.subtract(const Duration(days: 6)),
        note: 'Delivery fuel',
      );
      await isar.financeExpenses.put(
        FinanceExpense()
          ..category = 'Transport'
          ..amount = 6800
          ..accountId = cash.id
          ..accountName = cash.name
          ..entryDate = now.subtract(const Duration(days: 6))
          ..description = 'Delivery fuel'
          ..ledgerEntryId = transportLedgerId
          ..createdAt = now,
      );

      if (employees.isNotEmpty) {
        final employee = employees.first;
        final advanceLedgerId = await addExpenseLedger(
          account: cash,
          category: 'Employee Advance',
          amount: 5000,
          entryDate: now.subtract(const Duration(days: 7)),
          note: 'Mid-month advance',
          movementKind: 'advance',
        );
        final advance = EmployeeAdvance()
          ..employeeId = employee.id
          ..employeeName = employee.name
          ..amount = 5000
          ..accountId = cash.id
          ..accountName = cash.name
          ..entryDate = now.subtract(const Duration(days: 7))
          ..note = 'Mid-month advance'
          ..ledgerEntryId = advanceLedgerId
          ..createdAt = now;
        await isar.employeeAdvances.put(advance);

        final commissionLedgerId = await addExpenseLedger(
          account: bank,
          category: 'Employee Commission',
          amount: 3500,
          entryDate: now.subtract(const Duration(days: 8)),
          note: 'July sales commission',
          movementKind: 'commission',
        );
        await isar.employeeCommissions.put(
          EmployeeCommission()
            ..employeeId = employee.id
            ..employeeName = employee.name
            ..amount = 3500
            ..accountId = bank.id
            ..accountName = bank.name
            ..entryDate = now.subtract(const Duration(days: 8))
            ..reference = 'July 2026 sales'
            ..note = 'Sales commission'
            ..ledgerEntryId = commissionLedgerId
            ..createdAt = now,
        );
      }
    });
  }

  static Future<void> _ensureSettingsSeeded(Isar isar) async {
    final count = await isar.appSettings.count();
    if (count > 0) return;

    await isar.writeTxn(() async {
      await isar.appSettings.put(
        AppSetting()
          ..key = 'default'
          ..businessName = 'My Store'
          ..businessPhone = ''
          ..businessEmail = ''
          ..businessAddress = ''
          ..taxNumber = '1234567-8'
          ..defaultTaxRate = 17
          ..defaultTaxInclusive = true
          ..taxEnabled = true
          ..receiptFooter = 'Thank you for shopping with us!'
          ..showBusinessInfoOnReceipt = true
          ..receiptTitle = 'Sale Receipt'
          ..receiptLogoPath = null
          ..receiptTerms = DefaultReceiptTerms.text
          ..receiptCounterName = 'Counter 1'
          ..receiptSystemName = 'POS-01'
          ..fbrInvoiceEnabled = false
          ..printerName = 'Default thermal printer'
          ..autoPrintReceipt = false
          ..paperWidthMm = 80
          ..receiptContentWidthMm = 72
          ..receiptPrintAlign = 'center'
          ..productUnitsCsv = ''
          ..productCategoriesCsv = ''
          ..themeMode = 'light'
          ..accentPreset = 'ocean'
          ..primaryPreset = 'slate'
          ..storeProfile = ''
          ..storeProfileConfigured = false,
      );
    });
  }

  static Future<void> _ensureLabelTemplatesSeeded(Isar isar) async {
    final count = await isar.labelTemplates.count();
    if (count > 0) return;

    final now = DateTime.now();

    LabelTemplate build({
      required String key,
      required String name,
      required String storeType,
      required String description,
      required double widthMm,
      required double heightMm,
      required String symbology,
      required String payloadFormat,
      required bool showProductName,
      required bool showSku,
      required bool showPrice,
      required bool showBrand,
      required bool showUnit,
      required bool showCategory,
      required bool showExpirySlot,
      required bool showBatchSlot,
      required int defaultCopies,
      required bool isDefault,
    }) {
      return LabelTemplate()
        ..key = key
        ..name = name
        ..storeType = storeType
        ..description = description
        ..widthMm = widthMm
        ..heightMm = heightMm
        ..symbology = symbology
        ..payloadFormat = payloadFormat
        ..showProductName = showProductName
        ..showSku = showSku
        ..showPrice = showPrice
        ..showBrand = showBrand
        ..showUnit = showUnit
        ..showCategory = showCategory
        ..showExpirySlot = showExpirySlot
        ..showBatchSlot = showBatchSlot
        ..defaultCopies = defaultCopies
        ..isDefault = isDefault
        ..isBuiltIn = true
        ..updatedAt = now;
    }

    await isar.writeTxn(() async {
      await isar.labelTemplates.putAll([
        build(
          key: 'retail_default',
          name: 'Retail shelf label',
          storeType: 'retail',
          description: 'Standard price labels for general retail shops.',
          widthMm: 50,
          heightMm: 30,
          symbology: 'code128',
          payloadFormat: 'zpl',
          showProductName: true,
          showSku: true,
          showPrice: true,
          showBrand: false,
          showUnit: false,
          showCategory: false,
          showExpirySlot: false,
          showBatchSlot: false,
          defaultCopies: 1,
          isDefault: true,
        ),
        build(
          key: 'grocery_default',
          name: 'Grocery unit label',
          storeType: 'grocery',
          description: 'Weight/unit labels for grocery and superstores.',
          widthMm: 58,
          heightMm: 40,
          symbology: 'ean13',
          payloadFormat: 'escpos',
          showProductName: true,
          showSku: false,
          showPrice: true,
          showBrand: false,
          showUnit: true,
          showCategory: true,
          showExpirySlot: false,
          showBatchSlot: false,
          defaultCopies: 1,
          isDefault: false,
        ),
        build(
          key: 'pharmacy_default',
          name: 'Pharmacy compliance label',
          storeType: 'pharmacy',
          description: 'Batch and expiry slots for pharmacies.',
          widthMm: 58,
          heightMm: 40,
          symbology: 'code128',
          payloadFormat: 'zpl',
          showProductName: true,
          showSku: true,
          showPrice: true,
          showBrand: false,
          showUnit: false,
          showCategory: false,
          showExpirySlot: true,
          showBatchSlot: true,
          defaultCopies: 1,
          isDefault: false,
        ),
        build(
          key: 'clothing_default',
          name: 'Clothing size label',
          storeType: 'clothing',
          description: 'Size and SKU labels for apparel stores.',
          widthMm: 50,
          heightMm: 30,
          symbology: 'code128',
          payloadFormat: 'pdf',
          showProductName: true,
          showSku: true,
          showPrice: true,
          showBrand: true,
          showUnit: true,
          showCategory: false,
          showExpirySlot: false,
          showBatchSlot: false,
          defaultCopies: 1,
          isDefault: false,
        ),
        build(
          key: 'electronics_default',
          name: 'Electronics SKU label',
          storeType: 'electronics',
          description: 'Compact SKU + barcode labels for electronics.',
          widthMm: 40,
          heightMm: 30,
          symbology: 'code128',
          payloadFormat: 'zpl',
          showProductName: true,
          showSku: true,
          showPrice: true,
          showBrand: true,
          showUnit: false,
          showCategory: false,
          showExpirySlot: false,
          showBatchSlot: false,
          defaultCopies: 1,
          isDefault: false,
        ),
        build(
          key: 'warehouse_default',
          name: 'Warehouse bin label',
          storeType: 'warehouse',
          description: 'Large bin labels for warehouse and stock rooms.',
          widthMm: 100,
          heightMm: 50,
          symbology: 'code128',
          payloadFormat: 'zpl',
          showProductName: true,
          showSku: true,
          showPrice: false,
          showBrand: false,
          showUnit: true,
          showCategory: true,
          showExpirySlot: false,
          showBatchSlot: false,
          defaultCopies: 2,
          isDefault: false,
        ),
      ]);
    });
  }
}
