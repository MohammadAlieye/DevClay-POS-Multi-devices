import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../domain/entities/finance_entities.dart';

Future<FinanceMovementDraft?> showFinanceMovementSheet({
  required BuildContext context,
  required FinanceMovementKind kind,
  required List<FinanceAccountOption> accounts,
}) {
  return showDialog<FinanceMovementDraft>(
    context: context,
    builder: (context) => _MovementDialog(kind: kind, accounts: accounts),
  );
}

class _MovementDialog extends StatefulWidget {
  const _MovementDialog({required this.kind, required this.accounts});

  final FinanceMovementKind kind;
  final List<FinanceAccountOption> accounts;

  @override
  State<_MovementDialog> createState() => _MovementDialogState();
}

class _MovementDialogState extends State<_MovementDialog> {
  int? _accountId;
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.accounts.isNotEmpty) {
      _accountId = widget.accounts.first.id;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    if (_accountId == null) {
      AppToast.show(context, 'Select an account.');
      return;
    }
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid amount.');
      return;
    }
    Navigator.pop(
      context,
      FinanceMovementDraft(
        kind: widget.kind,
        accountId: _accountId!,
        amount: value,
        reference: _reference.text,
        note: _note.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.kind.label),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.accounts.isEmpty)
                const Text('Add a cash/bank account in Accounts first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  decoration: InputDecoration(
                    labelText: widget.kind.isExpense
                        ? 'Paid from'
                        : 'Received in',
                  ),
                  items: widget.accounts
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            '${a.name} · ${CurrencyFormatter.format(a.balance)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _accountId = v),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _amount,
                label: 'Amount (Rs)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _reference,
                label: 'Reference (optional)',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _note,
                label: 'Note (optional)',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Save',
          icon: Symbols.save,
          onPressed: widget.accounts.isEmpty ? null : _submit,
        ),
      ],
    );
  }
}

Future<EmployeeDraft?> showEmployeeEditorSheet({
  required BuildContext context,
  EmployeeItem? existing,
}) {
  return showDialog<EmployeeDraft>(
    context: context,
    builder: (context) => _EmployeeDialog(existing: existing),
  );
}

class _EmployeeDialog extends StatefulWidget {
  const _EmployeeDialog({this.existing});

  final EmployeeItem? existing;

  @override
  State<_EmployeeDialog> createState() => _EmployeeDialogState();
}

class _EmployeeDialogState extends State<_EmployeeDialog> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _designation;
  late final TextEditingController _salary;
  late final TextEditingController _notes;
  late bool _isActive;
  DateTime? _joinedAt;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _designation = TextEditingController(text: e?.designation ?? '');
    _salary = TextEditingController(
      text: e == null ? '' : e.monthlySalary.toStringAsFixed(0),
    );
    _notes = TextEditingController(text: e?.notes ?? '');
    _isActive = e?.isActive ?? true;
    _joinedAt = e?.joinedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _designation.dispose();
    _salary.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    final salary = double.tryParse(_salary.text.trim());
    if (_name.text.trim().isEmpty) {
      AppToast.show(context, 'Enter employee name.');
      return;
    }
    if (salary == null || salary < 0) {
      AppToast.show(context, 'Enter a valid monthly salary.');
      return;
    }
    Navigator.pop(
      context,
      EmployeeDraft(
        name: _name.text,
        phone: _phone.text,
        designation: _designation.text,
        monthlySalary: salary,
        joinedAt: _joinedAt,
        notes: _notes.text,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit employee' : 'Add employee'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _name,
                label: 'Full name',
                hintText: 'e.g. Ahmed Khan',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _designation,
                label: 'Designation',
                hintText: 'Cashier, Cook, Manager…',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _phone,
                label: 'Phone (optional)',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _salary,
                label: 'Monthly salary (Rs)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Joined date'),
                subtitle: Text(
                  _joinedAt == null
                      ? 'Not set'
                      : DateFormat('d MMM yyyy').format(_joinedAt!),
                ),
                trailing: const Icon(Symbols.calendar_month),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _joinedAt ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _joinedAt = picked);
                },
              ),
              AppTextField(
                controller: _notes,
                label: 'Notes (optional)',
              ),
              if (isEdit)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: isEdit ? 'Save' : 'Add employee',
          icon: Symbols.person_add,
          onPressed: _submit,
        ),
      ],
    );
  }
}

