import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/account.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/customer_ledger_entry.dart';
import '../../../../database/collections/cash_shift.dart';
import '../../../../database/collections/held_sale.dart';
import '../../../../database/collections/ledger_entry.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/product_variant.dart';
import '../../../../database/collections/recent_sale.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/collections/stock_movement.dart';
import '../../../../core/auth/retail_actor.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/client/lan_api_client.dart';
import '../../../../core/lan_api/client/lan_connection_monitor.dart';
import '../../../../core/lan_api/dtos/lan_dtos.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/product_batch_store.dart';
import '../../../accounts/domain/entities/account_entities.dart';
import '../../../sales/domain/entities/sale_entities.dart';
import '../../domain/entities/pos_entities.dart';

class PosLocalDataSource {
  PosLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<List<PosProduct>> getProducts() async {
    if (sl<LanModeService>().isClient) {
      return _getProductsFromHost();
    }
    final isar = _isarService.instance;
    final products = await isar.products
        .filter()
        .isActiveEqualTo(true)
        .deletedAtIsNull()
        .sortByName()
        .findAll();
    final allVariants = await isar.productVariants
        .filter()
        .deletedAtIsNull()
        .findAll();
    final variantsByProduct = <int, List<ProductVariant>>{};
    for (final v in allVariants.where((v) => v.isActive)) {
      variantsByProduct.putIfAbsent(v.productId, () => []).add(v);
    }
    final taxEnabled = await _isTaxEnabled();
    final mapped = <PosProduct>[];
    for (final product in products) {
      final lots = await ProductBatchStore.batchesForProduct(isar, product.id);
      final nearest = lots
          .where((lot) => lot.expiryDate != null)
          .map((lot) => lot.expiryDate)
          .firstOrNull;
      final variants = variantsByProduct[product.id] ?? const [];
      final stock = product.hasVariants
          ? variants.fold<int>(0, (sum, v) => sum + v.stock)
          : product.stock;
      mapped.add(
        _mapProduct(
          product,
          taxEnabled: taxEnabled,
          expiryOverride: nearest ?? product.expiryDate,
          stockOverride: stock,
          batches: lots
              .map(
                (lot) => PosBatchLot(
                  id: lot.id,
                  batchCode: lot.batchCode,
                  quantity: lot.quantity,
                  receivedAt: lot.receivedAt,
                  manufactureDate: lot.manufactureDate,
                  expiryDate: lot.expiryDate,
                ),
              )
              .toList(),
          variants: variants
              .map(
                (v) => PosVariantOption(
                  id: v.id,
                  size: v.size,
                  color: v.color,
                  stock: v.stock,
                  barcode: v.barcode,
                  sku: v.sku,
                  priceOverride: v.priceOverride,
                ),
              )
              .toList(),
        ),
      );
    }
    return mapped;
  }

  Future<List<PosProduct>> _getProductsFromHost() async {
    final online = await sl<LanConnectionMonitor>().refresh();
    if (!online) {
      throw StateError('Shop host offline — check Host PC and Wi‑Fi.');
    }
    final items = await sl<LanApiClient>().fetchProducts();
    final taxEnabled = await _isTaxEnabled();
    return [
      for (final raw in items) _mapHostProduct(raw, taxEnabled: taxEnabled),
    ];
  }

