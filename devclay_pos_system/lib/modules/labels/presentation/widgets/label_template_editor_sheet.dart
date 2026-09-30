import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../domain/entities/label_entities.dart';

Future<LabelTemplateDraft?> showLabelTemplateEditorSheet({
  required BuildContext context,
  LabelTemplateItem? existing,
}) {
  return showDialog<LabelTemplateDraft>(
    context: context,
    builder: (context) => _LabelTemplateEditorDialog(existing: existing),
  );
}

class _LabelTemplateEditorDialog extends StatefulWidget {
  const _LabelTemplateEditorDialog({this.existing});

  final LabelTemplateItem? existing;

  @override
  State<_LabelTemplateEditorDialog> createState() =>
      _LabelTemplateEditorDialogState();
}

class _LabelTemplateEditorDialogState extends State<_LabelTemplateEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _width;
  late final TextEditingController _height;
  late final TextEditingController _copies;
  late LabelStoreType _storeType;
  late LabelSymbology _symbology;
  late LabelPayloadFormat _format;
  late bool _showName;
  late bool _showSku;
  late bool _showPrice;
  late bool _showBrand;
  late bool _showUnit;
  late bool _showCategory;
  late bool _showExpiry;
  late bool _showBatch;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _description = TextEditingController(text: e?.description ?? '');
    _width = TextEditingController(text: (e?.widthMm ?? 50).toStringAsFixed(0));
    _height = TextEditingController(text: (e?.heightMm ?? 30).toStringAsFixed(0));
    _copies = TextEditingController(text: '${e?.defaultCopies ?? 1}');
    _storeType = e?.storeType ?? LabelStoreType.retail;
    _symbology = e?.symbology ?? LabelSymbology.code128;
    _format = e?.payloadFormat ?? LabelPayloadFormat.zpl;
    _showName = e?.showProductName ?? true;
    _showSku = e?.showSku ?? true;
    _showPrice = e?.showPrice ?? true;
    _showBrand = e?.showBrand ?? false;
    _showUnit = e?.showUnit ?? false;
    _showCategory = e?.showCategory ?? false;
    _showExpiry = e?.showExpirySlot ?? false;
    _showBatch = e?.showBatchSlot ?? false;
    _isDefault = e?.isDefault ?? false;
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _width.dispose();
    _height.dispose();
    _copies.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      AppToast.show(context, 'Template name is required');
      return;
    }
    Navigator.of(context).pop(
      LabelTemplateDraft(
        name: _name.text,
        storeType: _storeType,
        description: _description.text,
        widthMm: double.tryParse(_width.text) ?? 50,
        heightMm: double.tryParse(_height.text) ?? 30,
        symbology: _symbology,
        payloadFormat: _format,
        showProductName: _showName,
        showSku: _showSku,
        showPrice: _showPrice,
        showBrand: _showBrand,
        showUnit: _showUnit,
        showCategory: _showCategory,
        showExpirySlot: _showExpiry,
        showBatchSlot: _showBatch,
        defaultCopies: int.tryParse(_copies.text) ?? 1,
        isDefault: _isDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit template' : 'New label template'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(controller: _name, label: 'Template name'),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _description, label: 'Description'),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<LabelStoreType>(
                initialValue: _storeType,
                decoration: const InputDecoration(
                  labelText: 'Store type',
                  border: OutlineInputBorder(),
                ),
                items: LabelStoreType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(LabelLabels.storeType(type)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _storeType = v!),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _width,
                      label: 'Width (mm)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _height,
                      label: 'Height (mm)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<LabelSymbology>(
                initialValue: _symbology,
                decoration: const InputDecoration(
                  labelText: 'Barcode symbology',
                  border: OutlineInputBorder(),
                ),
                items: LabelSymbology.values
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(LabelLabels.symbology(s)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _symbology = v!),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<LabelPayloadFormat>(
                initialValue: _format,
                decoration: const InputDecoration(
                  labelText: 'Print format',
                  border: OutlineInputBorder(),
                ),
                items: LabelPayloadFormat.values
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(LabelLabels.payloadFormat(f)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _format = v!),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _copies,
                label: 'Default copies',
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Set as default template'),
                value: _isDefault,
                onChanged: (v) => setState(() => _isDefault = v),
              ),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Product name'),
                value: _showName,
                onChanged: (v) => setState(() => _showName = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('SKU'),
                value: _showSku,
                onChanged: (v) => setState(() => _showSku = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Price'),
                value: _showPrice,
                onChanged: (v) => setState(() => _showPrice = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Brand'),
                value: _showBrand,
                onChanged: (v) => setState(() => _showBrand = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Unit / size'),
                value: _showUnit,
                onChanged: (v) => setState(() => _showUnit = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Category'),
                value: _showCategory,
                onChanged: (v) => setState(() => _showCategory = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Expiry slot'),
                value: _showExpiry,
                onChanged: (v) => setState(() => _showExpiry = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Batch slot'),
                value: _showBatch,
                onChanged: (v) => setState(() => _showBatch = v),
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
          label: isEdit ? 'Save' : 'Create',
          icon: Symbols.save,
          onPressed: _submit,
        ),
      ],
    );
  }
}
