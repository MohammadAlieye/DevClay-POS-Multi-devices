import 'package:isar_community/isar.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/client/lan_api_client.dart';
import '../../../../core/lan_api/client/lan_connection_monitor.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/customer_ledger_entry.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/isar_service.dart';
import '../../domain/entities/customer_entities.dart';

class CustomersLocalDataSource {
  CustomersLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<List<CustomerItem>> getCustomers({String query = ''}) async {
    if (sl<LanModeService>().isClient) {
      final items = await sl<LanApiClient>().fetchCustomers();
      final mapped = [
        for (final raw in items)
          CustomerItem(
            id: (raw['id'] as num?)?.toInt() ?? 0,
            name: '${raw['name'] ?? ''}',
            phone: '${raw['phone'] ?? ''}',
            balance: (raw['balance'] as num?)?.toDouble() ?? 0,
            creditLimit: (raw['creditLimit'] as num?)?.toDouble() ?? 0,
            isActive: raw['isActive'] != false,
            totalPurchases: 0,
            receiptCount: 0,
            email: raw['email'] as String?,
            address: raw['address'] as String?,
            notes: raw['notes'] as String?,
          ),
      ];
      final q = query.trim().toLowerCase();
      if (q.isEmpty) return mapped;
      return mapped.where((customer) {
        return customer.name.toLowerCase().contains(q) ||
            customer.phone.contains(q) ||
            (customer.email?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    final isar = _isarService.instance;
    final customers = await isar.customers.where().sortByName().findAll();
    final sales = await isar.sales.where().findAll();

    final q = query.trim().toLowerCase();
    final items = customers.map((customer) {
      return _mapCustomer(customer, sales);
    }).toList();

    if (q.isEmpty) return items;
    return items.where((customer) {
      return customer.name.toLowerCase().contains(q) ||
          customer.phone.contains(q) ||
          (customer.email?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  Future<List<CustomerSaleSummary>> getCustomerSales(
    String customerName, {
    int? customerId,
  }) async {
    if (sl<LanModeService>().isClient) {
      final id = customerId;
      if (id == null || id <= 0) {
        final all = await getCustomers(query: customerName);
        final match = all.where(
          (c) => c.name.trim().toLowerCase() == customerName.trim().toLowerCase(),
        );
        if (match.isEmpty) return const [];
        return getCustomerSales(customerName, customerId: match.first.id);
      }
      final items = await sl<LanApiClient>().fetchCustomerSales(id);
      return [
        for (final raw in items)
          CustomerSaleSummary(
            invoiceNo: '${raw['invoiceNo'] ?? ''}',
            total: (raw['total'] as num?)?.toDouble() ?? 0,
            soldAt: DateTime.tryParse('${raw['soldAt']}') ?? DateTime.now(),
            paymentMethod: '${raw['paymentMethod'] ?? ''}',
          ),
      ];
    }
    final isar = _isarService.instance;
    final key = customerName.trim().toLowerCase();
    final sales = await isar.sales.where().sortBySoldAtDesc().findAll();
    return sales
        .where((sale) => sale.customerName.trim().toLowerCase() == key)
        .map(
          (sale) => CustomerSaleSummary(
            invoiceNo: sale.invoiceNo,
            total: sale.total,
            soldAt: sale.soldAt,
            paymentMethod: sale.paymentMethod,
          ),
        )
        .toList();
  }

  Future<List<CustomerKhataEntry>> getKhataLedger(int customerId) async {
    if (sl<LanModeService>().isClient) {
      final items = await sl<LanApiClient>().fetchCustomerLedger(customerId);
      return [
        for (final raw in items)
          CustomerKhataEntry(
            id: (raw['id'] as num?)?.toInt() ?? 0,
            type: '${raw['type'] ?? ''}',
            amount: (raw['amount'] as num?)?.toDouble() ?? 0,
            balanceAfter: (raw['balanceAfter'] as num?)?.toDouble() ?? 0,
            entryDate: DateTime.tryParse('${raw['entryDate']}') ?? DateTime.now(),
            reference: raw['reference'] as String?,
            note: raw['note'] as String?,
          ),
      ];
    }
    final rows = await _isarService.instance.customerLedgerEntrys
        .filter()
        .customerIdEqualTo(customerId)
        .sortByEntryDateDesc()
        .findAll();
    return rows
        .map(
          (row) => CustomerKhataEntry(
            id: row.id,
            type: row.type,
            amount: row.amount,
            balanceAfter: row.balanceAfter,
            entryDate: row.entryDate,
            reference: row.reference,
            note: row.note,
          ),
        )
        .toList();
  }

  Future<CustomerItem> saveCustomer(CustomerDraft draft, {int? id}) async {
    final name = draft.name.trim();
    final phone = draft.phone.trim();
    if (name.isEmpty || phone.isEmpty) {
      throw ArgumentError('Customer name and phone are required.');
    }
    if (!draft.creditLimit.isFinite || draft.creditLimit < 0) {
      throw ArgumentError('Customer credit limit cannot be negative.');
    }
    final email = draft.email?.trim() ?? '';
    if (email.isNotEmpty &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      throw ArgumentError('Enter a valid customer email address.');
    }

    if (sl<LanModeService>().isClient) {
      if (id != null) {
        throw StateError('Edit customers on the shop host PC.');
      }
      final created = await sl<LanApiClient>().createCustomer({
        'name': name,
        'phone': phone,
        'email': _emptyToNull(draft.email),
        'address': _emptyToNull(draft.address),
        'notes': _emptyToNull(draft.notes),
        'creditLimit': draft.creditLimit,
      });
      return CustomerItem(
        id: (created['id'] as num?)?.toInt() ?? 0,
        name: name,
        phone: phone,
        balance: 0,
        creditLimit: draft.creditLimit,
        isActive: true,
        totalPurchases: 0,
        receiptCount: 0,
        email: _emptyToNull(draft.email),
        address: _emptyToNull(draft.address),
        notes: _emptyToNull(draft.notes),
      );
    }

    final isar = _isarService.instance;

    if (id == null) {
      late int newId;
      await isar.writeTxn(() async {
        newId = await isar.customers.put(
          Customer()
            ..name = name
            ..phone = phone
            ..email = _emptyToNull(draft.email)
            ..address = _emptyToNull(draft.address)
            ..notes = _emptyToNull(draft.notes)
            ..balance = 0
            ..creditLimit = draft.creditLimit
            ..isActive = draft.isActive
            ..createdAt = DateTime.now(),
        );
      });
      final saved = await isar.customers.get(newId);
      final sales = await isar.sales.where().findAll();
      return _mapCustomer(saved!, sales);
    }

    final existing = await isar.customers.get(id);
    if (existing == null) {
      throw StateError('Customer not found.');
    }

    await isar.writeTxn(() async {
      existing
        ..name = name
        ..phone = phone
        ..email = _emptyToNull(draft.email)
        ..address = _emptyToNull(draft.address)
        ..notes = _emptyToNull(draft.notes)
        ..creditLimit = draft.creditLimit
        ..isActive = draft.isActive;
      await isar.customers.put(existing);
    });

    final saved = await isar.customers.get(id);
    final sales = await isar.sales.where().findAll();
    return _mapCustomer(saved!, sales);
  }

  Future<CustomerItem> recordPayment({
    required int customerId,
    required double amount,
    String? note,
  }) async {
    if (sl<LanModeService>().isClient) {
      final online = await sl<LanConnectionMonitor>().refresh();
      if (!online) {
        throw StateError('Shop host offline — cannot record khata payment.');
      }
      final result = await sl<LanApiClient>().recordCustomerPayment(
        customerId: customerId,
        amount: amount,
        note: note,
      );
      final customers = await getCustomers();
      return customers.firstWhere(
        (c) => c.id == customerId,
        orElse: () => CustomerItem(
          id: customerId,
          name: '${result['name'] ?? ''}',
          phone: '',
          balance: (result['balance'] as num?)?.toDouble() ?? 0,
          creditLimit: 0,
          isActive: true,
          totalPurchases: 0,
          receiptCount: 0,
        ),
      );
    }
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be greater than zero.');
    }

    final isar = _isarService.instance;
    final customer = await isar.customers.get(customerId);
    if (customer == null) {
      throw StateError('Customer not found.');
    }
    await isar.writeTxn(() async {
      // Signed khata: positive means customer owes shop; negative means
      // the shop owes the customer (advance/overpayment).
      final nextBalance = customer.balance - amount;
      customer.balance = nextBalance;
      if (note != null && note.trim().isNotEmpty) {
        final existingNotes = customer.notes?.trim();
        customer.notes = existingNotes == null || existingNotes.isEmpty
            ? 'Payment: $note'
            : '$existingNotes\nPayment: $note';
      }
      await isar.customers.put(customer);
      await isar.customerLedgerEntrys.put(
        CustomerLedgerEntry()
          ..customerId = customer.id
          ..customerName = customer.name
          ..type = 'credit'
          ..amount = amount
          ..balanceAfter = nextBalance
          ..note = _emptyToNull(note) ?? 'Payment received'
          ..entryDate = DateTime.now()
          ..createdAt = DateTime.now(),
      );
    });

    final sales = await isar.sales.where().findAll();
    return _mapCustomer((await isar.customers.get(customerId))!, sales);
  }

  Future<CustomerItem> adjustBalance({
    required int customerId,
    required double amountChange,
    String? note,
  }) async {
    if (sl<LanModeService>().isClient) {
      throw StateError('Adjust khata on the shop host PC.');
    }
    if (amountChange == 0) {
      throw ArgumentError('Balance change cannot be zero.');
    }

    final isar = _isarService.instance;
    final customer = await isar.customers.get(customerId);
    if (customer == null) {
      throw StateError('Customer not found.');
    }

    await isar.writeTxn(() async {
      customer.balance += amountChange;
      if (note != null && note.trim().isNotEmpty) {
        final existingNotes = customer.notes?.trim();
        customer.notes = existingNotes == null || existingNotes.isEmpty
            ? note.trim()
            : '$existingNotes\n${note.trim()}';
      }
      await isar.customers.put(customer);
      await isar.customerLedgerEntrys.put(
        CustomerLedgerEntry()
          ..customerId = customer.id
          ..customerName = customer.name
          ..type = amountChange > 0 ? 'debit' : 'credit'
          ..amount = amountChange.abs()
          ..balanceAfter = customer.balance
          ..note = _emptyToNull(note) ?? 'Manual khata adjustment'
          ..entryDate = DateTime.now()
          ..createdAt = DateTime.now(),
      );
    });

    final sales = await isar.sales.where().findAll();
    return _mapCustomer((await isar.customers.get(customerId))!, sales);
  }

  CustomerItem _mapCustomer(Customer customer, List<Sale> sales) {
    final key = customer.name.trim().toLowerCase();
    final matched = sales.where(
      (sale) => sale.customerName.trim().toLowerCase() == key,
    );
    final totalPurchases = matched.fold(0.0, (sum, sale) => sum + sale.total);

    return CustomerItem(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      balance: customer.balance,
      creditLimit: customer.creditLimit,
      isActive: customer.isActive,
      totalPurchases: totalPurchases,
      receiptCount: matched.length,
      email: customer.email,
      address: customer.address,
      notes: customer.notes,
    );
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
