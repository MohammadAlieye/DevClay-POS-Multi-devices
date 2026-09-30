import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/employee.dart';
import '../../../../database/collections/held_sale.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/user_account.dart';
import '../../../../database/isar_service.dart';
import '../../../../services/media/product_image_store.dart';
import '../../domain/entities/recycle_bin_item.dart';

class RecycleBinLocalDataSource {
  RecycleBinLocalDataSource(this._isarService, this._imageStore);

  final IsarService _isarService;
  final ProductImageStore _imageStore;

  Future<List<RecycleBinItem>> listItems() async {
    final isar = _isarService.instance;
    final products = await isar.products
        .filter()
        .deletedAtIsNotNull()
        .sortByDeletedAtDesc()
        .findAll();
    final held = await isar.heldSales
        .filter()
        .deletedAtIsNotNull()
        .sortByDeletedAtDesc()
        .findAll();
    final employees = await isar.employees
        .filter()
        .deletedAtIsNotNull()
        .sortByDeletedAtDesc()
        .findAll();
    final staffUsers = await isar.userAccounts
        .filter()
        .deletedAtIsNotNull()
        .sortByDeletedAtDesc()
        .findAll();

    final items = <RecycleBinItem>[
      ...products.map(
        (p) => RecycleBinItem(
          kind: RecycleBinKind.product,
          id: p.id,
          title: p.name,
          subtitle: 'Product · ${p.sku}',
          deletedAt: p.deletedAt!,
          imagePath: p.imagePath,
        ),
      ),
      ...held.map((h) {
        final decoded = jsonDecode(h.itemsJson) as List<dynamic>;
        return RecycleBinItem(
          kind: RecycleBinKind.heldSale,
          id: h.id,
          title: h.holdCode,
          subtitle:
              'Held bill · ${decoded.length} item${decoded.length == 1 ? '' : 's'}'
              '${h.customerName?.isNotEmpty == true ? ' · ${h.customerName}' : ''}',
          deletedAt: h.deletedAt!,
        );
      }),
      ...employees.map(
        (e) => RecycleBinItem(
          kind: RecycleBinKind.employee,
          id: e.id,
          title: e.name,
          subtitle:
              'Employee'
              '${e.designation?.isNotEmpty == true ? ' · ${e.designation}' : ''}'
              ' · ${e.monthlySalary.toStringAsFixed(0)} / month',
          deletedAt: e.deletedAt!,
        ),
      ),
      ...staffUsers.map(
        (u) => RecycleBinItem(
          kind: RecycleBinKind.staffUser,
          id: u.id,
          title: u.displayName,
          subtitle: 'Staff · @${u.username} · ${u.role}',
          deletedAt: u.deletedAt!,
        ),
      ),
    ];
    items.sort((a, b) => b.deletedAt.compareTo(a.deletedAt));
    return items;
  }

  Future<int> count() async {
    final isar = _isarService.instance;
    final products = await isar.products.filter().deletedAtIsNotNull().count();
    final held = await isar.heldSales.filter().deletedAtIsNotNull().count();
    final employees =
        await isar.employees.filter().deletedAtIsNotNull().count();
    final staffUsers =
        await isar.userAccounts.filter().deletedAtIsNotNull().count();
    return products + held + employees + staffUsers;
  }

  Future<void> restore(RecycleBinKind kind, int id) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      switch (kind) {
        case RecycleBinKind.product:
          final product = await isar.products.get(id);
          if (product == null) return;
          product.deletedAt = null;
          await isar.products.put(product);
        case RecycleBinKind.heldSale:
          final held = await isar.heldSales.get(id);
          if (held == null) return;
          held.deletedAt = null;
          await isar.heldSales.put(held);
        case RecycleBinKind.employee:
          final employee = await isar.employees.get(id);
          if (employee == null) return;
          employee.deletedAt = null;
          await isar.employees.put(employee);
        case RecycleBinKind.staffUser:
          final user = await isar.userAccounts.get(id);
          if (user == null) return;
          user.deletedAt = null;
          user.isActive = true;
          await isar.userAccounts.put(user);
      }
    });
  }

  Future<void> purge(RecycleBinKind kind, int id) async {
    final isar = _isarService.instance;
    switch (kind) {
      case RecycleBinKind.product:
        final product = await isar.products.get(id);
        if (product == null) return;
        await _imageStore.deleteIfExists(product.imagePath);
        await isar.writeTxn(() async {
          await isar.products.delete(id);
        });
      case RecycleBinKind.heldSale:
        await isar.writeTxn(() async {
          await isar.heldSales.delete(id);
        });
      case RecycleBinKind.employee:
        await isar.writeTxn(() async {
          await isar.employees.delete(id);
        });
      case RecycleBinKind.staffUser:
        await isar.writeTxn(() async {
          await isar.userAccounts.delete(id);
        });
    }
  }

  Future<void> emptyBin() async {
    final items = await listItems();
    for (final item in items) {
      await purge(item.kind, item.id);
    }
  }
}
