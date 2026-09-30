import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';

Future<double?> showPurchasePaymentSheet({
  required BuildContext context,
  required String invoiceNo,
  required double dueAmount,
}) {
  return showDialog<double>(
    context: context,
    builder: (context) => _PurchasePaymentDialog(
      title: 'Record payment',
      subtitle: 'Invoice $invoiceNo',
      dueAmount: dueAmount,
    ),
  );
}

Future<double?> showSupplierPaymentSheet({
  required BuildContext context,
  required String supplierName,
  required double dueAmount,
  int openInvoiceCount = 1,
  double? openingBalanceDue,
}) {
  final hints = <String>[];
  if (openingBalanceDue != null && openingBalanceDue > 0.009) {
    hints.add(
      'Opening balance ${CurrencyFormatter.format(openingBalanceDue)} is paid first.',
    );
  }
  if (openInvoiceCount > 1) {
    hints.add('Remaining amount is applied to oldest invoices first.');
  } else if (openInvoiceCount == 1 && openingBalanceDue == null) {
    hints.add('Applied to the open invoice.');
  }

  return showDialog<double>(
    context: context,
    builder: (context) => _PurchasePaymentDialog(
      title: 'Give to supplier',
      subtitle: openInvoiceCount <= 1
          ? supplierName
          : '$supplierName · $openInvoiceCount open invoices',
      dueAmount: dueAmount,
      allocateHint: hints.isEmpty ? null : hints.join(' '),
    ),
  );
}

class _PurchasePaymentDialog extends StatefulWidget {
  const _PurchasePaymentDialog({
    required this.title,
    required this.subtitle,
    required this.dueAmount,
    this.allocateHint,
  });

  final String title;
  final String subtitle;
  final double dueAmount;
  final String? allocateHint;

  @override
  State<_PurchasePaymentDialog> createState() => _PurchasePaymentDialogState();
}

class _PurchasePaymentDialogState extends State<_PurchasePaymentDialog> {
  late final TextEditingController _amount;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: _formatAmount(widget.dueAmount));
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  void _setAmount(double value) {
    setState(() => _amount.text = _formatAmount(value));
  }

  void _submit() {
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid custom amount.');
      return;
    }
    if (value > widget.dueAmount + 0.009) {
      AppToast.show(
        context,
        'Amount cannot exceed ${CurrencyFormatter.format(widget.dueAmount)}.',
      );
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final half = widget.dueAmount / 2;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.subtitle),
            Text(
              KhataBalanceRules.payableLabel(widget.dueAmount),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: KhataBalanceRules.colorForPayable(widget.dueAmount),
              ),
            ),
            if (widget.allocateHint != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(widget.allocateHint!, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _amount,
              label: 'Custom amount',
              hintText: 'Enter any amount up to give',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                ActionChip(
                  label: const Text('Full give'),
                  onPressed: () => _setAmount(widget.dueAmount),
                ),
                if (half >= 1)
                  ActionChip(
                    label: Text('Half (${CurrencyFormatter.format(half)})'),
                    onPressed: () => _setAmount(half),
                  ),
                ActionChip(
                  label: const Text('Clear'),
                  onPressed: () {
                    _amount.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Record payment',
          icon: Symbols.payments,
          onPressed: _submit,
        ),
      ],
    );
  }
}
