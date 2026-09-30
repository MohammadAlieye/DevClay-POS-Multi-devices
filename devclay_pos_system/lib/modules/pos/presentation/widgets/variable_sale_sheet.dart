import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/measure_units.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/pos_entities.dart';

class VariableSaleResult {
  const VariableSaleResult({
    required this.quantityBaseUnits,
    required this.quantityLabel,
    this.overrideLineTotal,
  });

  final int quantityBaseUnits;
  final String quantityLabel;
  final double? overrideLineTotal;
}

enum _VariableEntryMode { byMeasure, byAmount }

Future<VariableSaleResult?> showVariableSaleSheet({
  required BuildContext context,
  required PosProduct product,
  required int availableStockBaseUnits,
  VariableSaleResult? initial,
}) {
  return showModalBottomSheet<VariableSaleResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _VariableSaleSheet(
      product: product,
      availableStockBaseUnits: availableStockBaseUnits,
      initial: initial,
    ),
  );
}

class _VariableSaleSheet extends StatefulWidget {
  const _VariableSaleSheet({
    required this.product,
    required this.availableStockBaseUnits,
    this.initial,
  });

  final PosProduct product;
  final int availableStockBaseUnits;
  final VariableSaleResult? initial;

  @override
  State<_VariableSaleSheet> createState() => _VariableSaleSheetState();
}

class _VariableSaleSheetState extends State<_VariableSaleSheet> {
  late _VariableEntryMode _mode;
  late final TextEditingController _measureController;
  late final TextEditingController _amountController;
  late final TextEditingController _chargeController;
  late String _displayUnit;
  bool _syncing = false;
  String? _error;

  PosProduct get product => widget.product;
  SellType get sellType => product.sellTypeEnum;

  @override
  void initState() {
    super.initState();
    _mode = _VariableEntryMode.byMeasure;
    _displayUnit = _defaultDisplayUnit();
    _measureController = TextEditingController();
    _amountController = TextEditingController();
    _chargeController = TextEditingController();
    _measureController.addListener(_onMeasureChanged);
    _amountController.addListener(_onAmountChanged);
    _chargeController.addListener(() => setState(() {}));

    final initial = widget.initial;
    if (initial != null) {
      final displayQty = MeasureUnits.fromBaseUnits(
        initial.quantityBaseUnits,
        product.unit,
        sellType,
      );
      _measureController.text = _formatInput(displayQty);
      _syncChargeFromMeasure();
      if (initial.overrideLineTotal != null) {
        _chargeController.text = _formatInput(initial.overrideLineTotal!);
      }
    }
  }

  @override
  void dispose() {
    _measureController
      ..removeListener(_onMeasureChanged)
      ..dispose();
    _amountController
      ..removeListener(_onAmountChanged)
      ..dispose();
    _chargeController.dispose();
    super.dispose();
  }

  String _defaultDisplayUnit() {
    final unit = product.unit?.trim().toLowerCase() ?? '';
    if (sellType == SellType.weight) {
      return unit == 'g' ? 'g' : 'kg';
    }
    if (sellType == SellType.volume) {
      return unit == 'ml' ? 'ml' : 'L';
    }
    return product.unit?.trim() ?? 'pcs';
  }

