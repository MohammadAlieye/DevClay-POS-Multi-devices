import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../database/collections/account.dart';
import '../../../../database/collections/cash_shift.dart';
import '../../../../services/retail/retail_control_service.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/user_facing_error.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';

Future<void> showPosShiftSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    constraints: const BoxConstraints(maxWidth: 560),
    builder: (_) => const _PosShiftSheet(),
  );
}

class _PosShiftSheet extends StatefulWidget {
  const _PosShiftSheet();

  @override
  State<_PosShiftSheet> createState() => _PosShiftSheetState();
}

class _PosShiftSheetState extends State<_PosShiftSheet> {
  final _cash = TextEditingController();
  final _note = TextEditingController();
  late Future<(CashShift?, List<Account>, ShiftPolicy)> _data;
  int? _accountId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  Future<(CashShift?, List<Account>, ShiftPolicy)> _load() async {
    final service = sl<RetailControlService>();
    final shift = await service.activeShift();
    final accounts = await service.cashAccounts();
    final policy = await service.shiftPolicy();
    _accountId ??= accounts
        .where((account) => account.isDefault)
        .firstOrNull
        ?.id;
    _accountId ??= accounts.firstOrNull?.id;
    return (shift, accounts, policy);
  }

  Future<void> _setRequired(bool value) async {
    try {
      await sl<RetailControlService>().setShiftRequired(value);
      if (!mounted) return;
      setState(() {
        _data = _load();
      });
      AppToast.success(
        context,
        value
            ? 'Cashier shifts are now required'
            : 'Cashier shifts are optional',
      );
    } catch (error) {
      if (mounted) AppToast.show(context, userFacingError(error));
    }
  }

  @override
  void dispose() {
    _cash.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit(CashShift? shift) async {
    final cash = double.tryParse(_cash.text.trim());
    if (cash == null || cash < 0) {
      AppToast.show(context, 'Enter a valid cash amount.');
      return;
    }
    setState(() => _saving = true);
    try {
      final service = sl<RetailControlService>();
      if (shift == null) {
        await service.openShift(
          openingCash: cash,
          cashAccountId: _accountId,
          note: _note.text,
        );
        if (mounted) AppToast.success(context, 'Cashier shift opened');
      } else {
        final closed = await service.closeShift(
          shiftId: shift.id,
          closingCash: cash,
          note: _note.text,
        );
        if (mounted) {
          AppToast.success(
            context,
            'Shift closed · variance ${CurrencyFormatter.format(closed.variance ?? 0)}',
          );
        }
      }
      if (mounted) Navigator.of(context).pop();
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
        child: FutureBuilder<(CashShift?, List<Account>, ShiftPolicy)>(
          future: _data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final shift = snapshot.data!.$1;
            final accounts = snapshot.data!.$2;
            final policy = snapshot.data!.$3;
            final closing = shift != null;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      closing ? Symbols.lock_clock : Symbols.point_of_sale,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      closing ? 'Close cashier shift' : 'Open cashier shift',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  closing
                      ? 'Opened ${shift.userName} · ${CurrencyFormatter.format(shift.openingCash)} opening cash'
                      : 'Count the cash currently in the drawer before serving customers.',
                  style: theme.textTheme.bodyMedium,
                ),
                if (policy.canConfigure) ...[
                  const SizedBox(height: AppSpacing.md),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Require cashier shifts'),
                    subtitle: const Text(
                      'Optional when off. Turn on only when you want opening and closing cash tally.',
                    ),
                    value: policy.required,
                    onChanged: _setRequired,
                  ),
                ] else if (!policy.required) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Shift tally is optional. You can sell normally without opening one.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                if (!closing && accounts.isNotEmpty) ...[
                  DropdownButtonFormField<int>(
                    initialValue: _accountId,
                    decoration: const InputDecoration(
                      labelText: 'Cash drawer account',
                    ),
                    items: accounts
                        .map(
                          (account) => DropdownMenuItem(
                            value: account.id,
                            child: Text(account.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _accountId = value),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                TextField(
                  controller: _cash,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: FieldLimits.money,
                  decoration: InputDecoration(
                    labelText: closing
                        ? 'Counted closing cash'
                        : 'Opening cash',
                    prefixText: 'Rs ',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _note,
                  decoration: const InputDecoration(
                    labelText: 'Shift note (optional)',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: closing
                      ? 'Close shift & calculate variance'
                      : 'Open shift',
                  icon: closing ? Symbols.calculate : Symbols.play_arrow,
                  isLoading: _saving,
                  onPressed: _saving ? null : () => _submit(shift),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
