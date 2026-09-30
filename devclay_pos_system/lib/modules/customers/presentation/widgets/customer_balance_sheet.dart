import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';

enum CustomerBalanceAction { receivePayment, addDue }

class CustomerBalanceResult {
  const CustomerBalanceResult({
    required this.action,
    required this.amount,
    this.note,
  });

  final CustomerBalanceAction action;
  final double amount;
  final String? note;
}

Future<CustomerBalanceResult?> showCustomerBalanceSheet({
  required BuildContext context,
  required String customerName,
  required double balance,
}) {
  return showDialog<CustomerBalanceResult>(
    context: context,
    builder: (context) =>
        _CustomerBalanceDialog(customerName: customerName, balance: balance),
  );
}

class _CustomerBalanceDialog extends StatefulWidget {
  const _CustomerBalanceDialog({
    required this.customerName,
    required this.balance,
  });

  final String customerName;
  final double balance;

  @override
  State<_CustomerBalanceDialog> createState() => _CustomerBalanceDialogState();
}

class _CustomerBalanceDialogState extends State<_CustomerBalanceDialog> {
  CustomerBalanceAction _action = CustomerBalanceAction.receivePayment;
  final _amount = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid amount.');
      return;
    }
    Navigator.of(context).pop(
      CustomerBalanceResult(
        action: _action,
        amount: value,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update balance'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.customerName),
            Text(
              KhataBalanceRules.detailLabel(widget.balance),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: KhataBalanceRules.colorFor(widget.balance),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<CustomerBalanceAction>(
              segments: const [
                ButtonSegment(
                  value: CustomerBalanceAction.receivePayment,
                  label: Text('Take payment'),
                ),
                ButtonSegment(
                  value: CustomerBalanceAction.addDue,
                  label: Text('Give / Add balance'),
                ),
              ],
              selected: {_action},
              onSelectionChanged: (value) {
                setState(() => _action = value.first);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _amount,
              label: 'Amount',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(controller: _note, label: 'Note (optional)'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(label: 'Save', icon: Symbols.payments, onPressed: _submit),
      ],
    );
  }
}
