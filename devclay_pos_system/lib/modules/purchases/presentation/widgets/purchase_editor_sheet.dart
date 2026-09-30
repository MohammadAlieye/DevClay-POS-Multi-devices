import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../utils/measure_units.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/purchase_entities.dart';

enum _ReceiveUnit { item, box }

Color _purchaseStatusColor(PurchaseProductStockStatus status) {
  return switch (status) {
    PurchaseProductStockStatus.expired => AppColors.danger,
    PurchaseProductStockStatus.outOfStock => AppColors.danger,
    PurchaseProductStockStatus.lowStock => AppColors.warning,
    PurchaseProductStockStatus.normal => AppColors.accent,
  };
}

class _PurchaseProductOptionRow extends StatelessWidget {
  const _PurchaseProductOptionRow({
    required this.product,
    this.compact = false,
    this.addedLineCount = 0,
  });

  final PurchaseProductOption product;
  final bool compact;
  final int addedLineCount;

  bool get _isAdded => addedLineCount > 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = product.stockStatus;
    final statusColor = _purchaseStatusColor(status);
    final label = product.statusLabel;

    return Row(
      children: [
        if (_isAdded) ...[
          Icon(
            Symbols.check_circle,
            size: compact ? 16 : 18,
            color: AppColors.success,
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            '${product.name} (${product.sku})',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: _isAdded ? AppColors.success : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (_isAdded)
          _PurchaseAddedChip(count: addedLineCount, compact: compact)
        else ...[
          _PurchaseStockChip(stock: product.stock, status: status),
          if (label != null && !compact) ...[
            const SizedBox(width: 6),
            _PurchaseStatusChip(label: label, color: statusColor),
          ],
        ],
      ],
    );
  }
}

class _PurchaseAddedChip extends StatelessWidget {
  const _PurchaseAddedChip({required this.count, this.compact = false});

  final int count;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = count > 1 ? 'Added ×$count' : 'Added';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 7,
        vertical: compact ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w800,
          fontSize: compact ? 10 : null,
        ),
      ),
    );
  }
}

class _PurchaseStockChip extends StatelessWidget {
  const _PurchaseStockChip({required this.stock, required this.status});

