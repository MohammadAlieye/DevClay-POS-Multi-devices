import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import 'collections/label_print_job.dart';
import 'collections/label_template.dart';
import 'collections/app_setting.dart';
import 'collections/account.dart';
import 'collections/audit_entry.dart';
import 'collections/app_notification.dart';
import 'collections/auth_session.dart';
import 'collections/dashboard_metric.dart';
import 'collections/dining_floor.dart';
import 'collections/dining_table.dart';
import 'collections/held_sale.dart';
import 'collections/kitchen_ticket.dart';
import 'collections/low_stock_item.dart';
import 'collections/product.dart';
import 'collections/product_batch.dart';
import 'collections/product_variant.dart';
import 'collections/recent_sale.dart';
import 'collections/restaurant_check.dart';
import 'collections/sale.dart';
import 'collections/sales_point.dart';
import 'collections/customer.dart';
import 'collections/customer_ledger_entry.dart';
import 'collections/cash_shift.dart';
import 'collections/ledger_entry.dart';
import 'collections/employee.dart';
import 'collections/employee_attendance.dart';
import 'collections/finance_expense.dart';
import 'collections/employee_advance.dart';
import 'collections/employee_commission.dart';
import 'collections/purchase.dart';
import 'collections/purchase_return.dart';
import 'collections/sale_return.dart';
import 'collections/stock_write_off.dart';
import 'collections/stock_movement.dart';
import 'collections/supplier.dart';
import 'collections/store.dart';
import 'collections/top_product.dart';
import 'collections/user_account.dart';
import 'seed_data.dart';
import 'stock_base_units_migration.dart';
import 'supplier_balance_migration.dart';

/// Opens and owns the offline Isar database instance.
class IsarService {
  IsarService();

  // Bump only when a collection schema changes. Before opening a database
  // from an older revision, a one-time safety copy is created beside it.
  static const schemaRevision = '2026-09-30-restaurant-floor-v1';

  static const List<CollectionSchema> schemas = [
    DashboardMetricSchema,
    SalesPointSchema,
    TopProductSchema,
    RecentSaleSchema,
    LowStockItemSchema,
    AppNotificationSchema,
    StoreSchema,
    UserAccountSchema,
    AuthSessionSchema,
    ProductSchema,
    ProductVariantSchema,
    ProductBatchSchema,
    HeldSaleSchema,
    StockMovementSchema,
    SupplierSchema,
    PurchaseSchema,
    SaleSchema,
    CustomerSchema,
    CustomerLedgerEntrySchema,
    AccountSchema,
    AuditEntrySchema,
    CashShiftSchema,
    SaleReturnSchema,
    PurchaseReturnSchema,
    StockWriteOffSchema,
    LedgerEntrySchema,
    EmployeeSchema,
    EmployeeAttendanceSchema,
    FinanceExpenseSchema,
    EmployeeAdvanceSchema,
    EmployeeCommissionSchema,
    AppSettingSchema,
    LabelTemplateSchema,
    LabelPrintJobSchema,
    DiningFloorSchema,
    DiningTableSchema,
    RestaurantCheckSchema,
    KitchenTicketSchema,
  ];

  Isar? _isar;

  Isar get instance {
    final db = _isar;
    if (db == null) {
      throw StateError('Isar has not been initialized. Call open() first.');
    }
    return db;
  }

  Future<Isar> open() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    await _createPreMigrationBackup(dir.path);
    _isar = await Isar.open(schemas, directory: dir.path, name: 'devclay_pos');

    await SeedData.ensureSeeded(_isar!);
    await StockBaseUnitsMigration.runIfNeeded(_isar!);
    await SupplierBalanceMigration.runIfNeeded(_isar!);
    await _writeSchemaRevision(dir.path);
    return _isar!;
  }

  Future<void> _createPreMigrationBackup(String directory) async {
    final database = File('$directory/devclay_pos.isar');
    if (!await database.exists()) return;
    final marker = File('$directory/devclay_pos.schema');
    final previous = await marker.exists()
        ? (await marker.readAsString()).trim()
        : 'legacy';
    if (previous == schemaRevision) return;
    final safePrevious = previous.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final backup = File('$directory/devclay_pos.pre-update-$safePrevious.isar');
    if (await backup.exists()) return;
    try {
      await database.copy(backup.path);
    } catch (_) {
      // A backup problem must not make the POS unusable. The database itself
      // remains untouched and Isar still performs its normal safe open.
    }
  }

  Future<void> _writeSchemaRevision(String directory) async {
    try {
      await File(
        '$directory/devclay_pos.schema',
      ).writeAsString(schemaRevision, flush: true);
    } catch (_) {
      // The database has already opened successfully; keep startup available.
    }
  }

  /// Closes the DB, replaces the file, then reopens.
  Future<Isar> restoreFromBackupFile(File backupFile) async {
    if (!await backupFile.exists()) {
      throw ArgumentError('Backup file not found.');
    }
    final length = await backupFile.length();
    if (length < 64) {
      throw ArgumentError('Selected file does not look like a valid backup.');
    }

    final dir = await getApplicationDocumentsDirectory();
    final target = File('${dir.path}/devclay_pos.isar');

    await close();

    if (await target.exists()) {
      await target.delete();
    }
    await backupFile.copy(target.path);

    return open();
  }

  Future<void> close() async {
    final db = _isar;
    if (db != null && db.isOpen) {
      await db.close();
    }
    _isar = null;
  }
}

/// Schema version constant re-export for migrations later.
const int kIsarSchemaVersion = AppConstants.isarSchemaVersion;
