import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../modules/pos/presentation/widgets/manager_approval_dialog.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/user_facing_error.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/sale_entities.dart';
import '../../domain/repositories/sales_repository.dart';

Future<bool> showSaleReturnSheet(
  BuildContext context, {
  required SaleRecord sale,
  bool voidSale = false,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
    builder: (_) => _SaleReturnSheet(sale: sale, voidSale: voidSale),
  );
  return result ?? false;
}

class _SaleReturnSheet extends StatefulWidget {
  const _SaleReturnSheet({required this.sale, required this.voidSale});

  final SaleRecord sale;
  final bool voidSale;

  @override
  State<_SaleReturnSheet> createState() => _SaleReturnSheetState();
}

class _SaleReturnSheetState extends State<_SaleReturnSheet> {
  late final List<TextEditingController> _quantities;
  final _reason = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _quantities = widget.sale.lines
        .map(
          (line) => TextEditingController(
            text: widget.voidSale ? '${line.quantity}' : '0',
          ),
        )
        .toList();
    if (widget.voidSale) _reason.text = 'Sale entered incorrectly';
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
    final lines = <SaleReturnLineRequest>[];
    for (var i = 0; i < widget.sale.lines.length; i++) {
      final quantity = int.tryParse(_quantities[i].text.trim()) ?? 0;
      if (quantity < 0 || quantity > widget.sale.lines[i].quantity) {
        AppToast.show(
          context,
          'Invalid quantity for ${widget.sale.lines[i].productName}.',
        );
        return;
      }
      if (quantity > 0) {
        lines.add(
          SaleReturnLineRequest(
            productId: widget.sale.lines[i].productId,
            quantity: quantity,
          ),
        );
      }
    }
    if (lines.isEmpty) {
      AppToast.show(context, 'Select at least one item to return.');
      return;
    }
    if (_reason.text.trim().isEmpty) {
      AppToast.show(context, 'Enter a return or void reason.');
      return;
    }

    final supervisor = await requestManagerApproval(
      context,
      action: widget.voidSale
          ? 'Approve voiding ${widget.sale.invoiceNo}.'
          : 'Approve customer return for ${widget.sale.invoiceNo}.',
    );
    if (supervisor == null || !mounted) return;
    setState(() => _saving = true);
    try {
      final result = await sl<SalesRepository>().processReturn(
        SaleReturnRequest(
          saleId: widget.sale.id,
          lines: lines,
          reason: _reason.text,
          approvedById: supervisor.id,
          approvedByName: supervisor.name,
          isVoid: widget.voidSale,
        ),
      );
      if (!mounted) return;
      AppToast.success(
        context,
        '${widget.voidSale ? 'Sale voided' : 'Return completed'} · '
        '${CurrencyFormatter.format(result.refundAmount)}',
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) AppToast.show(context, userFacingError(error));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              widget.voidSale ? 'Void completed sale' : 'Customer return',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              '${widget.sale.invoiceNo} · ${widget.sale.customerName} · '
              '${CurrencyFormatter.format(widget.sale.refundableAmount)} refundable',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.sale.lines.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final line = widget.sale.lines[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(line.productName),
                    subtitle: Text(
                      '${line.productSku} · Sold ${line.quantity} · '
                      '${CurrencyFormatter.format(line.lineTotal)}'
                      '${line.itemsPerBox > 1 ? ' · 1 box = ${line.itemsPerBox}' : ''}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!widget.voidSale && line.itemsPerBox > 1)
                          TextButton(
                            onPressed: () {
                              final current =
                                  int.tryParse(_quantities[index].text) ?? 0;
                              final next = (current + line.itemsPerBox).clamp(
                                0,
                                line.quantity,
                              );
                              setState(() {
                                _quantities[index].text = '$next';
                              });
                            },
                            child: const Text('+ Box'),
                          ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _quantities[index],
                            enabled: !widget.voidSale,
                            keyboardType: TextInputType.number,
                            inputFormatters: FieldLimits.stockQty,
                            decoration: const InputDecoration(
                              labelText: 'Return',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _reason,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: widget.voidSale ? 'Void reason' : 'Return reason',
                hintText: widget.voidSale
                    ? 'Wrong payment, duplicate sale…'
                    : 'Damaged, wrong item, customer changed mind…',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: widget.voidSale
                  ? 'Approve & void sale'
                  : 'Approve & refund',
              icon: widget.voidSale
                  ? Symbols.cancel
                  : Symbols.assignment_return,
              variant: widget.voidSale
                  ? AppButtonVariant.danger
                  : AppButtonVariant.primary,
              isLoading: _saving,
              onPressed: _saving ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
