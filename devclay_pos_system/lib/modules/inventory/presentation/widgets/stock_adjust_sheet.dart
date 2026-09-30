import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../utils/measure_units.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/inventory_entities.dart';

enum _StockUnit { item, box }

class StockAdjustResult {
  const StockAdjustResult({
    required this.quantityChange,
    required this.type,
    this.note,
    this.expiryDate,
    this.manufactureDate,
    this.batchCode,
    this.purchasePrice,
    this.sellingPrice,
    this.wholesalePrice,
    this.itemsPerBox,
  });

  final int quantityChange;
  final String type;
  final String? note;
  final DateTime? expiryDate;
  final DateTime? manufactureDate;
  final String? batchCode;
  final double? purchasePrice;
  final double? sellingPrice;
  final double? wholesalePrice;
  final int? itemsPerBox;
}

Future<StockAdjustResult?> showStockAdjustSheet({
  required BuildContext context,
  required InventoryProduct product,
  bool openingStock = false,
}) {
  return showModalBottomSheet<StockAdjustResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _StockAdjustSheet(product: product, openingStock: openingStock),
  );
}

class _StockAdjustSheet extends StatefulWidget {
  const _StockAdjustSheet({required this.product, required this.openingStock});

  final InventoryProduct product;
  final bool openingStock;

  @override
  State<_StockAdjustSheet> createState() => _StockAdjustSheetState();
}