  PosProduct _mapHostProduct(
    Map<String, dynamic> raw, {
    required bool taxEnabled,
  }) {
    final variantsRaw = raw['variants'];
    final batchesRaw = raw['batches'];
    final variants = <PosVariantOption>[];
    if (variantsRaw is List) {
      for (final v in variantsRaw) {
        if (v is! Map) continue;
        final m = Map<String, dynamic>.from(v);
        variants.add(
          PosVariantOption(
            id: (m['id'] as num?)?.toInt() ?? 0,
            size: '${m['size'] ?? ''}',
            color: '${m['color'] ?? ''}',
            stock: (m['stock'] as num?)?.toInt() ?? 0,
            barcode: m['barcode'] as String?,
            sku: m['sku'] as String?,
            priceOverride: (m['priceOverride'] as num?)?.toDouble() ?? 0,
          ),
        );
      }
    }
    final batches = <PosBatchLot>[];
    if (batchesRaw is List) {
      for (final b in batchesRaw) {
        if (b is! Map) continue;
        final m = Map<String, dynamic>.from(b);
        batches.add(
          PosBatchLot(
            id: (m['id'] as num?)?.toInt() ?? 0,
            batchCode: m['batchCode'] as String?,
            quantity: (m['quantity'] as num?)?.toInt() ?? 0,
            receivedAt: DateTime.tryParse('${m['receivedAt']}') ?? DateTime.now(),
            manufactureDate: DateTime.tryParse('${m['manufactureDate'] ?? ''}'),
            expiryDate: DateTime.tryParse('${m['expiryDate'] ?? ''}'),
          ),
        );
      }
    }
    final nearest = batches
        .where((lot) => lot.expiryDate != null)
        .map((lot) => lot.expiryDate)
        .fold<DateTime?>(null, (best, d) {
          if (d == null) return best;
          if (best == null || d.isBefore(best)) return d;
          return best;
        });
    return PosProduct(
      id: (raw['id'] as num?)?.toInt() ?? 0,
      sku: '${raw['sku'] ?? ''}',
      barcode: '${raw['barcode'] ?? ''}',
      name: '${raw['name'] ?? ''}',
      category: '${raw['category'] ?? ''}',
      brand: raw['brand'] as String?,
      manufacturer: raw['manufacturer'] as String?,
      unit: raw['unit'] as String?,
      sellType: '${raw['sellType'] ?? 'piece'}',
      itemsPerBox: (raw['itemsPerBox'] as num?)?.toInt() ?? 0,
      sellingPrice: (raw['sellingPrice'] as num?)?.toDouble() ?? 0,
      wholesalePrice: (raw['wholesalePrice'] as num?)?.toDouble() ?? 0,
      purchasePrice: (raw['purchasePrice'] as num?)?.toDouble() ?? 0,
      taxRate: taxEnabled ? ((raw['taxRate'] as num?)?.toDouble() ?? 0) : 0,
      taxInclusive: taxEnabled ? raw['taxInclusive'] == true : false,
      stock: (raw['stock'] as num?)?.toInt() ?? 0,
      lowStockThreshold: (raw['lowStockThreshold'] as num?)?.toInt() ?? 0,
      expiryDate: nearest ?? DateTime.tryParse('${raw['expiryDate'] ?? ''}'),
      imagePath: raw['imagePath'] as String?,
      batches: batches,
      hasVariants: raw['hasVariants'] == true,
      variants: variants,
    );
  }

  Future<List<String>> getCategories() async {
    final products = await getProducts();
    final categories = products.map((e) => e.category).toSet().toList()..sort();
    return categories;
  }