Future<SalaryPayDraft?> showSalaryPaySheet({
  required BuildContext context,
  required EmployeeItem employee,
  required List<FinanceAccountOption> accounts,
}) {
  return showDialog<SalaryPayDraft>(
    context: context,
    builder: (context) => _SalaryDialog(
      employee: employee,
      accounts: accounts,
    ),
  );
}

class _SalaryDialog extends StatefulWidget {
  const _SalaryDialog({required this.employee, required this.accounts});

  final EmployeeItem employee;
  final List<FinanceAccountOption> accounts;

  @override
  State<_SalaryDialog> createState() => _SalaryDialogState();
}

class _SalaryDialogState extends State<_SalaryDialog> {
  int? _accountId;
  late final TextEditingController _amount;
  late final TextEditingController _days;
  late final TextEditingController _reference;
  final _note = TextEditingController();
  _SalaryPeriod _period = _SalaryPeriod.fullMonth;

  bool _includeCommission = false;
  _SalaryCommissionMode _commissionMode = _SalaryCommissionMode.perSale;
  final _salesCount = TextEditingController(text: '7');
  final _commissionPerSale = TextEditingController();
  final _commissionFixed = TextEditingController();
  final _salesTotal = TextEditingController();
  final _commissionPercent = TextEditingController(text: '5');

  double get _monthly => widget.employee.monthlySalary;

  int get _daysInMonth {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }

  double get _dailyRate => _monthly / _daysInMonth;

  int get _parsedDays {
    final days = int.tryParse(_days.text.trim()) ?? 0;
    return days.clamp(0, 31);
  }

  double get _calculatedAmount => switch (_period) {
        _SalaryPeriod.fullMonth => _monthly,
        _SalaryPeriod.halfMonth => _monthly / 2,
        _SalaryPeriod.days => _dailyRate * _parsedDays,
        _SalaryPeriod.custom => double.tryParse(_amount.text.trim()) ?? 0,
      };

  double get _baseSalary => _period == _SalaryPeriod.custom
      ? (double.tryParse(_amount.text.trim()) ?? 0)
      : _calculatedAmount;

  int get _parsedSalesCount => int.tryParse(_salesCount.text.trim()) ?? 0;

  double get _parsedPerSale =>
      double.tryParse(_commissionPerSale.text.trim()) ?? 0;

  double get _parsedSalesTotal => double.tryParse(_salesTotal.text.trim()) ?? 0;

  double get _parsedPercent =>
      double.tryParse(_commissionPercent.text.trim()) ?? 0;

  double get _commissionAmount {
    if (!_includeCommission) return 0;
    return switch (_commissionMode) {
      _SalaryCommissionMode.perSale =>
        _parsedSalesCount * _parsedPerSale,
      _SalaryCommissionMode.fixedTotal =>
        double.tryParse(_commissionFixed.text.trim()) ?? 0,
      _SalaryCommissionMode.percentOfSales =>
        (_parsedSalesTotal * _parsedPercent / 100).clamp(0, 999999999),
    };
  }

  double get _totalPay => _baseSalary + _commissionAmount;

  String get _monthLabel => DateFormat('MMM yyyy').format(DateTime.now());