class _StockAdjustSheetState extends State<_StockAdjustSheet> {
  final _quantity = TextEditingController(text: '1');
  final _note = TextEditingController();
  final _piecesPerBox = TextEditingController();
  final _batchCode = TextEditingController();
  final _purchasePrice = TextEditingController();
  final _wholesalePrice = TextEditingController();
  final _sellingPrice = TextEditingController();
  bool _addStock = true;
  _StockUnit _stockUnit = _StockUnit.item;
  DateTime? _manufactureDate;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    if (widget.openingStock) {
      _addStock = true;
      final opening = widget.product.displayStock;
      _quantity.text = opening > 0
          ? MeasureUnits.formatDisplayInput(opening)
          : '0';
    }
    _expiryDate = widget.product.expiryDate;
    _piecesPerBox.text = widget.product.itemsPerBox > 0
        ? widget.product.itemsPerBox.toString()
        : '1';
    _batchCode.text = widget.product.suggestedBatchCode;
    _purchasePrice.text = widget.product.purchasePrice.toStringAsFixed(2);
    _wholesalePrice.text = widget.product.wholesalePrice > 0
        ? widget.product.wholesalePrice.toStringAsFixed(2)
        : '';
    _sellingPrice.text = widget.product.sellingPrice.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _quantity.dispose();
    _note.dispose();
    _piecesPerBox.dispose();
    _batchCode.dispose();
    _purchasePrice.dispose();
    _wholesalePrice.dispose();
    _sellingPrice.dispose();
    super.dispose();
  }

  String get _unitLabel {
    final unit = widget.product.unit?.trim();
    return unit == null || unit.isEmpty ? 'items' : unit;
  }

  bool get _isVariable => widget.product.isVariable;

  String get _baseUnitHint {
    return switch (widget.product.sellType) {
      SellType.weight => 'g',
      SellType.volume => 'ml',
      SellType.length => 'mm',
      SellType.piece => 'pcs',
    };
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final firstDate = _manufactureDate ?? DateTime(now.year - 100);
    final normalLastDate = DateTime(now.year + 50, 12, 31);
    final lastDate = firstDate.isAfter(normalLastDate)
        ? DateTime(firstDate.year + 50, 12, 31)
        : normalLastDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(_expiryDate ?? now, firstDate, lastDate),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _pickManufacture() async {
    final now = DateTime.now();
    final lastDate = _expiryDate ?? DateTime(now.year + 50, 12, 31);
    final normalFirstDate = DateTime(now.year - 100);
    final firstDate = lastDate.isBefore(normalFirstDate)
        ? DateTime(lastDate.year - 100)
        : normalFirstDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: _clampDate(_manufactureDate ?? now, firstDate, lastDate),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) setState(() => _manufactureDate = picked);
  }

  DateTime _clampDate(DateTime value, DateTime first, DateTime last) {
    if (value.isBefore(first)) return first;
    if (value.isAfter(last)) return last;
    return value;
  }

  /// Converts the form quantity into base stock units (pcs/g/ml/mm).
  int? _enteredBaseQuantity() {
    if (_isVariable && _stockUnit == _StockUnit.item) {
      final display = MeasureUnits.parseDecimalInput(_quantity.text);
      if (display == null || display <= 0) return null;
      return MeasureUnits.toBaseUnits(
        display,
        widget.product.unit,
        widget.product.sellType,
      );
    }

    final raw = int.tryParse(_quantity.text.trim());
    if (raw == null || raw <= 0) return null;
    final pieces = _stockUnit == _StockUnit.box
        ? int.tryParse(_piecesPerBox.text.trim())
        : 1;
    if (pieces == null || pieces < 1) return null;
    final displayPackages = raw * pieces;
    if (_isVariable) {
      return MeasureUnits.toBaseUnits(
        displayPackages.toDouble(),
        widget.product.unit,
        widget.product.sellType,
      );
    }
    return displayPackages;
  }

  void _submit() {
    final quantity = _enteredBaseQuantity();
    if (quantity == null || quantity <= 0) {
      AppToast.show(
        context,
        _isVariable
            ? 'Enter a valid quantity in $_unitLabel (e.g. 1 or 0.5).'
            : 'Enter a valid quantity greater than zero.',
      );
      return;
    }

    if (_stockUnit == _StockUnit.box) {
      final pieces = int.tryParse(_piecesPerBox.text.trim());
      if (pieces == null || pieces < 1) {
        AppToast.show(context, 'Enter pieces per box (at least 1).');
        return;
      }
    }

    final change = widget.openingStock
        ? quantity - widget.product.stock
        : (_addStock ? quantity : -quantity);

    if (change == 0) {
      AppToast.show(context, 'No stock change to apply.');
      return;
    }

    if (!widget.openingStock && !_addStock && quantity > widget.product.stock) {
      AppToast.show(
        context,
        'Cannot remove more than current stock '
        '(${widget.product.formattedStock}).',
      );
      return;
    }

    double? purchase;
    double? wholesale;
    double? selling;
    if (change > 0) {
      purchase = double.tryParse(_purchasePrice.text.trim());
      wholesale = _wholesalePrice.text.trim().isEmpty
          ? 0
          : double.tryParse(_wholesalePrice.text.trim());
      selling = double.tryParse(_sellingPrice.text.trim());
      if (purchase == null || purchase < 0 || selling == null || selling <= 0) {
        AppToast.show(context, 'Enter valid purchase and selling prices.');
        return;
      }
      if (purchase > selling ||
          (wholesale != null &&
              wholesale > 0 &&
              (wholesale < purchase || wholesale > selling))) {
        AppToast.show(
          context,
          'Wholesale must be between purchase cost and selling price.',
        );
        return;
      }
      if (_manufactureDate != null &&
          _expiryDate != null &&
          _manufactureDate!.isAfter(_expiryDate!)) {
        AppToast.show(context, 'Manufacture date must be before expiry date.');
        return;
      }
    }

    final piecesPerBox = _stockUnit == _StockUnit.box
        ? int.tryParse(_piecesPerBox.text.trim())
        : null;

    Navigator.of(context).pop(
      StockAdjustResult(
        quantityChange: change,
        type: widget.openingStock ? 'opening' : 'adjustment',
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        expiryDate: change > 0 ? _expiryDate : null,
        manufactureDate: change > 0 ? _manufactureDate : null,
        batchCode: change > 0 && _batchCode.text.trim().isNotEmpty
            ? _batchCode.text.trim()
            : null,
        purchasePrice: change > 0 ? purchase : null,
        sellingPrice: change > 0 ? selling : null,
        wholesalePrice: change > 0 ? wholesale : null,
        itemsPerBox: change > 0 ? piecesPerBox : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.openingStock ? 'Set opening stock' : 'Adjust stock';

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.sm,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${widget.product.name} · ${widget.product.sku}',
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              'Current stock: ${widget.product.formattedStock}',
              style: theme.textTheme.labelLarge,
            ),
            if (_isVariable) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter quantity in $_unitLabel (1 $_unitLabel = '
                '${MeasureUnits.unitMultiplier(widget.product.unit)} '
                '$_baseUnitHint stored).',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            if (!widget.openingStock)
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Add')),
                  ButtonSegment(value: false, label: Text('Remove')),
                ],
                selected: {_addStock},
                onSelectionChanged: (value) {
                  setState(() => _addStock = value.first);
                },
              ),
            if (!widget.openingStock) const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (!_isVariable)
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<_StockUnit>(
                      initialValue: _stockUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: const [
                        DropdownMenuItem(
                          value: _StockUnit.item,
                          child: Text('Item'),
                        ),
                        DropdownMenuItem(
                          value: _StockUnit.box,
                          child: Text('Box'),
                        ),
                      ],
                      onChanged: (value) => setState(() {
                        _stockUnit = value ?? _StockUnit.item;
                      }),
                    ),
                  ),
                if (!_isVariable) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _quantity,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: _isVariable,
                    ),
                    inputFormatters: _isVariable
                        ? FieldLimits.decimalQty
                        : FieldLimits.stockQty,
                    decoration: InputDecoration(
                      labelText: widget.openingStock
                          ? 'Opening quantity ($_unitLabel)'
                          : (_addStock
                                ? 'Quantity to add ($_unitLabel)'
                                : 'Quantity to remove ($_unitLabel)'),
                      hintText: _stockUnit == _StockUnit.box && !_isVariable
                          ? 'Boxes'
                          : (_isVariable ? 'e.g. 1 or 0.5' : _unitLabel),
                    ),
                  ),
                ),
                if (!_isVariable && _stockUnit == _StockUnit.box) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _piecesPerBox,
                      keyboardType: TextInputType.number,
                      inputFormatters: FieldLimits.stockQty,
                      decoration: const InputDecoration(
                        labelText: 'Pcs / box',
                        hintText: '1',
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (widget.openingStock || _addStock) ...[
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _batchCode,
                label: 'Batch / lot code (optional)',
                hintText: 'e.g. B-001',
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _DateTile(
                      label: 'Manufacture date',
                      value: _manufactureDate,
                      onPick: _pickManufacture,
                      onClear: () => setState(() => _manufactureDate = null),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _DateTile(
                      label: 'Expiry date',
                      value: _expiryDate,
                      onPick: _pickExpiry,
                      onClear: () => setState(() => _expiryDate = null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _isVariable
                    ? 'Prices (per $_unitLabel)'
                    : 'Prices (per item)',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _purchasePrice,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: FieldLimits.money,
                      decoration: const InputDecoration(
                        labelText: 'Purchase',
                        prefixText: 'Rs ',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _wholesalePrice,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: FieldLimits.money,
                      decoration: const InputDecoration(
                        labelText: 'Wholesale',
                        prefixText: 'Rs ',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _sellingPrice,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: FieldLimits.money,
                      decoration: const InputDecoration(
                        labelText: 'Selling',
                        prefixText: 'Rs ',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Added units go into this expiry lot. Removals use FEFO '
                '(oldest expiry first).',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _note,
              label: 'Note (optional)',
              hintText: 'Reason or reference',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: widget.openingStock
                  ? 'Save opening stock'
                  : (_addStock ? 'Add to inventory' : 'Remove from inventory'),
              icon: Symbols.inventory,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
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
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    subtitle: Text(
      value == null ? 'Optional' : DateFormat('dd MMM yyyy').format(value!),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (value != null)
          IconButton(onPressed: onClear, icon: const Icon(Symbols.close)),
        IconButton(onPressed: onPick, icon: const Icon(Symbols.calendar_month)),
      ],
    ),
  );
}