  final int stock;
  final PurchaseProductStockStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _purchaseStatusColor(status);
    final text = stock <= 0 ? 'Out' : '$stock';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PurchaseStatusChip extends StatelessWidget {
  const _PurchaseStatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _PurchaseProductStatusBanner extends StatelessWidget {
  const _PurchaseProductStatusBanner({required this.product});

  final PurchaseProductOption product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = product.stockStatus;
    final statusColor = _purchaseStatusColor(status);
    final expiry = product.expiryDate;
    final parts = <String>[
      'Current stock: ${product.stock <= 0 ? 'Out' : product.stock}',
      if (product.statusLabel != null) product.statusLabel!,
      if (expiry != null)
        product.isExpired
            ? 'Expired ${DateFormat('d MMM yyyy').format(expiry)}'
            : 'Expiry ${DateFormat('d MMM yyyy').format(expiry)}',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: AppRadii.smAll,
        border: Border.all(color: statusColor.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(
            status == PurchaseProductStockStatus.expired
                ? Symbols.event_busy
                : status == PurchaseProductStockStatus.lowStock
                ? Symbols.warning
                : status == PurchaseProductStockStatus.outOfStock
                ? Symbols.inventory_2
                : Symbols.inventory,
            size: 18,
            color: statusColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              parts.join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<PurchaseDraft?> showPurchaseEditorSheet({
  required BuildContext context,
  required List<SupplierItem> suppliers,
  required List<PurchaseProductOption> products,
  required double Function(int supplierId) supplierDue,
}) {
  return showDialog<PurchaseDraft>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _PurchaseEditorDialog(
      suppliers: suppliers,
      products: products,
      supplierDue: supplierDue,
    ),
  );
}

class _PurchaseEditorDialog extends StatefulWidget {
  const _PurchaseEditorDialog({
    required this.suppliers,
    required this.products,
    required this.supplierDue,
  });

  final List<SupplierItem> suppliers;
  final List<PurchaseProductOption> products;
  final double Function(int supplierId) supplierDue;

  @override
  State<_PurchaseEditorDialog> createState() => _PurchaseEditorDialogState();
}

class _PurchaseEditorDialogState extends State<_PurchaseEditorDialog> {
  late final TextEditingController _invoice;
  late final TextEditingController _tax;
  late final TextEditingController _paid;
  late final TextEditingController _notes;

  int? _supplierId;
  int? _selectedProductId;
  int? _editingLineIndex;
  _ReceiveUnit _receiveUnit = _ReceiveUnit.item;
  final _qty = TextEditingController(text: '1');
  final _pcsPerBox = TextEditingController(text: '6');
  final _unitCost = TextEditingController();
  final _selling = TextEditingController();
  final _wholesale = TextEditingController();
  final _batchCode = TextEditingController();
  DateTime? _manufactureDate;
  DateTime? _expiryDate;
  final List<PurchaseLineItem> _lines = [];

  @override
  void initState() {
    super.initState();
    _invoice = TextEditingController(
      text: 'PUR-${DateTime.now().millisecondsSinceEpoch % 100000}',
    );
    _tax = TextEditingController(text: '0');
    _paid = TextEditingController(text: '0');
    _notes = TextEditingController();
    final firstActiveSupplier = widget.suppliers
        .where((supplier) => supplier.isActive)
        .fold<Map<int, SupplierItem>>({}, (map, supplier) {
          map.putIfAbsent(supplier.id, () => supplier);
          return map;
        })
        .values
        .firstOrNull;
    _supplierId = firstActiveSupplier?.id;
  }

  List<SupplierItem> _uniqueActiveSuppliers() {
    final unique = <int, SupplierItem>{};
    for (final supplier in widget.suppliers.where((s) => s.isActive)) {
      unique.putIfAbsent(supplier.id, () => supplier);
    }
    return unique.values.toList(growable: false);
  }

  List<PurchaseProductOption> _uniqueProducts() {
    final unique = <int, PurchaseProductOption>{};
    for (final product in widget.products) {
      unique.putIfAbsent(product.id, () => product);
    }
    return unique.values.toList(growable: false);
  }

  int? _resolveSupplierId(List<SupplierItem> activeSuppliers) {
    if (activeSuppliers.isEmpty) return null;
    if (_supplierId != null &&
        activeSuppliers.any((supplier) => supplier.id == _supplierId)) {
      return _supplierId;
    }
    return activeSuppliers.first.id;
  }

  PurchaseProductOption? get _selectedProduct {
    final id = _selectedProductId;
    if (id == null) return null;
    for (final product in _uniqueProducts()) {
      if (product.id == id) return product;
    }
    return null;
  }

  @override
  void dispose() {
    _invoice.dispose();
    _tax.dispose();
    _paid.dispose();
    _notes.dispose();
    _qty.dispose();
    _pcsPerBox.dispose();
    _unitCost.dispose();
    _selling.dispose();
    _wholesale.dispose();
    _batchCode.dispose();
    super.dispose();
  }

  double get _subtotal =>
      _lines.fold(0, (sum, line) => sum + line.lineTotalComputed);

  double get _taxAmount => double.tryParse(_tax.text.trim()) ?? 0;

  double get _total => _subtotal + _taxAmount;

  String get _baseUnitLabel {
    final unit = _selectedProduct?.unit?.trim();
    return unit == null || unit.isEmpty ? 'pcs' : unit;
  }

  int get _pcsPerPackage {
    if (_receiveUnit == _ReceiveUnit.item) return 1;
    return int.tryParse(_pcsPerBox.text.trim()) ?? 0;
  }

  bool get _isVariableProduct {
    final product = _selectedProduct;
    if (product == null) return false;
    return MeasureUnits.isVariableUnit(product.unit);
  }

  double get _enteredDisplayQty => double.tryParse(_qty.text.trim()) ?? 0;

  int get _enteredQty => _enteredDisplayQty.round();

  int get _baseQty {
    if (_enteredDisplayQty <= 0 || _pcsPerPackage <= 0) return 0;
    if (_isVariableProduct && _receiveUnit == _ReceiveUnit.item) {
      return MeasureUnits.toBaseUnits(
        _enteredDisplayQty,
        _selectedProduct?.unit,
        MeasureUnits.inferSellType(_selectedProduct?.unit),
      );
    }
    return _enteredQty * _pcsPerPackage;
  }

  double get _enteredCost => double.tryParse(_unitCost.text.trim()) ?? 0;

  double get _baseUnitCost {
    if (_pcsPerPackage <= 1) return _enteredCost;
    return _enteredCost / _pcsPerPackage;
  }

  double get _linePreviewTotal {
    if (_isVariableProduct && _receiveUnit == _ReceiveUnit.item) {
      return _enteredDisplayQty * _enteredCost;
    }
    return _baseQty * _baseUnitCost;
  }

  double get _enteredSelling => double.tryParse(_selling.text.trim()) ?? 0;

  int _addedLineCountFor(int productId) {
    var count = 0;
    for (final line in _lines) {
      if (line.productId == productId) count++;
    }
    return count;
  }

  void _fillPricesFrom(PurchaseProductOption product) {
    if (product.purchasePrice > 0) {
      if (_receiveUnit == _ReceiveUnit.box) {
        final pcs = int.tryParse(_pcsPerBox.text.trim()) ?? 1;
        _unitCost.text = (product.purchasePrice * pcs).toStringAsFixed(2);
      } else {
        _unitCost.text = product.purchasePrice.toStringAsFixed(0);
      }
    } else {
      _unitCost.clear();
    }
    _selling.text = product.sellingPrice > 0
        ? product.sellingPrice.toStringAsFixed(0)
        : '';
    _wholesale.text = product.wholesalePrice > 0
        ? product.wholesalePrice.toStringAsFixed(0)
        : '';
  }

  void _onProductSelected(int? productId) {
    setState(() {
      _editingLineIndex = null;
      _selectedProductId = productId;
      _receiveUnit = _ReceiveUnit.item;
      final product = _selectedProduct;
      if (product != null) {
        _pcsPerBox.text = '6';
        _fillPricesFrom(product);
        _batchCode.text = _nextBatchCode(product);
      } else {
        _unitCost.clear();
        _selling.clear();
        _wholesale.clear();
        _batchCode.clear();
      }
    });
  }

  String _formatEditorNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  void _resetLineEditor() {
    _editingLineIndex = null;
    _selectedProductId = null;
    _receiveUnit = _ReceiveUnit.item;
    _qty.text = '1';
    _pcsPerBox.text = '6';
    _unitCost.clear();
    _selling.clear();
    _wholesale.clear();
    _batchCode.clear();
    _manufactureDate = null;
    _expiryDate = null;
  }

  void _startEditingLine(int index) {
    final line = _lines[index];
    setState(() {
      _editingLineIndex = index;
      _selectedProductId = line.productId;
      _receiveUnit = line.packageUnit?.toLowerCase() == 'box'
          ? _ReceiveUnit.box
          : _ReceiveUnit.item;
      _qty.text = (line.packageQuantity ?? line.displayQuantity).toString();
      _pcsPerBox.text = (line.unitsPerPackage <= 0 ? 1 : line.unitsPerPackage)
          .toString();
      _unitCost.text = _formatEditorNumber(
        line.packageUnitCost ?? line.displayUnitCost,
      );
      _selling.text = line.sellingPrice == null
          ? ''
          : _formatEditorNumber(line.sellingPrice!);
      _wholesale.text = (line.wholesalePrice == null || line.wholesalePrice == 0)
          ? ''
          : _formatEditorNumber(line.wholesalePrice!);
      _batchCode.text = line.batchCode ?? '';
      _manufactureDate = line.manufactureDate;
      _expiryDate = line.expiryDate;
    });
  }

  String _nextBatchCode(PurchaseProductOption product) {
    final extra = _lines.where((line) => line.productId == product.id).length;
    return 'B-${(product.nextBatchNumber + extra).toString().padLeft(3, '0')}';
  }

  void _onReceiveUnitChanged(_ReceiveUnit? value) {
    if (value == null) return;
    final product = _selectedProduct;
    setState(() {
      _receiveUnit = value;
      if (product == null) return;
      _fillPricesFrom(product);
    });
  }

  Future<void> _pickManufactureDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 30);
    final requestedLastDate = _expiryDate ?? DateTime(now.year + 30);
    final lastDate = requestedLastDate.isBefore(firstDate)
        ? firstDate
        : requestedLastDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(_manufactureDate ?? now, firstDate, lastDate),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && mounted) {
      setState(() => _manufactureDate = picked);
    }
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final firstDate = _manufactureDate ?? DateTime(now.year - 5);
    final lastDate = DateTime(now.year + 50);
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(
        _expiryDate ?? _manufactureDate ?? now,
        firstDate,
        lastDate,
      ),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && mounted) {
      setState(() => _expiryDate = picked);
    }
  }

  DateTime _clampDate(DateTime value, DateTime first, DateTime last) {
    if (value.isBefore(first)) return first;
    if (value.isAfter(last)) return last;
    return value;
  }

  void _addLine() {
    final product = _selectedProduct;
    final cost = double.tryParse(_unitCost.text.trim());
    if (product == null) {
      _showError('Select a product.');
      return;
    }
    if (_isVariableProduct && _receiveUnit == _ReceiveUnit.item) {
      if (_enteredDisplayQty <= 0) {
        _showError('Enter a valid quantity.');
        return;
      }
    } else {
      final qty = int.tryParse(_qty.text.trim());
      if (qty == null || qty <= 0) {
        _showError('Enter a valid quantity.');
        return;
      }
    }
    if (cost == null || cost < 0) {
      _showError('Enter a valid purchase cost.');
      return;
    }

    final selling = double.tryParse(_selling.text.trim());
    final wholesale = double.tryParse(_wholesale.text.trim()) ?? 0;
    if (selling == null || selling <= 0) {
      _showError('Enter a selling price greater than zero.');
      return;
    }

    final pcsPerPackage = _pcsPerPackage;
    if (_receiveUnit == _ReceiveUnit.box && pcsPerPackage < 1) {
      _showError('Enter pieces per box (at least 1).');
      return;
    }
    if (_manufactureDate != null &&
        _expiryDate != null &&
        _manufactureDate!.isAfter(_expiryDate!)) {
      _showError('Manufacture date must be on or before expiry date.');
      return;
    }

    final baseQuantity = _baseQty;
    final packageQty = _isVariableProduct && _receiveUnit == _ReceiveUnit.item
        ? _enteredDisplayQty
        : _enteredQty.toDouble();
    final baseUnitCost = () {
      if (_isVariableProduct && _receiveUnit == _ReceiveUnit.item) {
        final multiplier = MeasureUnits.unitMultiplier(product.unit);
        return multiplier <= 1 ? cost : cost / multiplier;
      }
      return _pcsPerPackage <= 1 ? cost : cost / _pcsPerPackage;
    }();
    final costPerDisplayUnit =
        _isVariableProduct && _receiveUnit == _ReceiveUnit.item
        ? cost
        : (_receiveUnit == _ReceiveUnit.box ? cost / pcsPerPackage : cost);
    if (costPerDisplayUnit > selling) {
      _showError(
        'Purchase cost (${CurrencyFormatter.format(costPerDisplayUnit)} / $_baseUnitLabel) '
        'cannot be higher than selling price (${CurrencyFormatter.format(selling)}).',
      );
      return;
    }
    if (wholesale > 0 &&
        (wholesale < costPerDisplayUnit || wholesale > selling)) {
      _showError('Wholesale must be between purchase cost and selling price.');
      return;
    }

    final batchCode = _batchCode.text.trim().isEmpty
        ? _nextBatchCode(product)
        : _batchCode.text.trim();

    setState(() {
      final newLine = PurchaseLineItem(
        productId: product.id,
        productName: product.name,
        productSku: product.sku,
        quantity: baseQuantity,
        unitCost: baseUnitCost,
        manufactureDate: _manufactureDate,
        expiryDate: _expiryDate,
        batchCode: batchCode,
        packageQuantity: packageQty.round(),
        packageUnit: _receiveUnit == _ReceiveUnit.box ? 'Box' : _baseUnitLabel,
        unitsPerPackage: pcsPerPackage,
        packageUnitCost: _isVariableProduct && _receiveUnit == _ReceiveUnit.item
            ? cost
            : cost,
        sellingPrice: selling,
        wholesalePrice: wholesale,
      );
      if (_editingLineIndex != null) {
        _lines[_editingLineIndex!] = newLine;
      } else {
        _lines.add(newLine);
      }
      _resetLineEditor();
    });
  }

  void _removeLine(int index) {
    setState(() {
      _lines.removeAt(index);
      if (_editingLineIndex == index) {
        _resetLineEditor();
      } else if (_editingLineIndex != null && _editingLineIndex! > index) {
        _editingLineIndex = _editingLineIndex! - 1;
      }
    });
  }

  void _showError(String message) {
    AppToast.show(context, message);
  }

  void _submit() {
    final invoice = _invoice.text.trim();
    if (invoice.isEmpty) {
      _showError('Enter an invoice number.');
      return;
    }
    final supplierId = _resolveSupplierId(_uniqueActiveSuppliers());
    if (supplierId == null) {
      _showError('Select a supplier.');
      return;
    }
    if (_lines.isEmpty) {
      _showError('Add at least one product line.');
      return;
    }

    final tax = double.tryParse(_tax.text.trim());
    if (tax == null || tax < 0) {
      _showError('Enter a valid tax amount.');
      return;
    }
    final paid = double.tryParse(_paid.text.trim());
    if (paid == null) {
      _showError('Enter a valid paid amount.');
      return;
    }
    if (paid < 0 || paid > _total) {
      _showError('Paid amount must be between 0 and total.');
      return;
    }

    Navigator.of(context).pop(
      PurchaseDraft(
        supplierId: supplierId,
        invoiceNo: invoice,
        lines: List.unmodifiable(_lines),
        paidAmount: paid,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        taxAmount: tax,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeSuppliers = _uniqueActiveSuppliers();
    final supplierId = _resolveSupplierId(activeSuppliers);
    final productOptions = _uniqueProducts();
    final selectedProductId =
        productOptions.any((product) => product.id == _selectedProductId)
        ? _selectedProductId
        : null;
    final isEditingLine = _editingLineIndex != null;
    final media = MediaQuery.sizeOf(context);
    final isBox = _receiveUnit == _ReceiveUnit.box;

    return AlertDialog(
      title: const Text('New purchase'),
      clipBehavior: Clip.none,
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      content: SizedBox(
        width: (media.width * 0.9).clamp(440.0, 640.0),
        height: (media.height * 0.74).clamp(500.0, 680.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  bottom: AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (activeSuppliers.isEmpty)
                      Text(
                        'Add a supplier first before creating a purchase.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.warning,
                        ),
                      )
                    else
                      DropdownButtonFormField<int>(
                        key: ValueKey('supplier:$supplierId'),
                        initialValue: supplierId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
                        ),
                        items: activeSuppliers
                            .map(
                              (supplier) => DropdownMenuItem(
                                value: supplier.id,
                                child: Text(
                                  supplier.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: activeSuppliers.isEmpty
                            ? null
                            : (value) => setState(() => _supplierId = value),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _invoice,
                      decoration: const InputDecoration(
                        labelText: 'Invoice number',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Add products', style: theme.textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.sm),
                    if (productOptions.isEmpty)
                      const Text('No active products available.')
                    else ...[
                      DropdownButtonFormField<int>(
                        key: ValueKey(selectedProductId ?? 'product-none'),
                        initialValue: selectedProductId,
                        isExpanded: true,
                        decoration: const InputDecoration(labelText: 'Product'),
                        selectedItemBuilder: (context) => productOptions
                            .map(
                              (product) => Align(
                                alignment: Alignment.centerLeft,
                                child: _PurchaseProductOptionRow(
                                  product: product,
                                  compact: true,
                                  addedLineCount: _addedLineCountFor(
                                    product.id,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        items: productOptions
                            .map(
                              (product) => DropdownMenuItem(
                                value: product.id,
                                child: _PurchaseProductOptionRow(
                                  product: product,
                                  addedLineCount: _addedLineCountFor(
                                    product.id,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: _onProductSelected,
                      ),
                      if (selectedProductId == null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Select a product to show quantity, batch, prices, and add/update fields.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                      if (selectedProductId != null &&
                          _selectedProduct != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        _PurchaseProductStatusBanner(
                          product: _selectedProduct!,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            SizedBox(
                              width: 110,
                              child: DropdownButtonFormField<_ReceiveUnit>(
                                key: ValueKey('recv:$_receiveUnit'),
                                initialValue: _receiveUnit,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Unit',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: _ReceiveUnit.item,
                                    child: Text('Item'),
                                  ),
                                  DropdownMenuItem(
                                    value: _ReceiveUnit.box,
                                    child: Text('Box'),
                                  ),
                                ],
                                onChanged: _onReceiveUnitChanged,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                controller: _qty,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters:
                                    _isVariableProduct &&
                                        _receiveUnit == _ReceiveUnit.item
                                    ? FieldLimits.decimalQty
                                    : FieldLimits.stockQty,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: isBox
                                      ? 'Boxes'
                                      : (_isVariableProduct
                                            ? 'Qty ($_baseUnitLabel)'
                                            : 'Qty'),
                                ),
                              ),
                            ),
                            if (isBox) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: TextField(
                                  controller: _pcsPerBox,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final product = _selectedProduct;
                                    final pcs = int.tryParse(value.trim()) ?? 0;
                                    setState(() {
                                      if (product != null &&
                                          pcs > 1 &&
                                          product.purchasePrice > 0) {
                                        _unitCost.text =
                                            (product.purchasePrice * pcs)
                                                .toStringAsFixed(2);
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Pcs / box',
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _batchCode,
                          decoration: InputDecoration(
                            labelText: 'Batch / lot code',
                            hintText: _selectedProduct == null
                                ? 'Select a product'
                                : _nextBatchCode(_selectedProduct!),
                            helperText:
                                'Auto-increments per product (B-001, B-002…)',
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: _DatePickerField(
                                label: 'Manufacture date',
                                value: _manufactureDate,
                                onPick: _pickManufactureDate,
                                onClear: () =>
                                    setState(() => _manufactureDate = null),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _DatePickerField(
                                label: 'Expiry date',
                                value: _expiryDate,
                                onPick: _pickExpiryDate,
                                onClear: () => setState(() => _expiryDate = null),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Prices (per item)',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _unitCost,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: FieldLimits.money,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  labelText: isBox
                                      ? 'Cost / box'
                                      : 'Purchase cost',
                                  prefixText: 'Rs ',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                controller: _wholesale,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: FieldLimits.money,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  labelText: 'Wholesale / item',
                                  hintText: 'Optional',
                                  prefixText: 'Rs ',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                controller: _selling,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                inputFormatters: FieldLimits.money,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  labelText: 'Selling / item',
                                  prefixText: 'Rs ',
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_baseQty > 0) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.55),
                              borderRadius: AppRadii.smAll,
                            ),
                            child: Text(
                              [
                                if (isBox)
                                  '$_enteredQty × $_pcsPerPackage = $_baseQty $_baseUnitLabel'
                                else
                                  '$_enteredQty $_baseUnitLabel',
                                'Cost ${CurrencyFormatter.format(_baseUnitCost)} / item',
                                if (_enteredSelling > 0)
                                  'Sell ${CurrencyFormatter.format(_enteredSelling)}',
                                CurrencyFormatter.format(_linePreviewTotal),
                              ].join(' · '),
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            if (isEditingLine) ...[
                              TextButton(
                                onPressed: () => setState(_resetLineEditor),
                                child: const Text('Cancel edit'),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            Expanded(
                              child: AppButton(
                                label: isEditingLine
                                    ? 'Update product'
                                    : 'Add product',
                                icon: isEditingLine ? Symbols.edit : Symbols.add,
                                expanded: true,
                                height: 48,
                                onPressed: _addLine,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    if (_lines.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Text(
                            'Your products',
                            style: theme.textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${_lines.length} item${_lines.length == 1 ? '' : 's'}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...List.generate(_lines.length, (index) {
                        final line = _lines[index];
                        return _PurchaseLineCard(
                          line: line,
                          onEdit: () => _startEditingLine(index),
                          onRemove: () => _removeLine(index),
                        );
                      }),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _notes,
                      decoration: const InputDecoration(
                        labelText: 'Notes (optional)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tax,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Tax',
                      hintText: '0',
                      prefixText: 'Rs ',
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _paid,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Paid now',
                      hintText: '0',
                      prefixText: 'Rs ',
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _BillSummaryPanel(
              subtotal: _subtotal,
              tax: _taxAmount,
              total: _total,
              paid: double.tryParse(_paid.text.trim()) ?? 0,
              supplierNetDue: supplierId == null
                  ? 0
                  : KhataBalanceRules.money(widget.supplierDue(supplierId)),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Save purchase',
          icon: Symbols.assignment,
          onPressed: activeSuppliers.isEmpty || _lines.isEmpty ? null : _submit,
        ),
      ],
    );
  }
}

class _PurchaseLineCard extends StatelessWidget {
  const _PurchaseLineCard({
    required this.line,
    required this.onEdit,
    required this.onRemove,
  });

  final PurchaseLineItem line;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final panel = isDark ? const Color(0xFF1E2330) : Colors.white;
    final border = isDark ? const Color(0xFF2D3345) : const Color(0xFFD5DCE8);
    final meta = <String>[
      if (line.batchCode?.trim().isNotEmpty == true)
        'Batch ${line.batchCode!.trim()}',
      if (line.expiryDate != null)
        'Exp ${DateFormat('dd MMM yyyy').format(line.expiryDate!)}',
      if (line.unitsPerPackage > 1)
        '${line.displayQuantity} ${line.displayUnit} → ${line.quantity} pcs',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                line.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                line.productSku,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${line.displayQuantity} ${line.displayUnit}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _MiniStat(
                          label: 'Purchase price',
                          value: CurrencyFormatter.format(line.displayUnitCost),
                        ),
                        const SizedBox(width: 12),
                        if (line.sellingPrice != null) ...[
                          _MiniStat(
                            label: 'Sell',
                            value: CurrencyFormatter.format(line.sellingPrice!),
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                        ],
                        const Spacer(),
                        _MiniStat(
                          label: 'Total',
                          value: CurrencyFormatter.format(
                            line.lineTotalComputed,
                          ),
                          color: AppColors.accent,
                          bold: true,
                        ),
                      ],
                    ),
                    if (meta.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        meta.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'Edit line',
                  visualDensity: VisualDensity.compact,
                  onPressed: onEdit,
                  icon: Icon(
                    Symbols.edit,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
                IconButton(
                  tooltip: 'Remove line',
                  visualDensity: VisualDensity.compact,
                  onPressed: onRemove,
                  icon: Icon(
                    Symbols.close,
                    size: 18,
                    color: theme.colorScheme.error.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.color,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: c.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            color: c,
            fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BillSummaryPanel extends StatelessWidget {
  const _BillSummaryPanel({
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paid,
    required this.supplierNetDue,
  });

  final double subtotal;
  final double tax;
  final double total;
  final double paid;
  final double supplierNetDue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paidNow = paid.clamp(0.0, total);
    final pendingThisBill = (total - paidNow).clamp(0.0, double.infinity);
    // Old supplier give/take + unpaid portion of this bill.
    final netAfter = KhataBalanceRules.money(supplierNetDue + pendingThisBill);
    final direction = KhataBalanceRules.supplierDirection(netAfter);
    final color = KhataBalanceRules.colorForDirection(direction);
    final label = KhataBalanceRules.statusLabel(direction);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total bill',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        CurrencyFormatter.format(total),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (tax > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(+tax ${CurrencyFormatter.format(tax)})',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label == 'Settled' ? 'Settled' : 'To ${label.toLowerCase()}',
                    style: theme.textTheme.labelSmall?.copyWith(color: color),
                  ),
                  if (direction == KhataDirection.settled)
                    const Icon(
                      Symbols.check_circle,
                      size: 18,
                      color: KhataBalanceRules.takeColor,
                    )
                  else
                    Text(
                      CurrencyFormatter.format(netAfter.abs()),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (pendingThisBill > 0.009 ||
              KhataBalanceRules.hasSupplierBalance(supplierNetDue)) ...[
            const SizedBox(height: 6),
            Text(
              [
                if (KhataBalanceRules.hasSupplierBalance(supplierNetDue))
                  'Old ${KhataBalanceRules.supplierDetailLabel(supplierNetDue)}',
                if (pendingThisBill > 0.009)
                  'This bill ${CurrencyFormatter.format(pendingThisBill)}',
              ].join(' · '),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = value == null
        ? 'Not set'
        : DateFormat('d MMM yyyy').format(value!);

    return InkWell(
      onTap: onPick,
      borderRadius: AppRadii.smAll,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                IconButton(
                  tooltip: 'Clear',
                  onPressed: onClear,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Symbols.close, size: 18),
                ),
              IconButton(
                tooltip: 'Choose date',
                onPressed: onPick,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Symbols.calendar_today, size: 18),
              ),
            ],
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: value == null
                ? theme.hintColor
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