  String _amountLabel(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  void _syncAmountFromPeriod() {
    if (_period == _SalaryPeriod.custom) return;
    _amount.text = _amountLabel(_calculatedAmount);
    _reference.text = switch (_period) {
      _SalaryPeriod.fullMonth => 'Salary · Full month · $_monthLabel',
      _SalaryPeriod.halfMonth => 'Salary · Half month · $_monthLabel',
      _SalaryPeriod.days =>
        'Salary · $_parsedDays day${_parsedDays == 1 ? '' : 's'} · $_monthLabel',
      _SalaryPeriod.custom => 'Salary · Custom · $_monthLabel',
    };
  }

  void _applyPeriod(_SalaryPeriod period) {
    setState(() {
      _period = period;
      if (period == _SalaryPeriod.days && _days.text.trim().isEmpty) {
        _days.text = '5';
      }
      _syncAmountFromPeriod();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.accounts.isNotEmpty) {
      _accountId = widget.accounts.first.id;
    }
    _days = TextEditingController(text: '5');
    _amount = TextEditingController(text: _amountLabel(_monthly));
    _reference = TextEditingController(
      text: 'Salary · Full month · $_monthLabel',
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    _days.dispose();
    _reference.dispose();
    _note.dispose();
    _salesCount.dispose();
    _commissionPerSale.dispose();
    _commissionFixed.dispose();
    _salesTotal.dispose();
    _commissionPercent.dispose();
    super.dispose();
  }

  void _submit() {
    if (_accountId == null) {
      AppToast.show(context, 'Select an account.');
      return;
    }
    if (_period == _SalaryPeriod.days && _parsedDays <= 0) {
      AppToast.show(context, 'Enter number of days (1–31).');
      return;
    }
    final base = _baseSalary;
    if (base <= 0) {
      AppToast.show(context, 'Enter a valid base salary.');
      return;
    }
    if (_includeCommission) {
      if (_commissionMode == _SalaryCommissionMode.perSale) {
        if (_parsedSalesCount <= 0) {
          AppToast.show(context, 'Enter number of sales.');
          return;
        }
        if (_parsedPerSale <= 0) {
          AppToast.show(context, 'Enter commission per sale.');
          return;
        }
      } else if (_commissionMode == _SalaryCommissionMode.fixedTotal) {
        if (_commissionAmount <= 0) {
          AppToast.show(context, 'Enter commission amount.');
          return;
        }
      } else {
        if (_parsedSalesTotal <= 0) {
          AppToast.show(context, 'Enter total sales amount.');
          return;
        }
        if (_parsedPercent <= 0) {
          AppToast.show(context, 'Enter commission percentage.');
          return;
        }
        if (_commissionAmount <= 0) {
          AppToast.show(context, 'Calculated commission must be greater than zero.');
          return;
        }
      }
    }
    final commission = _commissionAmount;
    final total = base + commission;
    if (total <= 0) {
      AppToast.show(context, 'Total payment must be greater than zero.');
      return;
    }

    String? autoNote;
    if (commission > 0) {
      autoNote = switch (_commissionMode) {
        _SalaryCommissionMode.perSale =>
          'Base ${CurrencyFormatter.format(base)} + '
              'commission ${CurrencyFormatter.format(commission)} '
              '($_parsedSalesCount sale${_parsedSalesCount == 1 ? '' : 's'} '
              '× ${CurrencyFormatter.format(_parsedPerSale)})',
        _SalaryCommissionMode.fixedTotal =>
          'Base ${CurrencyFormatter.format(base)} + '
              'commission ${CurrencyFormatter.format(commission)}',
        _SalaryCommissionMode.percentOfSales =>
          'Base ${CurrencyFormatter.format(base)} + '
              'commission ${CurrencyFormatter.format(commission)} '
              '(${_amountLabel(_parsedPercent)}% of '
              '${CurrencyFormatter.format(_parsedSalesTotal)})',
      };
    }

    Navigator.pop(
      context,
      SalaryPayDraft(
        employeeId: widget.employee.id,
        accountId: _accountId!,
        baseAmount: base,
        commissionAmount: commission,
        salesCount: _includeCommission && _parsedSalesCount > 0
            ? _parsedSalesCount
            : null,
        reference: _reference.text,
        note: _note.text.trim().isEmpty
            ? autoNote ??
                switch (_period) {
                  _SalaryPeriod.fullMonth => 'Full month salary',
                  _SalaryPeriod.halfMonth => 'Half month salary',
                  _SalaryPeriod.days =>
                    'Salary for $_parsedDays day${_parsedDays == 1 ? '' : 's'} '
                        '(${CurrencyFormatter.format(_dailyRate)}/day)',
                  _SalaryPeriod.custom => 'Custom salary amount',
                }
            : _note.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text('Pay salary · ${widget.employee.name}'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.employee.designation?.isNotEmpty == true
                    ? '${widget.employee.designation} · Monthly ${CurrencyFormatter.format(_monthly)}'
                    : 'Monthly ${CurrencyFormatter.format(_monthly)}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                'Daily rate · ${CurrencyFormatter.format(_dailyRate)} '
                '(month ÷ $_daysInMonth days)',
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Pay period', style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _SalaryPeriod.values.map((period) {
                  return FilterChip(
                    label: Text(switch (period) {
                      _SalaryPeriod.fullMonth => 'Full month',
                      _SalaryPeriod.halfMonth => 'Half',
                      _SalaryPeriod.days => 'Days',
                      _SalaryPeriod.custom => 'Custom Rs',
                    }),
                    selected: _period == period,
                    onSelected: (_) => _applyPeriod(period),
                  );
                }).toList(),
              ),
              if (_period == _SalaryPeriod.days) ...[
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: _days,
                  label: 'Number of days',
                  hintText: 'e.g. 5',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(_syncAmountFromPeriod),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        switch (_period) {
                          _SalaryPeriod.fullMonth =>
                            'Base · full monthly salary',
                          _SalaryPeriod.halfMonth =>
                            'Base · half of monthly salary',
                          _SalaryPeriod.days => _parsedDays <= 0
                              ? 'Base · enter days to calculate'
                              : 'Base · $_parsedDays × daily rate',
                          _SalaryPeriod.custom =>
                            'Base · custom amount',
                        },
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(_baseSalary),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Include commission'),
                subtitle: const Text(
                  'Add sales commission on top of base salary',
                ),
                value: _includeCommission,
                onChanged: (value) => setState(() => _includeCommission = value),
              ),
              if (_includeCommission) ...[
                const SizedBox(height: AppSpacing.xs),
                Text('Commission type', style: theme.textTheme.labelLarge),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _SalaryCommissionMode.values.map((mode) {
                    return FilterChip(
                      label: Text(switch (mode) {
                        _SalaryCommissionMode.perSale => 'Per sale',
                        _SalaryCommissionMode.fixedTotal => 'Fixed Rs',
                        _SalaryCommissionMode.percentOfSales => '% of sales',
                      }),
                      selected: _commissionMode == mode,
                      onSelected: (_) =>
                          setState(() => _commissionMode = mode),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_commissionMode == _SalaryCommissionMode.perSale) ...[
                  AppTextField(
                    controller: _salesCount,
                    label: 'Number of sales',
                    hintText: 'e.g. 7',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: _commissionPerSale,
                    label: 'Commission per sale (Rs)',
                    hintText: 'e.g. 500',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ] else if (_commissionMode ==
                    _SalaryCommissionMode.fixedTotal) ...[
                  AppTextField(
                    controller: _commissionFixed,
                    label: 'Commission amount (Rs)',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ] else ...[
                  AppTextField(
                    controller: _salesTotal,
                    label: 'Total sales amount (Rs)',
                    hintText: 'Sum of sales for commission',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppTextField(
                    controller: _commissionPercent,
                    label: 'Commission %',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _commissionAmount <= 0
                              ? 'Enter commission details'
                              : 'Commission',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(_commissionAmount),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total pay',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(_totalPay),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (widget.accounts.isEmpty)
                const Text('Add an account first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  decoration: const InputDecoration(labelText: 'Pay from'),
                  items: widget.accounts
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            '${a.name} · ${CurrencyFormatter.format(a.balance)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _accountId = v),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _amount,
                label: _period == _SalaryPeriod.custom
                    ? 'Base salary (Rs)'
                    : 'Base salary (Rs)',
                keyboardType: TextInputType.number,
                onChanged: (_) {
                  if (_period != _SalaryPeriod.custom) {
                    setState(() {
                      _period = _SalaryPeriod.custom;
                      _reference.text = 'Salary · Custom · $_monthLabel';
                    });
                  } else {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _reference,
                label: 'Reference',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _note,
                label: 'Note (optional)',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Pay salary',
          icon: Symbols.payments,
          onPressed: widget.accounts.isEmpty ? null : _submit,
        ),
      ],
    );
  }
}

enum _SalaryPeriod { fullMonth, halfMonth, days, custom }

enum _SalaryCommissionMode { perSale, fixedTotal, percentOfSales }

Future<void> showSalaryHistorySheet({
  required BuildContext context,
  required EmployeeItem employee,
  required List<SalaryHistoryItem> records,
}) {
  final monthFormat = DateFormat('MMM yyyy');
  final dateFormat = DateFormat('d MMM yyyy · h:mm a');
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final theme = Theme.of(context);
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Salary history · ${employee.name}',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  records.isEmpty
                      ? 'No salary payments recorded yet.'
                      : '${records.length} payment${records.length == 1 ? '' : 's'}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: records.isEmpty
                      ? const Center(
                          child: Text('No salary payments yet.'),
                        )
                      : ListView.separated(
                          controller: scrollController,
                          itemCount: records.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final item = records[index];
                            return AppCard(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          monthFormat.format(item.entryDate),
                                          style: theme.textTheme.titleSmall,
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormatter.format(item.amount),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.warning,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    dateFormat.format(item.entryDate),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  if (item.hasCommission) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Base ${CurrencyFormatter.format(item.baseAmount)} · '
                                      'Commission ${CurrencyFormatter.format(item.commissionAmount)}'
                                      '${item.salesCount != null ? ' · ${item.salesCount} sales' : ''}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                  if (item.note != null &&
                                      item.note!.trim().isNotEmpty)
                                    Text(
                                      item.note!,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<({int accountId, double amount})?> showSettleSheet({
  required BuildContext context,
  required String title,
  required double dueAmount,
  required List<FinanceAccountOption> accounts,
  required bool isPayable,
}) {
  return showDialog<({int accountId, double amount})>(
    context: context,
    builder: (context) => _SettleDialog(
      title: title,
      dueAmount: dueAmount,
      accounts: accounts,
      isPayable: isPayable,
    ),
  );
}

class _SettleDialog extends StatefulWidget {
  const _SettleDialog({
    required this.title,
    required this.dueAmount,
    required this.accounts,
    required this.isPayable,
  });

  final String title;
  final double dueAmount;
  final List<FinanceAccountOption> accounts;
  final bool isPayable;

  @override
  State<_SettleDialog> createState() => _SettleDialogState();
}

class _SettleDialogState extends State<_SettleDialog> {
  int? _accountId;
  late final TextEditingController _amount;

  @override
  void initState() {
    super.initState();
    if (widget.accounts.isNotEmpty) {
      _accountId = widget.accounts.first.id;
    }
    _amount = TextEditingController(
      text: widget.dueAmount.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    if (_accountId == null) {
      AppToast.show(context, 'Select an account.');
      return;
    }
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid amount.');
      return;
    }
    if (value > widget.dueAmount + 0.001) {
      AppToast.show(
        context,
        'Cannot exceed ${CurrencyFormatter.format(widget.dueAmount)}.',
      );
      return;
    }
    Navigator.pop(context, (accountId: _accountId!, amount: value));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isPayable
                  ? KhataBalanceRules.payableLabel(widget.dueAmount)
                  : KhataBalanceRules.amountLabel(widget.dueAmount),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: widget.isPayable
                        ? KhataBalanceRules.colorForPayable(widget.dueAmount)
                        : KhataBalanceRules.colorFor(widget.dueAmount),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (widget.accounts.isEmpty)
              const Text('Add an account first.')
            else
              DropdownButtonFormField<int>(
                initialValue: _accountId,
                decoration: InputDecoration(
                  labelText: widget.isPayable ? 'Pay from' : 'Receive in',
                ),
                items: widget.accounts
                    .map(
                      (a) => DropdownMenuItem(
                        value: a.id,
                        child: Text(
                          '${a.name} · ${CurrencyFormatter.format(a.balance)}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _accountId = v),
              ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _amount,
              label: 'Amount (Rs)',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: widget.isPayable ? 'Pay now' : 'Collect',
          icon: Symbols.payments,
          onPressed: widget.accounts.isEmpty ? null : _submit,
        ),
      ],
    );
  }
}

Future<ExpenseDraft?> showExpenseSheet({
  required BuildContext context,
  required List<FinanceAccountOption> accounts,
}) {
  return showDialog<ExpenseDraft>(
    context: context,
    builder: (context) => _ExpenseDialog(accounts: accounts),
  );
}

class _ExpenseDialog extends StatefulWidget {
  const _ExpenseDialog({required this.accounts});

  final List<FinanceAccountOption> accounts;

  @override
  State<_ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<_ExpenseDialog> {
  String _category = kFinanceExpenseCategories.first;
  int? _accountId;
  DateTime _entryDate = DateTime.now();
  String? _receiptPath;
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _paidBy = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.accounts.isNotEmpty) {
      _accountId = widget.accounts.first.id;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _paidBy.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (path == null) return;
    setState(() => _receiptPath = path);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _entryDate = picked);
    }
  }

  void _submit() {
    if (_accountId == null) {
      AppToast.show(context, 'Select a payment account.');
      return;
    }
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid amount.');
      return;
    }
    Navigator.pop(
      context,
      ExpenseDraft(
        category: _category,
        amount: value,
        accountId: _accountId!,
        entryDate: _entryDate,
        description: _description.text,
        paidBy: _paidBy.text,
        receiptSourcePath: _receiptPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receiptName = _receiptPath?.split(Platform.pathSeparator).last;
    return AlertDialog(
      title: const Text('Record expense'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: kFinanceExpenseCategories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => setState(() => _category = category),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (widget.accounts.isEmpty)
                const Text('Add a cash/bank account in Accounts first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  decoration: const InputDecoration(
                    labelText: 'Payment method / account',
                  ),
                  items: widget.accounts
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            '${a.name} · ${CurrencyFormatter.format(a.balance)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _accountId = v),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _amount,
                label: 'Amount (Rs)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat('d MMM yyyy').format(_entryDate)),
                trailing: IconButton(
                  icon: const Icon(Symbols.calendar_today, size: 20),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _description,
                label: 'Description (optional)',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _paidBy,
                label: 'Paid by (optional)',
                hintText: 'Staff name or owner',
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      receiptName == null
                          ? 'Receipt / attachment (optional)'
                          : 'Attached: $receiptName',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickReceipt,
                    icon: const Icon(Symbols.attach_file, size: 18),
                    label: Text(receiptName == null ? 'Attach' : 'Change'),
                  ),
                  if (receiptName != null)
                    IconButton(
                      tooltip: 'Remove attachment',
                      onPressed: () => setState(() => _receiptPath = null),
                      icon: const Icon(Symbols.close, size: 18),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Save expense',
          icon: Symbols.receipt_long,
          onPressed: widget.accounts.isEmpty ? null : _submit,
        ),
      ],
    );
  }
}

Future<EmployeeAdvanceDraft?> showAdvanceSheet({
  required BuildContext context,
  required List<FinanceAccountOption> accounts,
  required List<EmployeeItem> employees,
  EmployeeItem? preselectedEmployee,
  String? initialNote,
}) {
  return showDialog<EmployeeAdvanceDraft>(
    context: context,
    builder: (context) => _AdvanceDialog(
      accounts: accounts,
      employees: employees,
      preselectedEmployee: preselectedEmployee,
      initialNote: initialNote,
    ),
  );
}

class _AdvanceDialog extends StatefulWidget {
  const _AdvanceDialog({
    required this.accounts,
    required this.employees,
    this.preselectedEmployee,
    this.initialNote,
  });

  final List<FinanceAccountOption> accounts;
  final List<EmployeeItem> employees;
  final EmployeeItem? preselectedEmployee;
  final String? initialNote;

  @override
  State<_AdvanceDialog> createState() => _AdvanceDialogState();
}

class _AdvanceDialogState extends State<_AdvanceDialog> {
  int? _employeeId;
  int? _accountId;
  DateTime _entryDate = DateTime.now();
  final _amount = TextEditingController();
  final _note = TextEditingController();

  List<EmployeeItem> get _activeEmployees =>
      widget.employees.where((e) => e.isActive).toList();

  @override
  void initState() {
    super.initState();
    final active = _activeEmployees;
    if (widget.preselectedEmployee != null) {
      _employeeId = widget.preselectedEmployee!.id;
    } else if (active.isNotEmpty) {
      _employeeId = active.first.id;
    }
    if (widget.accounts.isNotEmpty) _accountId = widget.accounts.first.id;
    if (widget.initialNote != null && widget.initialNote!.trim().isNotEmpty) {
      _note.text = widget.initialNote!.trim();
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _entryDate = picked);
  }

  void _submit() {
    if (_employeeId == null) {
      AppToast.show(context, 'Select an employee.');
      return;
    }
    if (_accountId == null) {
      AppToast.show(context, 'Select an account.');
      return;
    }
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      AppToast.show(context, 'Enter a valid amount.');
      return;
    }
    Navigator.pop(
      context,
      EmployeeAdvanceDraft(
        employeeId: _employeeId!,
        accountId: _accountId!,
        amount: value,
        entryDate: _entryDate,
        note: _note.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Employee advance'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_activeEmployees.isEmpty)
                const Text('Add an active employee first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _employeeId,
                  decoration: const InputDecoration(labelText: 'Employee'),
                  items: _activeEmployees
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _employeeId = v),
                ),
              const SizedBox(height: AppSpacing.sm),
              if (widget.accounts.isEmpty)
                const Text('Add an account first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  decoration: const InputDecoration(labelText: 'Paid from'),
                  items: widget.accounts
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            '${a.name} · ${CurrencyFormatter.format(a.balance)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _accountId = v),
                ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _amount,
                label: 'Advance amount (Rs)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat('d MMM yyyy').format(_entryDate)),
                trailing: IconButton(
                  icon: const Icon(Symbols.calendar_today, size: 20),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _note,
                label: 'Note (optional)',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Record advance',
          icon: Symbols.savings,
          onPressed: _activeEmployees.isEmpty || widget.accounts.isEmpty
              ? null
              : _submit,
        ),
      ],
    );
  }
}

Future<EmployeeCommissionDraft?> showCommissionSheet({
  required BuildContext context,
  required List<FinanceAccountOption> accounts,
  required List<EmployeeItem> employees,
}) {
  return showDialog<EmployeeCommissionDraft>(
    context: context,
    builder: (context) =>
        _CommissionDialog(accounts: accounts, employees: employees),
  );
}

class _CommissionDialog extends StatefulWidget {
  const _CommissionDialog({
    required this.accounts,
    required this.employees,
  });

  final List<FinanceAccountOption> accounts;
  final List<EmployeeItem> employees;

  @override
  State<_CommissionDialog> createState() => _CommissionDialogState();
}

class _CommissionDialogState extends State<_CommissionDialog> {
  int? _employeeId;
  int? _accountId;
  DateTime _entryDate = DateTime.now();
  CommissionPayMode _mode = CommissionPayMode.fixed;
  final _amount = TextEditingController();
  final _baseAmount = TextEditingController();
  final _percent = TextEditingController();
  final _reference = TextEditingController();
  final _note = TextEditingController();

  List<EmployeeItem> get _activeEmployees =>
      widget.employees.where((e) => e.isActive).toList();

  double get _parsedBase => double.tryParse(_baseAmount.text.trim()) ?? 0;
  double get _parsedPercent => double.tryParse(_percent.text.trim()) ?? 0;
  double get _calculatedPercentAmount =>
      (_parsedBase * _parsedPercent / 100).clamp(0, 999999999);

  @override
  void initState() {
    super.initState();
    final active = _activeEmployees;
    if (active.isNotEmpty) _employeeId = active.first.id;
    if (widget.accounts.isNotEmpty) _accountId = widget.accounts.first.id;
  }

  @override
  void dispose() {
    _amount.dispose();
    _baseAmount.dispose();
    _percent.dispose();
    _reference.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _entryDate = picked);
  }

  void _submit() {
    if (_employeeId == null) {
      AppToast.show(context, 'Select an employee.');
      return;
    }
    if (_accountId == null) {
      AppToast.show(context, 'Select an account.');
      return;
    }

    late final double value;
    double? percentage;
    double? baseAmount;

    if (_mode == CommissionPayMode.percent) {
      if (_parsedBase <= 0) {
        AppToast.show(context, 'Enter sales / base amount (Rs).');
        return;
      }
      if (_parsedPercent <= 0) {
        AppToast.show(context, 'Enter commission percentage.');
        return;
      }
      value = _calculatedPercentAmount;
      percentage = _parsedPercent;
      baseAmount = _parsedBase;
      if (value <= 0) {
        AppToast.show(context, 'Calculated commission must be greater than zero.');
        return;
      }
    } else {
      value = double.tryParse(_amount.text.trim()) ?? 0;
      if (value <= 0) {
        AppToast.show(context, 'Enter a valid amount in Rs.');
        return;
      }
    }

    final autoNote = _mode == CommissionPayMode.percent
        ? '${_amountLabel(percentage!)}% of ${CurrencyFormatter.format(baseAmount!)}'
        : 'Fixed Rs commission';

    Navigator.pop(
      context,
      EmployeeCommissionDraft(
        employeeId: _employeeId!,
        accountId: _accountId!,
        amount: value,
        entryDate: _entryDate,
        mode: _mode,
        percentage: percentage,
        baseAmount: baseAmount,
        reference: _reference.text,
        note: _note.text.trim().isEmpty ? autoNote : _note.text,
      ),
    );
  }

  String _amountLabel(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Employee commission'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_activeEmployees.isEmpty)
                const Text('Add an active employee first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _employeeId,
                  decoration: const InputDecoration(labelText: 'Employee'),
                  items: _activeEmployees
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _employeeId = v),
                ),
              const SizedBox(height: AppSpacing.sm),
              if (widget.accounts.isEmpty)
                const Text('Add an account first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  decoration: const InputDecoration(labelText: 'Pay from'),
                  items: widget.accounts
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(
                            '${a.name} · ${CurrencyFormatter.format(a.balance)}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _accountId = v),
                ),
              const SizedBox(height: AppSpacing.md),
              Text('Commission type', style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  FilterChip(
                    label: const Text('Fixed Rs'),
                    selected: _mode == CommissionPayMode.fixed,
                    onSelected: (_) =>
                        setState(() => _mode = CommissionPayMode.fixed),
                  ),
                  FilterChip(
                    label: const Text('Percentage %'),
                    selected: _mode == CommissionPayMode.percent,
                    onSelected: (_) =>
                        setState(() => _mode = CommissionPayMode.percent),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (_mode == CommissionPayMode.fixed)
                AppTextField(
                  controller: _amount,
                  label: 'Commission amount (Rs)',
                  keyboardType: TextInputType.number,
                )
              else ...[
                AppTextField(
                  controller: _baseAmount,
                  label: 'Sales / base amount (Rs)',
                  hintText: 'e.g. 100000',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: _percent,
                  label: 'Commission %',
                  hintText: 'e.g. 5',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _parsedBase <= 0 || _parsedPercent <= 0
                              ? 'Enter base amount and % to calculate'
                              : '${_amountLabel(_parsedPercent)}% of '
                                  '${CurrencyFormatter.format(_parsedBase)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(_calculatedPercentAmount),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _reference,
                label: 'Period / reference (optional)',
                hintText: 'e.g. Jan 2026 sales',
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat('d MMM yyyy').format(_entryDate)),
                trailing: IconButton(
                  icon: const Icon(Symbols.calendar_today, size: 20),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _note,
                label: 'Note (optional)',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Pay commission',
          icon: Symbols.percent,
          onPressed: _activeEmployees.isEmpty || widget.accounts.isEmpty
              ? null
              : _submit,
        ),
      ],
    );
  }
}

Future<void> showAttendanceHistorySheet({
  required BuildContext context,
  required EmployeeItem employee,
  required List<AttendanceItem> records,
}) {
  final stats = AttendanceStats.from(records);
  final timeFormat = DateFormat('h:mm a');
  final dateFormat = DateFormat('EEE, d MMM yyyy');

  return showDialog<void>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return AlertDialog(
        title: Text(employee.name),
        content: SizedBox(
          width: 480,
          height: 480,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                employee.designation ?? 'Employee',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _HistoryStat(label: 'Days', value: '${stats.days}'),
                  _HistoryStat(
                    label: 'Check-ins',
                    value: '${stats.checkIns}',
                  ),
                  _HistoryStat(label: 'Hours', value: stats.hoursLabel),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'All check-ins',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: records.isEmpty
                    ? Center(
                        child: Text(
                          'No attendance recorded yet.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      )
                    : ListView.separated(
                        itemCount: records.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = records[index];
                          final inTime = timeFormat.format(item.clockInAt);
                          final outTime = item.clockOutAt == null
                              ? 'Still in'
                              : timeFormat.format(item.clockOutAt!);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(dateFormat.format(item.clockInAt)),
                            subtitle: Text(
                              'In $inTime · Out $outTime · ${item.durationLabel}',
                            ),
                            trailing: Text(
                              item.isOpen ? 'IN' : item.durationLabel,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: item.isOpen ? AppColors.success : null,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 132,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
