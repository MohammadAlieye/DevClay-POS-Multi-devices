import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/user_facing_error.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/purchase_entities.dart';
import '../../domain/repositories/purchases_repository.dart';

Future<bool> showPurchaseReturnSheet(
  BuildContext context,
  PurchaseRecord purchase,
) async {
  return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
        builder: (_) => _PurchaseReturnSheet(purchase: purchase),
      ) ??
      false;
}

class _PurchaseReturnSheet extends StatefulWidget {
  const _PurchaseReturnSheet({required this.purchase});

  final PurchaseRecord purchase;

  @override
  State<_PurchaseReturnSheet> createState() => _PurchaseReturnSheetState();
}

class _PurchaseReturnSheetState extends State<_PurchaseReturnSheet> {
  late final List<TextEditingController> _quantities;
  final _reason = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _quantities = widget.purchase.lines
        .map((_) => TextEditingController(text: '0'))
        .toList();
  }

  @override
  void dispose() {
    for (final controller in _quantities) {
      controller.dispose();
    }
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final lines = <PurchaseReturnLineRequest>[];
    for (var i = 0; i < widget.purchase.lines.length; i++) {
      final quantity = int.tryParse(_quantities[i].text.trim()) ?? 0;
      final line = widget.purchase.lines[i];
      if (quantity < 0 || quantity > line.quantity) {
        AppToast.show(context, 'Invalid quantity for ${line.productName}.');
        return;
      }
      if (quantity > 0) {
        lines.add(
          PurchaseReturnLineRequest(
            productId: line.productId,
            quantity: quantity,
          ),
        );
      }
    }
    if (lines.isEmpty || _reason.text.trim().isEmpty) {
      AppToast.show(context, 'Select items and enter a return reason.');
      return;
    }
    setState(() => _saving = true);
    try {
      final total = await sl<PurchasesRepository>().processPurchaseReturn(
        PurchaseReturnRequest(
          purchaseId: widget.purchase.id,
          lines: lines,
          reason: _reason.text,
        ),
      );
      if (!mounted) return;
      AppToast.success(
        context,
        'Supplier return recorded · ${CurrencyFormatter.format(total)}',
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) AppToast.show(context, userFacingError(error));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              'Return to supplier',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${widget.purchase.invoiceNo} · ${widget.purchase.supplierName}',
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.purchase.lines.length,
                itemBuilder: (context, index) {
                  final line = widget.purchase.lines[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(line.productName),
                    subtitle: Text(
                      'Received ${line.quantity} · ${CurrencyFormatter.format(line.unitCost)} each',
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _quantities[index],
                        keyboardType: TextInputType.number,
                        inputFormatters: FieldLimits.stockQty,
                        decoration: const InputDecoration(labelText: 'Return'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _reason,
              decoration: const InputDecoration(
                labelText: 'Reason',
                hintText: 'Damaged, wrong item, expired delivery…',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Record supplier return',
              icon: Symbols.undo,
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
