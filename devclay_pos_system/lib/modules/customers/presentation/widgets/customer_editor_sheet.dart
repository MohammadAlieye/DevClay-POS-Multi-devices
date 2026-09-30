import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../domain/entities/customer_entities.dart';

Future<CustomerDraft?> showCustomerEditorSheet({
  required BuildContext context,
  CustomerItem? existing,
  String initialName = '',
}) {
  return showDialog<CustomerDraft>(
    context: context,
    builder: (context) =>
        _CustomerEditorDialog(existing: existing, initialName: initialName),
  );
}

class _CustomerEditorDialog extends StatefulWidget {
  const _CustomerEditorDialog({this.existing, this.initialName = ''});

  final CustomerItem? existing;
  final String initialName;

  @override
  State<_CustomerEditorDialog> createState() => _CustomerEditorDialogState();
}

class _CustomerEditorDialogState extends State<_CustomerEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _creditLimit;
  late final TextEditingController _notes;
  late bool _isActive;
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _creditLimitError;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? widget.initialName);
    _phone = TextEditingController(text: e?.phone ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _address = TextEditingController(text: e?.address ?? '');
    _creditLimit = TextEditingController(
      text: e?.creditLimit.toStringAsFixed(0) ?? '0',
    );
    _notes = TextEditingController(text: e?.notes ?? '');
    _isActive = e?.isActive ?? true;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _creditLimit.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final email = _email.text.trim();
    final creditRaw = _creditLimit.text.trim();
    final creditLimit = creditRaw.isEmpty ? 0.0 : double.tryParse(creditRaw);
    final emailValid =
        email.isEmpty || RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);

    setState(() {
      _nameError = name.isEmpty ? 'Enter the customer name' : null;
      _phoneError = phone.isEmpty ? 'Enter a phone number' : null;
      _emailError = emailValid ? null : 'Enter a valid email address';
      _creditLimitError = creditLimit == null
          ? 'Enter a valid amount'
          : creditLimit < 0
          ? 'Credit limit cannot be negative'
          : null;
    });
    if (_nameError != null ||
        _phoneError != null ||
        _emailError != null ||
        _creditLimitError != null) {
      return;
    }

    Navigator.of(context).pop(
      CustomerDraft(
        name: name,
        phone: phone,
        email: email,
        address: _address.text,
        notes: _notes.text,
        creditLimit: creditLimit!,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit customer' : 'Add customer'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _name,
                label: 'Name *',
                hintText: 'Customer or business name',
                errorText: _nameError,
                onChanged: (_) {
                  if (_nameError != null) setState(() => _nameError = null);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _phone,
                label: 'Phone *',
                hintText: '0300 1234567',
                keyboardType: TextInputType.phone,
                errorText: _phoneError,
                onChanged: (_) {
                  if (_phoneError != null) setState(() => _phoneError = null);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _email,
                label: 'Email (optional)',
                keyboardType: TextInputType.emailAddress,
                errorText: _emailError,
                onChanged: (_) {
                  if (_emailError != null) setState(() => _emailError = null);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _address, label: 'Address (optional)'),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _creditLimit,
                label: 'Credit limit (Rs)',
                keyboardType: TextInputType.number,
                errorText: _creditLimitError,
                onChanged: (_) {
                  if (_creditLimitError != null) {
                    setState(() => _creditLimitError = null);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _notes, label: 'Notes (optional)'),
              if (isEdit) ...[
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
          label: isEdit ? 'Save' : 'Add customer',
          icon: Symbols.person_add,
          onPressed: _submit,
        ),
      ],
    );
  }
}
