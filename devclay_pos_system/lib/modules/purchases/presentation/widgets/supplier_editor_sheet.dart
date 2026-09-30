import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../utils/supplier_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../domain/entities/purchase_entities.dart';

enum _OpeningDirection { give, take }

Future<SupplierDraft?> showSupplierEditorSheet({
  required BuildContext context,
  SupplierItem? existing,
}) {
  return showDialog<SupplierDraft>(
    context: context,
    builder: (context) => _SupplierEditorDialog(existing: existing),
  );
}

class _SupplierEditorDialog extends StatefulWidget {
  const _SupplierEditorDialog({this.existing});

  final SupplierItem? existing;

  @override
  State<_SupplierEditorDialog> createState() => _SupplierEditorDialogState();
}

class _SupplierEditorDialogState extends State<_SupplierEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _notes;
  late final TextEditingController _openingAmount;
  late bool _isActive;
  _OpeningDirection _openingDirection = _OpeningDirection.give;
  String? _nameError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _address = TextEditingController(text: e?.address ?? '');
    _notes = TextEditingController(text: e?.notes ?? '');
    _openingAmount = TextEditingController();
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _notes.dispose();
    _openingAmount.dispose();
    super.dispose();
  }

  double _signedOpeningBalance() {
    final amount = double.tryParse(_openingAmount.text.trim()) ?? 0;
    if (amount <= 0) return 0;
    return _openingDirection == _OpeningDirection.give ? amount : -amount;
  }

  void _submit() {
    final name = _name.text.trim();
    final email = _email.text.trim();
    final emailValid =
        email.isEmpty || RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    setState(() {
      _nameError = name.isEmpty ? 'Enter the supplier name' : null;
      _emailError = emailValid ? null : 'Enter a valid email address';
    });
    if (_nameError != null || _emailError != null) {
      return;
    }
    Navigator.of(context).pop(
      SupplierDraft(
        name: name,
        phone: _phone.text,
        email: email,
        address: _address.text,
        notes: _notes.text,
        isActive: _isActive,
        openingBalance: widget.existing == null ? _signedOpeningBalance() : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(isEdit ? 'Edit supplier' : 'Add supplier'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _name,
                label: 'Name *',
                hintText: 'Supplier company name',
                errorText: _nameError,
                onChanged: (_) {
                  if (_nameError != null) {
                    setState(() => _nameError = null);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _phone,
                label: 'Phone (optional)',
                hintText: '0300 1234567',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _email,
                label: 'Email (optional)',
                hintText: 'accounts@supplier.com',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _address,
                label: 'Address (optional)',
                hintText: 'City, area',
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _notes,
                label: 'Notes (optional)',
                hintText: 'Payment terms, contact person…',
              ),
              if (!isEdit) ...[
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Opening balance (optional)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Old khata before this system. Give = you still need to pay. '
                  'Take = supplier still needs to return / advance.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<_OpeningDirection>(
                  segments: [
                    ButtonSegment(
                      value: _OpeningDirection.give,
                      label: Text(
                        'Give',
                        style: TextStyle(
                          color: _openingDirection == _OpeningDirection.give
                              ? Colors.white
                              : KhataBalanceRules.giveColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    ButtonSegment(
                      value: _OpeningDirection.take,
                      label: Text(
                        'Take',
                        style: TextStyle(
                          color: _openingDirection == _OpeningDirection.take
                              ? Colors.white
                              : KhataBalanceRules.takeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  selected: {_openingDirection},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (!states.contains(WidgetState.selected)) return null;
                      return _openingDirection == _OpeningDirection.give
                          ? KhataBalanceRules.giveColor
                          : KhataBalanceRules.takeColor;
                    }),
                  ),
                  onSelectionChanged: (value) {
                    setState(() => _openingDirection = value.first);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppTextField(
                  controller: _openingAmount,
                  label: 'Amount',
                  hintText: '0',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                if (_signedOpeningBalance() != 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    SupplierBalanceRules.detailLabel(_signedOpeningBalance()),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: SupplierBalanceRules.colorFor(
                        _signedOpeningBalance(),
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
              if (isEdit) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current balance',
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        SupplierBalanceRules.detailLabel(
                          widget.existing!.balance,
                        ),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: SupplierBalanceRules.colorFor(
                            widget.existing!.balance,
                          ),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Use Adjust balance from the supplier list to change this.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
              ],
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
          label: isEdit ? 'Save' : 'Add supplier',
          icon: Symbols.local_shipping,
          onPressed: _submit,
        ),
      ],
    );
  }
}
