import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../domain/entities/account_entities.dart';
import '../../../../widgets/app_toast.dart';

Future<AccountDraft?> showAccountEditorSheet({
  required BuildContext context,
  AccountItem? existing,
}) {
  return showDialog<AccountDraft>(
    context: context,
    builder: (context) => _AccountEditorDialog(existing: existing),
  );
}

class _AccountEditorDialog extends StatefulWidget {
  const _AccountEditorDialog({this.existing});

  final AccountItem? existing;

  @override
  State<_AccountEditorDialog> createState() => _AccountEditorDialogState();
}

class _AccountEditorDialogState extends State<_AccountEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _opening;
  late final TextEditingController _notes;
  late AccountType _type;
  late bool _isDefault;
  late bool _isActive;
  String? _nameError;
  String? _openingError;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _opening = TextEditingController(
      text: e == null ? '0' : e.balance.toStringAsFixed(0),
    );
    _notes = TextEditingController(text: e?.notes ?? '');
    _type = e?.accountType ?? AccountType.cash;
    _isDefault = e?.isDefault ?? false;
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _opening.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final openingRaw = _opening.text.trim();
    final openingBalance = widget.existing == null
        ? double.tryParse(openingRaw)
        : widget.existing!.balance;
    setState(() {
      _nameError = name.isEmpty ? 'Enter the account name' : null;
      _openingError = widget.existing == null && openingBalance == null
          ? 'Enter a valid opening balance'
          : null;
    });
    if (_nameError != null || _openingError != null) return;

    Navigator.of(context).pop(
      AccountDraft(
        name: name,
        type: _type,
        openingBalance: openingBalance!,
        isDefault: _isDefault,
        isActive: _isActive,
        notes: _notes.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit account' : 'Add account'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _name,
                label: 'Account name *',
                hintText: 'Cash drawer, HBL, JazzCash…',
                errorText: _nameError,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<AccountType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: AccountType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(_typeLabel(type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              if (!isEdit) ...[
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: _opening,
                  label: 'Opening balance (Rs)',
                  keyboardType: TextInputType.number,
                  errorText: _openingError,
                  onChanged: (_) {
                    if (_openingError != null) {
                      setState(() => _openingError = null);
                    }
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _notes, label: 'Notes (optional)'),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Default account'),
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
              ),
              if (isEdit)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: isEdit ? 'Save' : 'Add account',
          icon: Symbols.account_balance,
          onPressed: _submit,
        ),
      ],
    );
  }

  String _typeLabel(AccountType type) {
    return switch (type) {
      AccountType.cash => 'Cash',
      AccountType.bank => 'Bank',
      AccountType.mobile => 'Mobile wallet',
    };
  }
}

Future<LedgerDraft?> showLedgerEntrySheet({
  required BuildContext context,
  required List<AccountItem> accounts,
  LedgerType initialType = LedgerType.expense,
}) {
  return showDialog<LedgerDraft>(
    context: context,
    builder: (context) =>
        _LedgerEntryDialog(accounts: accounts, initialType: initialType),
  );
}

class _LedgerEntryDialog extends StatefulWidget {
  const _LedgerEntryDialog({
    required this.accounts,
    this.initialType = LedgerType.expense,
  });

  final List<AccountItem> accounts;
  final LedgerType initialType;

  @override
  State<_LedgerEntryDialog> createState() => _LedgerEntryDialogState();
}

class _LedgerEntryDialogState extends State<_LedgerEntryDialog> {
  late LedgerType _type;
  int? _accountId;
  late String _category;
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _category = _type == LedgerType.income
        ? kIncomeCategories.first
        : kExpenseCategories.first;
    final active = widget.accounts
        .where((account) => account.isActive)
        .toList();
    if (active.isNotEmpty) {
      _accountId = active
          .firstWhere(
            (account) => account.isDefault,
            orElse: () => active.first,
          )
          .id;
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    _note.dispose();
    super.dispose();
  }

  List<String> get _categories =>
      _type == LedgerType.income ? kIncomeCategories : kExpenseCategories;

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

    Navigator.of(context).pop(
      LedgerDraft(
        accountId: _accountId!,
        type: _type,
        category: _category,
        amount: value,
        reference: _reference.text.trim().isEmpty
            ? null
            : _reference.text.trim(),
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeAccounts = widget.accounts
        .where((account) => account.isActive)
        .toList();
    final isExpense = _type == LedgerType.expense;

    return AlertDialog(
      title: Text(isExpense ? 'Record expense' : 'Record income'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<LedgerType>(
                segments: const [
                  ButtonSegment(
                    value: LedgerType.expense,
                    label: Text('Expense'),
                    icon: Icon(Symbols.trending_down, size: 16),
                  ),
                  ButtonSegment(
                    value: LedgerType.income,
                    label: Text('Income'),
                    icon: Icon(Symbols.trending_up, size: 16),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (value) {
                  setState(() {
                    _type = value.first;
                    _category = _categories.first;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              if (activeAccounts.isEmpty)
                const Text('Add an account first.')
              else
                DropdownButtonFormField<int>(
                  initialValue: _accountId,
                  decoration: const InputDecoration(
                    labelText: 'Paid from / received in',
                  ),
                  items: activeAccounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _accountId = value),
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isExpense ? 'Expense type' : 'Income type',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _categories.map((category) {
                  final selected = category == _category;
                  return FilterChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) => setState(() => _category = category),
                  );
                }).toList(),
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
                hintText: isExpense
                    ? 'Bill no. / salary month…'
                    : 'Invoice / receipt no.',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _note,
                label: 'Note (optional)',
                hintText: isExpense ? 'e.g. August staff salaries' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: isExpense ? 'Save expense' : 'Save income',
          icon: isExpense ? Symbols.payments : Symbols.receipt_long,
          onPressed: activeAccounts.isEmpty ? null : _submit,
        ),
      ],
    );
  }
}