  Future<List<AccountItem>> getPaymentAccounts() async {
    if (sl<LanModeService>().isClient) {
      final items = await sl<LanApiClient>().fetchPaymentAccounts();
      return [
        for (final raw in items)
          AccountItem(
            id: (raw['id'] as num?)?.toInt() ?? 0,
            name: '${raw['name'] ?? ''}',
            type: '${raw['type'] ?? 'cash'}',
            balance: (raw['balance'] as num?)?.toDouble() ?? 0,
            isDefault: raw['isDefault'] == true,
            isActive: raw['isActive'] != false,
            notes: raw['notes'] as String?,
          ),
      ];
    }
    final accounts = await _isarService.instance.accounts
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    accounts.sort((a, b) {
      if (a.isDefault != b.isDefault) return a.isDefault ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    return accounts
        .map(
          (account) => AccountItem(
            id: account.id,
            name: account.name,
            type: account.type,
            balance: account.balance,
            isDefault: account.isDefault,
            isActive: account.isActive,
            notes: account.notes,
          ),
        )
        .toList();
  }

  Future<List<PosCustomer>> getCustomers() async {
    if (sl<LanModeService>().isClient) {
      final items = await sl<LanApiClient>().fetchCustomers();
      return [
        for (final raw in items)
          PosCustomer(
            id: (raw['id'] as num?)?.toInt() ?? 0,
            name: '${raw['name'] ?? ''}',
            phone: '${raw['phone'] ?? ''}',
            balance: (raw['balance'] as num?)?.toDouble() ?? 0,
          ),
      ];
    }
    final customers = await _isarService.instance.customers
        .filter()
        .isActiveEqualTo(true)
        .sortByName()
        .findAll();
    return customers
        .map(
          (customer) => PosCustomer(
            id: customer.id,
            name: customer.name,
            phone: customer.phone,
            balance: customer.balance,
          ),
        )
        .toList();
  }

  Future<List<HeldSaleSummary>> getHeldSales() async {
    if (sl<LanModeService>().isClient) {
      return const [];
    }
    final products = {for (final p in await getProducts()) p.id: p};
    final held = await _isarService.instance.heldSales
        .filter()
        .deletedAtIsNull()
        .sortByHeldAtDesc()
        .findAll();
    return held.map((sale) {
      final lines = _decodeHeldLines(sale.itemsJson, products);
      final mode = sale.discountIsPercent
          ? CartDiscountMode.percent
          : CartDiscountMode.fixed;
      final totals = _computeTotals(lines, sale.discountAmount, mode);
      return HeldSaleSummary(
        id: sale.id,
        holdCode: sale.holdCode,
        customerName: sale.customerName,
        heldAt: sale.heldAt,
        itemCount: lines.length,
        total: totals.total,
      );
    }).toList();
  }

  Future<HeldSaleSummary> holdSale({
    required List<CartLine> lines,
    required double cartDiscount,
    required CartDiscountMode cartDiscountMode,
    String? customerName,
    int? customerId,
    String? notes,
  }) async {
    if (sl<LanModeService>().isClient) {
      throw StateError('Held sales are disabled on counter devices. Complete the sale on this till or cancel.');
    }
    final isar = _isarService.instance;
    final code = 'H-${DateTime.now().millisecondsSinceEpoch % 100000}';
    final payload = lines
        .map(
          (line) => {
            'productId': line.product.id,
            'quantity': line.quantity,
            'lineDiscount': line.lineDiscount,
            'lineDiscountMode': line.lineDiscountMode == LineDiscountMode.percent
                ? 'percent'
                : 'fixed',
            'lineDiscountAmount': line.discountAmount,
            'sellingPrice': line.product.sellingPrice,
            'lineTotal': line.lineTotal,
            'isVariableSale': line.isVariableSale,
            if (line.quantityLabel != null) 'quantityLabel': line.quantityLabel,
            if (line.overrideLineTotal != null)
              'overrideLineTotal': line.overrideLineTotal,
            if (line.selectedBatch != null)
              'selectedBatchId': line.selectedBatch!.id,
          },
        )
        .toList();

    late int id;
    await isar.writeTxn(() async {
      id = await isar.heldSales.put(
        HeldSale()
          ..holdCode = code
          ..customerId = customerId
          ..customerName = customerName
          ..notes = notes
          ..itemsJson = jsonEncode(payload)
          ..discountAmount = cartDiscount
          ..discountIsPercent = cartDiscountMode == CartDiscountMode.percent
          ..heldAt = DateTime.now(),
      );
    });

    final totals = _computeTotals(lines, cartDiscount, cartDiscountMode);

    return HeldSaleSummary(
      id: id,
      holdCode: code,
      customerName: customerName,
      heldAt: DateTime.now(),
      itemCount: lines.length,
      total: totals.total,
    );
  }

  List<CartLine> _decodeHeldLines(
    String itemsJson,
    Map<int, PosProduct> products,
  ) {
    final decoded = jsonDecode(itemsJson) as List<dynamic>;
    final lines = <CartLine>[];
    for (final item in decoded) {
      final map = item as Map<String, dynamic>;
      final product = products[map['productId'] as int];
      if (product == null) continue;
      final selectedBatchId = (map['selectedBatchId'] as num?)?.toInt();
      final selectedBatch = selectedBatchId == null
          ? null
          : product.batches
                .where((batch) => batch.id == selectedBatchId)
                .firstOrNull;
      if (selectedBatchId != null && selectedBatch == null) continue;
      final discountModeRaw = map['lineDiscountMode'] as String?;
      final discountMode = discountModeRaw == 'percent'
          ? LineDiscountMode.percent
          : LineDiscountMode.fixed;
      final legacyDiscount = (map['lineDiscount'] as num?)?.toDouble() ?? 0;
      lines.add(
        CartLine(
          product: product,
          quantity: (map['quantity'] as num).toInt(),
          lineDiscount: legacyDiscount,
          lineDiscountMode: discountMode,
          overrideLineTotal: (map['overrideLineTotal'] as num?)?.toDouble(),
          quantityLabel: map['quantityLabel'] as String?,
          isVariableSale: map['isVariableSale'] as bool? ?? false,
          selectedBatch: selectedBatch,
        ),
      );
    }
    return lines;
  }

  Future<
    ({
      List<CartLine> lines,
      double cartDiscount,
      CartDiscountMode cartDiscountMode,
      String? customerName,
      int? customerId,
      String? notes,
    })
  >
  resumeSale(int heldSaleId) async {
    final isar = _isarService.instance;
    final held = await isar.heldSales.get(heldSaleId);
    if (held == null || held.deletedAt != null) {
      throw StateError(
        'Held sale is in the Recycle Bin. Restore it before resuming.',
      );
    }

    final products = {for (final p in await getProducts()) p.id: p};
    final storedItems = jsonDecode(held.itemsJson) as List<dynamic>;
    final lines = _decodeHeldLines(held.itemsJson, products);
    if (lines.length != storedItems.length) {
      final missingCount = storedItems.length - lines.length;
      throw StateError(
        'Cannot resume ${held.holdCode}: $missingCount '
        '${missingCount == 1 ? 'product is' : 'products are'} unavailable. '
        'The held bill was kept safely.',
      );
    }
    if (lines.isEmpty) {
      throw StateError(
        'Cannot resume ${held.holdCode}: the held bill has no valid items. '
        'The held bill was kept safely.',
      );
    }

    await isar.writeTxn(() async {
      await isar.heldSales.delete(heldSaleId);
    });

    return (
      lines: lines,
      cartDiscount: held.discountAmount,
      cartDiscountMode: held.discountIsPercent
          ? CartDiscountMode.percent
          : CartDiscountMode.fixed,
      customerName: held.customerName,
      customerId: held.customerId,
      notes: held.notes,
    );
  }

  Future<void> deleteHeldSale(int heldSaleId) async {
    final isar = _isarService.instance;
    final held = await isar.heldSales.get(heldSaleId);
    if (held == null) return;
    await isar.writeTxn(() async {
      held.deletedAt = DateTime.now();
      await isar.heldSales.put(held);
    });
  }

  Future<void> restoreHeldSale(int heldSaleId) async {
    final isar = _isarService.instance;
    final held = await isar.heldSales.get(heldSaleId);
    if (held == null) return;
    await isar.writeTxn(() async {
      held.deletedAt = null;
      await isar.heldSales.put(held);
    });
  }

  Future<CompletedSale> completeSale({
    required List<CartLine> lines,
    required double cartDiscount,
    required CartDiscountMode cartDiscountMode,
    required PaymentMethodKind method,
    required double amountPaid,
    required double cardAmount,
    String? customerName,
    int? customerId,
    String? notes,
    int? cashAccountId,
    int? bankAccountId,
  }) async {
    final lan = sl<LanModeService>();
    if (lan.isClient) {
      return _completeSaleOnHost(
        lines: lines,
        cartDiscount: cartDiscount,
        cartDiscountMode: cartDiscountMode,
        method: method,
        amountPaid: amountPaid,
        cardAmount: cardAmount,
        customerName: customerName,
        customerId: customerId,
        notes: notes,
        cashAccountId: cashAccountId,
        bankAccountId: bankAccountId,
      );
    }

    final isar = _isarService.instance;
    final totals = _computeTotals(lines, cartDiscount, cartDiscountMode);
    final invoiceNo = 'INV-${DateTime.now().millisecondsSinceEpoch % 1000000}';
    final now = DateTime.now();
    final actor = await RetailActorStore.current(isar);

    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (actor != null && (settings?.cashierShiftRequired ?? false)) {
      final openShift = await isar.cashShifts
          .filter()
          .userIdEqualTo(actor.id)
          .statusEqualTo('open')
          .findFirst();
      if (openShift == null) {
        throw StateError('Open your cashier shift before completing a sale.');
      }
    }

    final cashAccount = cashAccountId == null
        ? null
        : await isar.accounts.get(cashAccountId);
    final bankAccount = bankAccountId == null
        ? null
        : await isar.accounts.get(bankAccountId);
    final customer = customerId == null
        ? null
        : await isar.customers.get(customerId);

    if (method == PaymentMethodKind.khata) {
      if (customer == null || !customer.isActive) {
        throw StateError('Select an active customer for Khata.');
      }
    }

    final methodLabel = switch (method) {
      PaymentMethodKind.cash =>
        cashAccount != null ? 'Cash · ${cashAccount.name}' : 'Cash',
      PaymentMethodKind.card =>
        bankAccount != null ? bankAccount.name : 'Card / Bank',
      PaymentMethodKind.split => () {
        final cashPart = cashAccount?.name ?? 'Cash';
        final bankPart = bankAccount?.name ?? 'Card';
        return 'Split · $cashPart + $bankPart';
      }(),
      PaymentMethodKind.khata =>
        amountPaid <= 0 ? 'Khata / Udhar' : 'Khata · Partial payment',
    };

    final paid = method == PaymentMethodKind.card
        ? totals.total
        : method == PaymentMethodKind.split
        ? amountPaid + cardAmount
        : method == PaymentMethodKind.khata
        ? amountPaid.clamp(0, double.infinity).toDouble()
        : amountPaid;

    final change = method == PaymentMethodKind.khata
        ? 0.0
        : (paid - totals.total).clamp(0, double.infinity).toDouble();
    final customerLabel =
        customer?.name ??
        (customerName?.trim().isNotEmpty == true
            ? customerName!.trim()
            : 'Walk-in');

    final saleLines = <SaleLineItem>[];
    final lineAllocations = List<List<BatchAllocation>>.generate(
      lines.length,
      (_) => <BatchAllocation>[],
    );

    await isar.writeTxn(() async {
      // Reserve explicitly selected batches first. Automatic lines then use
      // FEFO from the remaining stock, so a selected lot cannot be consumed
      // by an earlier automatic cart line.
      final orderedIndexes = <int>[
        for (var i = 0; i < lines.length; i++)
          if (lines[i].selectedBatch != null) i,
        for (var i = 0; i < lines.length; i++)
          if (lines[i].selectedBatch == null) i,
      ];
      for (final lineIndex in orderedIndexes) {
        final line = lines[lineIndex];
        final product = await isar.products.get(line.product.id);
        if (product == null) {
          throw StateError('Product ${line.product.sku} not found.');
        }
        if (product.deletedAt != null) {
          throw StateError(
            '${product.name} is in the Recycle Bin and cannot be sold.',
          );
        }
        final selectedBatch = line.selectedBatch;
        final allocations = selectedBatch == null
            ? await ProductBatchStore.deductFefo(
                isar: isar,
                product: product,
                quantity: line.quantity,
              )
            : await ProductBatchStore.deductFromBatch(
                isar: isar,
                product: product,
                batchId: selectedBatch.id,
                quantity: line.quantity,
              );
        lineAllocations[lineIndex] = allocations;
        final refreshed = await isar.products.get(product.id);
        final nextStock = refreshed?.stock ?? 0;
        await isar.stockMovements.put(
          StockMovement()
            ..productId = product.id
            ..productName = product.name
            ..productSku = product.sku
            ..type = 'sale'
            ..quantityChange = -line.quantity
            ..quantityAfter = nextStock
            ..createdAt = now,
        );
      }

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        saleLines.add(
          SaleLineItem(
            productId: line.product.id,
            productName: line.product.name,
            productSku: line.product.sku,
            quantity: line.quantity,
            unitPrice: line.product.sellingPrice,
            lineDiscount: line.discountAmount,
            lineTotal: line.lineTotal,
            unit: line.product.unit,
            quantityLabel: line.displayQuantityText,
            batchAllocations: lineAllocations[i]
                .map((a) => a.toJson())
                .toList(),
            itemsPerBox: line.product.itemsPerBox,
          ),
        );
      }

      final saleId = await isar.sales.put(
        Sale()
          ..invoiceNo = invoiceNo
          ..customerName = customerLabel
          ..customerId = customer?.id
          ..paymentMethod = methodLabel
          ..subtotal = totals.subtotal
          ..discount = totals.discount
          ..tax = totals.tax
          ..total = totals.total
          ..amountPaid = paid
          ..changeAmount = change
          ..itemCount = totals.itemCount
          ..linesJson = jsonEncode(
            saleLines.map((line) => line.toJson()).toList(),
          )
          ..notes = _nullIfEmpty(notes)
          ..cashierId = actor?.id
          ..cashierName = actor?.name
          ..soldAt = now,
      );

      await RetailActorStore.audit(
        isar: isar,
        action: 'sale.completed',
        entityType: 'sale',
        entityId: saleId,
        actor: actor,
        details:
            '$invoiceNo · $customerLabel · ${totals.itemCount} items · '
            'Rs ${totals.total.toStringAsFixed(2)} · $methodLabel',
        occurredAt: now,
      );

      await isar.recentSales.put(
        RecentSale()
          ..invoiceNo = invoiceNo
          ..customerName = customerLabel
          ..amount = totals.total
          ..paymentMethod = methodLabel
          ..soldAt = now,
      );

      if (method == PaymentMethodKind.cash && cashAccount != null) {
        await _depositSale(
          isar: isar,
          account: cashAccount,
          amount: totals.total,
          invoiceNo: invoiceNo,
          now: now,
          actor: actor,
        );
      } else if (method == PaymentMethodKind.card && bankAccount != null) {
        await _depositSale(
          isar: isar,
          account: bankAccount,
          amount: totals.total,
          invoiceNo: invoiceNo,
          now: now,
          actor: actor,
        );
      } else if (method == PaymentMethodKind.split) {
        if (cashAccount != null && amountPaid > 0) {
          final cashDeposit = amountPaid >= totals.total
              ? totals.total
              : amountPaid.clamp(0, totals.total).toDouble();
          if (cashDeposit > 0) {
            await _depositSale(
              isar: isar,
              account: cashAccount,
              amount: cashDeposit,
              invoiceNo: invoiceNo,
              now: now,
              actor: actor,
            );
          }
        }
        if (bankAccount != null && cardAmount > 0) {
          await _depositSale(
            isar: isar,
            account: bankAccount,
            amount: cardAmount.clamp(0, totals.total).toDouble(),
            invoiceNo: invoiceNo,
            now: now,
            actor: actor,
          );
        }
      } else if (method == PaymentMethodKind.khata && customer != null) {
        if (cashAccount != null && paid > 0) {
          await _depositSale(
            isar: isar,
            account: cashAccount,
            amount: paid,
            invoiceNo: invoiceNo,
            now: now,
            actor: actor,
          );
        }

        var runningBalance = customer.balance + totals.total;
        await isar.customerLedgerEntrys.put(
          CustomerLedgerEntry()
            ..customerId = customer.id
            ..customerName = customer.name
            ..type = 'debit'
            ..amount = totals.total
            ..balanceAfter = runningBalance
            ..reference = invoiceNo
            ..note = 'POS Khata sale'
            ..entryDate = now
            ..createdAt = now,
        );

        if (paid > 0) {
          runningBalance -= paid;
          await isar.customerLedgerEntrys.put(
            CustomerLedgerEntry()
              ..customerId = customer.id
              ..customerName = customer.name
              ..type = 'credit'
              ..amount = paid
              ..balanceAfter = runningBalance
              ..reference = invoiceNo
              ..note = runningBalance < 0
                  ? 'Payment received · excess kept as customer credit'
                  : 'Payment received with POS sale'
              ..entryDate = now
              ..createdAt = now,
          );
        }
        customer.balance = runningBalance;
        await isar.customers.put(customer);
      }
    });

    return CompletedSale(
      invoiceNo: invoiceNo,
      lines: List.unmodifiable([
        for (var i = 0; i < lines.length; i++)
          lines[i].copyWith(
            batchAllocations: lineAllocations[i]
                .map((allocation) => allocation.toJson())
                .toList(),
          ),
      ]),
      totals: totals,
      paymentMethod: methodLabel,
      amountPaid: paid,
      change: change,
      customerName: customerLabel == 'Walk-in' ? null : customerLabel,
      notes: notes,
      completedAt: now,
    );
  }

  Future<CompletedSale> _completeSaleOnHost({
    required List<CartLine> lines,
    required double cartDiscount,
    required CartDiscountMode cartDiscountMode,
    required PaymentMethodKind method,
    required double amountPaid,
    required double cardAmount,
    String? customerName,
    int? customerId,
    String? notes,
    int? cashAccountId,
    int? bankAccountId,
  }) async {
    final online = await sl<LanConnectionMonitor>().refresh();
    if (!online) {
      throw StateError('Shop host offline — check Host PC and Wi‑Fi.');
    }
    final totals = _computeTotals(lines, cartDiscount, cartDiscountMode);
    final actor = await RetailActorStore.current(_isarService.instance);
    final methodLabel = switch (method) {
      PaymentMethodKind.cash => 'Cash',
      PaymentMethodKind.card => 'Card / Bank',
      PaymentMethodKind.split => 'Split',
      PaymentMethodKind.khata => 'Khata / Udhar',
    };
    final methodKind = switch (method) {
      PaymentMethodKind.cash => 'cash',
      PaymentMethodKind.card => 'card',
      PaymentMethodKind.split => 'split',
      PaymentMethodKind.khata => 'khata',
    };
    final paid = method == PaymentMethodKind.card
        ? totals.total
        : method == PaymentMethodKind.split
            ? amountPaid + cardAmount
            : amountPaid;
    final change = (paid - totals.total).clamp(0, double.infinity).toDouble();
    final linesJson = jsonEncode([
      for (final line in lines)
        {
          'productId': line.product.id,
          'variantId': line.product.selectedVariantId,
          'name': line.product.name,
          'quantity': line.quantity,
          'unitPrice': line.unitPrice,
          'lineTotal': line.lineTotal,
        },
    ]);
    final result = await sl<LanApiClient>().createSale(
      LanCreateSaleDto(
        linesJson: linesJson,
        cashierId: actor?.id ?? 0,
        cashierName: actor?.name ?? 'Cashier',
        subtotal: totals.subtotal,
        tax: totals.tax,
        total: totals.total,
        discount: totals.discount,
        paymentMethod: methodLabel,
        amountPaid: amountPaid,
        cardAmount: cardAmount,
        changeAmount: change,
        itemCount: lines.fold<int>(0, (sum, l) => sum + l.quantity),
        customerId: customerId,
        customerName: customerName,
        notes: notes,
        cashAccountId: cashAccountId,
        bankAccountId: bankAccountId,
        methodKind: methodKind,
      ),
    );
    return CompletedSale(
      invoiceNo: '${result['invoiceNo']}',
      lines: List.unmodifiable(lines),
      totals: totals,
      paymentMethod: methodLabel,
      amountPaid: paid,
      change: change,
      customerName: customerName,
      notes: notes,
      completedAt: DateTime.tryParse('${result['soldAt']}') ?? DateTime.now(),
    );
  }

  Future<void> _depositSale({
    required Isar isar,
    required Account account,
    required double amount,
    required String invoiceNo,
    required DateTime now,
    required RetailActor? actor,
  }) async {
    if (amount <= 0) return;
    account.balance = (account.balance + amount)
        .clamp(-999999999, 999999999)
        .toDouble();
    await isar.accounts.put(account);
    await isar.ledgerEntrys.put(
      LedgerEntry()
        ..accountId = account.id
        ..accountName = account.name
        ..type = 'income'
        ..category = 'Sales deposit'
        ..amount = amount
        ..reference = invoiceNo
        ..note = 'POS sale'
        ..userId = actor?.id
        ..userName = actor?.name
        ..entryDate = now
        ..createdAt = now,
    );
  }

  CartTotals _computeTotals(
    List<CartLine> lines,
    double cartDiscount,
    CartDiscountMode mode,
  ) {
    final subtotal = lines.fold<double>(
      0,
      (sum, line) => sum + line.subtotalBeforeTax,
    );
    final tax = lines.fold<double>(0, (sum, line) => sum + line.taxAmount);
    final lineDiscounts = lines.fold<double>(
      0,
      (sum, line) => sum + line.discountAmount,
    );
    final cartDiscountValue = resolveCartDiscountAmount(
      lines,
      cartDiscount,
      mode,
    );
    final discount = lineDiscounts + cartDiscountValue;
    final total = (subtotal + tax - cartDiscountValue)
        .clamp(0, double.infinity)
        .roundToDouble();
    final itemCount =
        lines.fold<int>(0, (sum, line) => sum + line.cartCountContribution);
    return CartTotals(
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total.toDouble(),
      itemCount: itemCount,
    );
  }

  PosProduct _mapProduct(
    Product product, {
    required bool taxEnabled,
    DateTime? expiryOverride,
    int? stockOverride,
    List<PosBatchLot> batches = const [],
    List<PosVariantOption> variants = const [],
  }) {
    return PosProduct(
      id: product.id,
      sku: product.sku,
      barcode: product.barcode,
      name: product.name,
      category: product.category,
      brand: product.brand,
      manufacturer: product.manufacturer,
      unit: product.unit,
      sellType: product.sellType,
      itemsPerBox: product.itemsPerBox,
      sellingPrice: product.sellingPrice,
      wholesalePrice: product.wholesalePrice,
      purchasePrice: product.purchasePrice,
      taxRate: taxEnabled ? product.taxRate : 0,
      taxInclusive: taxEnabled ? product.taxInclusive : false,
      stock: stockOverride ?? product.stock,
      lowStockThreshold: product.lowStockThreshold,
      expiryDate: expiryOverride ?? product.expiryDate,
      imagePath: product.imagePath,
      batches: batches,
      hasVariants: product.hasVariants,
      variants: variants,
    );
  }

  Future<bool> _isTaxEnabled() async {
    final setting = await _isarService.instance.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    return setting?.taxEnabled ?? true;
  }

  String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
