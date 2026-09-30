import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../utils/supplier_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';

enum SupplierBalanceAction { give, take }

class SupplierBalanceResult {
  const SupplierBalanceResult({
    required this.action,
    required this.amount,
    this.note,
  });

  final SupplierBalanceAction action;
  final double amount;
  final String? note;

  /// Give = shop owes more. Take = supplier credit / we collect.
  double get amountChange =>
      action == SupplierBalanceAction.give ? amount : -amount;
}

Future<SupplierBalanceResult?> showSupplierBalanceSheet({
  required BuildContext context,
  required String supplierName,
  required double balance,
  required double invoiceDue,
}) {
  return showDialog<SupplierBalanceResult>(
    context: context,
    builder: (context) => _SupplierBalanceDialog(
      supplierName: supplierName,
      balance: KhataBalanceRules.money(balance),
      invoiceDue: KhataBalanceRules.money(invoiceDue),
    ),
  );
}

class _SupplierBalanceDialog extends StatefulWidget {
  const _SupplierBalanceDialog({
    required this.supplierName,
    required this.balance,
    required this.invoiceDue,
  });

  final String supplierName;
  final double balance;
  final double invoiceDue;

  @override
  State<_SupplierBalanceDialog> createState() => _SupplierBalanceDialogState();
}

class _SupplierBalanceDialogState extends State<_SupplierBalanceDialog> {
  SupplierBalanceAction _action = SupplierBalanceAction.give;
  final _amount = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  double get _netNow => widget.invoiceDue + widget.balance;

  double get _previewNet {
    final value = double.tryParse(_amount.text.trim()) ?? 0;
    if (value <= 0) return _netNow;
    return _netNow +
        (_action == SupplierBalanceAction.give ? value : -value);
  }

  void _submit() {
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid amount.');
      return;
    }
    Navigator.of(context).pop(
      SupplierBalanceResult(
        action: _action,
        amount: value,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nowColor = KhataBalanceRules.colorForSupplier(_netNow);
    final previewColor = KhataBalanceRules.colorForSupplier(_previewNet);
    return AlertDialog(
      title: const Text('Give / Take'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.supplierName),
            Text(
              KhataBalanceRules.supplierNetLabel(_netNow),
              style: theme.textTheme.titleMedium?.copyWith(
                color: nowColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<SupplierBalanceAction>(
              segments: [
                ButtonSegment(
                  value: SupplierBalanceAction.give,
                  label: Text(
                    'Give',
                    style: TextStyle(
                      color: _action == SupplierBalanceAction.give
                          ? Colors.white
                          : KhataBalanceRules.giveColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ButtonSegment(
                  value: SupplierBalanceAction.take,
                  label: Text(
                    'Take',
                    style: TextStyle(
                      color: _action == SupplierBalanceAction.take
                          ? Colors.white
                          : KhataBalanceRules.takeColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              selected: {_action},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (!states.contains(WidgetState.selected)) {
                    return null;
                  }
                  return _action == SupplierBalanceAction.give
                      ? KhataBalanceRules.giveColor
                      : KhataBalanceRules.takeColor;
                }),
              ),
              onSelectionChanged: (value) {
                setState(() => _action = value.first);
              },
            ),
            const SizedBox(height: 8),
            Text(
              _action == SupplierBalanceAction.give
                  ? 'Shop needs to give this to the supplier.'
                  : 'Shop will take / collect this from the supplier.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _action == SupplierBalanceAction.give
                    ? KhataBalanceRules.giveColor
                    : KhataBalanceRules.takeColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _amount,
              label: 'Amount',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(controller: _note, label: 'Note (optional)'),
            if ((double.tryParse(_amount.text.trim()) ?? 0) > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'After save: ${KhataBalanceRules.supplierNetLabel(_previewNet)}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: previewColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: _action == SupplierBalanceAction.give ? 'Save give' : 'Save take',
          icon: Symbols.payments,
          onPressed: _submit,
        ),
      ],
    );
  }
}
