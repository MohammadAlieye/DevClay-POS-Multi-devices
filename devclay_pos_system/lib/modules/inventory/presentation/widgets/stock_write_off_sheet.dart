import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../services/retail/retail_control_service.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/measure_units.dart';
import '../../../../utils/user_facing_error.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/inventory_entities.dart';

Future<bool> showStockWriteOffSheet(
  BuildContext context, {
  required InventoryProduct product,
}) async {
  return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: const BoxConstraints(maxWidth: 520),
        builder: (_) => _StockWriteOffSheet(product: product),
      ) ??
      false;
}

class _StockWriteOffSheet extends StatefulWidget {
  const _StockWriteOffSheet({required this.product});

  final InventoryProduct product;

  @override
  State<_StockWriteOffSheet> createState() => _StockWriteOffSheetState();
}

class _StockWriteOffSheetState extends State<_StockWriteOffSheet> {
  final _quantity = TextEditingController(text: '1');
  final _note = TextEditingController();
  String _reason = 'damaged';
  bool _saving = false;

  @override
  void dispose() {
    _quantity.dispose();
    _note.dispose();
    super.dispose();
  }

  int? _enteredBaseQuantity() {
    if (widget.product.isVariable) {
      final display = MeasureUnits.parseDecimalInput(_quantity.text);
      if (display == null || display <= 0) return null;
      return MeasureUnits.toBaseUnits(
        display,
        widget.product.unit,
        widget.product.sellType,
      );
    }
    return int.tryParse(_quantity.text.trim());
  }

  Future<void> _submit() async {
    final quantity = _enteredBaseQuantity();
    if (quantity == null ||
        quantity <= 0 ||
        quantity > widget.product.stock) {
      AppToast.show(
        context,
        'Enter a quantity up to ${widget.product.formattedStock}.',
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await sl<RetailControlService>().writeOffStock(
        productId: widget.product.id,
        quantity: quantity,
        reason: _reason,
        note: _note.text,
      );
      if (!mounted) return;
      AppToast.success(context, 'Stock write-off recorded');
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) AppToast.show(context, userFacingError(error));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.product.unit?.trim().isNotEmpty == true
        ? widget.product.unit!.trim()
        : 'pcs';
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Damaged / wasted stock',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${widget.product.name} · ${widget.product.formattedStock} available',
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              initialValue: _reason,
              decoration: const InputDecoration(labelText: 'Reason'),
              items: const [
                DropdownMenuItem(value: 'damaged', child: Text('Damaged')),
                DropdownMenuItem(value: 'wastage', child: Text('Wastage')),
                DropdownMenuItem(
                  value: 'theft',
                  child: Text('Missing / theft'),
                ),
                DropdownMenuItem(
                  value: 'expired',
                  child: Text('Expired disposal'),
                ),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (value) => setState(() => _reason = value ?? 'other'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _quantity,
              keyboardType: TextInputType.numberWithOptions(
                decimal: widget.product.isVariable,
              ),
              inputFormatters: widget.product.isVariable
                  ? FieldLimits.decimalQty
                  : FieldLimits.stockQty,
              decoration: InputDecoration(
                labelText: 'Quantity ($unit)',
                hintText: widget.product.isVariable ? 'e.g. 1 or 0.5' : null,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Note / reference (optional)',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Record write-off',
              icon: Symbols.delete_sweep,
              variant: AppButtonVariant.danger,
              isLoading: _saving,
              onPressed: _saving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