  String _formatInput(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value
        .toStringAsFixed(3)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  double? get _measureValue => double.tryParse(_measureController.text.trim());

  double? get _amountValue => double.tryParse(_amountController.text.trim());

  double? get _chargeValue => double.tryParse(_chargeController.text.trim());

  double get _computedCharge {
    final measure = _measureValue;
    if (measure == null || measure <= 0) return 0;
    final baseUnits = MeasureUnits.toBaseUnits(measure, _displayUnit, sellType);
    final displayQty = MeasureUnits.fromBaseUnits(
      baseUnits,
      _displayUnit,
      sellType,
    );
    return product.sellingPrice * displayQty;
  }

  int get _baseUnitsFromMeasure {
    final measure = _measureValue;
    if (measure == null || measure <= 0) return 0;
    return MeasureUnits.toBaseUnits(measure, _displayUnit, sellType);
  }

  void _onMeasureChanged() {
    if (_syncing || _mode != _VariableEntryMode.byMeasure) return;
    _syncing = true;
    final charge = _computedCharge;
    if (charge > 0) {
      _amountController.text = _formatInput(charge);
      _chargeController.text = _formatInput(charge);
    } else {
      _amountController.clear();
      _chargeController.clear();
    }
    _syncing = false;
    setState(() => _error = null);
  }

  void _onAmountChanged() {
    if (_syncing || _mode != _VariableEntryMode.byAmount) return;
    _syncing = true;
    final amount = _amountValue;
    if (amount != null && amount > 0) {
      final baseUnits = MeasureUnits.amountToBaseUnits(
        amountRs: amount,
        pricePerDisplayUnit: product.sellingPrice,
        unit: _displayUnit,
        sellType: sellType,
      );
      final displayQty = MeasureUnits.fromBaseUnits(
        baseUnits,
        _displayUnit,
        sellType,
      );
      _measureController.text = _formatInput(displayQty);
      _chargeController.text = _formatInput(amount);
    } else {
      _measureController.clear();
      _chargeController.clear();
    }
    _syncing = false;
    setState(() => _error = null);
  }

  void _syncChargeFromMeasure() {
    final charge = _computedCharge;
    if (charge > 0) {
      _amountController.text = _formatInput(charge);
      _chargeController.text = _formatInput(charge);
    }
  }

  void _setMode(_VariableEntryMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
  }

  void _applyPresetMeasure(double value) {
    _mode = _VariableEntryMode.byMeasure;
    _measureController.text = _formatInput(value);
    _onMeasureChanged();
    setState(() {});
  }

  void _applyPresetAmount(double value) {
    _mode = _VariableEntryMode.byAmount;
    _amountController.text = _formatInput(value);
    _onAmountChanged();
    setState(() {});
  }

  void _submit() {
    final baseUnits = _mode == _VariableEntryMode.byAmount
        ? MeasureUnits.amountToBaseUnits(
            amountRs: _amountValue ?? 0,
            pricePerDisplayUnit: product.sellingPrice,
            unit: _displayUnit,
            sellType: sellType,
          )
        : _baseUnitsFromMeasure;
    if (baseUnits <= 0) {
      setState(() => _error = 'Enter a valid quantity or Rs amount.');
      return;
    }
    if (baseUnits > widget.availableStockBaseUnits) {
      setState(
        () => _error =
            'Only ${MeasureUnits.formatStock(widget.availableStockBaseUnits, product.unit, sellType)} available.',
      );
      return;
    }

    final charge = _chargeValue ?? _computedCharge;
    if (charge <= 0) {
      setState(() => _error = 'Enter a valid charge in Rs.');
      return;
    }

    final computed = _computedCharge;
    final override = (charge - computed).abs() > 0.01 ? charge : null;
    final label = _mode == _VariableEntryMode.byAmount
        ? MeasureUnits.amountWorthLabel(_amountValue ?? charge)
        : MeasureUnits.formatQuantity(baseUnits, _displayUnit, sellType);

    Navigator.of(context).pop(
      VariableSaleResult(
        quantityBaseUnits: baseUnits,
        quantityLabel: label,
        overrideLineTotal: override,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    const presets = [0.25, 0.5, 1.0];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${product.formattedRate} · '
                      '${MeasureUnits.formatStock(widget.availableStockBaseUnits, product.unit, sellType)} left',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Symbols.close),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<_VariableEntryMode>(
            segments: const [
              ButtonSegment(
                value: _VariableEntryMode.byMeasure,
                label: Text('By weight/volume'),
              ),
              ButtonSegment(
                value: _VariableEntryMode.byAmount,
                label: Text('By Rs amount'),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (values) => _setMode(values.first),
          ),
          const SizedBox(height: AppSpacing.md),
          if (_mode == _VariableEntryMode.byMeasure) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _measureController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: FieldLimits.decimalQty,
                    decoration: InputDecoration(
                      labelText: sellType == SellType.volume
                          ? 'Volume'
                          : 'Weight',
                      border: OutlineInputBorder(
                        borderRadius: AppRadii.smAll,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownMenu<String>(
                  initialSelection: _displayUnit,
                  dropdownMenuEntries: _unitOptions
                      .map(
                        (unit) => DropdownMenuEntry(value: unit, label: unit),
                      )
                      .toList(),
                  onSelected: (value) {
                    if (value == null) return;
                    setState(() => _displayUnit = value);
                    _onMeasureChanged();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              children: [
                for (final preset in presets)
                  ActionChip(
                    label: Text('$preset $_displayUnit'),
                    onPressed: () => _applyPresetMeasure(preset),
                  ),
              ],
            ),
          ] else ...[
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: FieldLimits.money,
              decoration: InputDecoration(
                labelText: 'Amount (Rs)',
                prefixText: 'Rs ',
                border: OutlineInputBorder(borderRadius: AppRadii.smAll),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text('Rs 100'),
                  onPressed: () => _applyPresetAmount(100),
                ),
                ActionChip(
                  label: const Text('Rs 200'),
                  onPressed: () => _applyPresetAmount(200),
                ),
                ActionChip(
                  label: const Text('Rs 500'),
                  onPressed: () => _applyPresetAmount(500),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _chargeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: FieldLimits.money,
            decoration: InputDecoration(
              labelText: 'Charge (Rs)',
              prefixText: 'Rs ',
              helperText: _computedCharge > 0
                  ? 'Calculated: ${CurrencyFormatter.format(_computedCharge, precise: true)}'
                  : null,
              border: OutlineInputBorder(borderRadius: AppRadii.smAll),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(label: 'Add to cart', onPressed: _submit),
        ],
      ),
    );
  }

  List<String> get _unitOptions {
    if (sellType == SellType.weight) return const ['kg', 'g'];
    if (sellType == SellType.volume) return const ['L', 'ml'];
    return [product.unit ?? 'pcs'];
  }
}
