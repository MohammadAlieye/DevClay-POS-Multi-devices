import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../services/media/product_image_utils.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../../../widgets/product_image_pos_preview.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../domain/entities/product_item.dart';
import 'product_image_crop_dialog.dart';

Future<ProductDraft?> showProductEditorSheet({
  required BuildContext context,
  required List<String> categories,
  List<ProductItem> products = const [],
  List<String> units = DefaultProductUnits.all,
  ProductItem? existing,
  bool taxEnabled = true,
  double defaultTaxRate = 17,
  bool defaultTaxInclusive = true,
  bool enableVariants = false,
  bool showStrength = false,
  bool preferVolumeUnits = false,
}) {
  return showDialog<ProductDraft>(
    context: context,
    barrierDismissible: false,
    builder: (context) => _ProductEditorDialog(
      categories: categories,
      products: products,
      units: units,
      existing: existing,
      taxEnabled: taxEnabled,
      defaultTaxRate: defaultTaxRate,
      defaultTaxInclusive: defaultTaxInclusive,
      enableVariants: enableVariants,
      showStrength: showStrength,
      preferVolumeUnits: preferVolumeUnits,
    ),
  );
}

class _ProductEditorDialog extends StatefulWidget {
  const _ProductEditorDialog({
    required this.categories,
    required this.products,
    required this.units,
    this.existing,
    required this.taxEnabled,
    required this.defaultTaxRate,
    required this.defaultTaxInclusive,
    this.enableVariants = false,
    this.showStrength = false,
    this.preferVolumeUnits = false,
  });

  final List<String> categories;
  final List<ProductItem> products;
  final List<String> units;
  final ProductItem? existing;
  final bool taxEnabled;
  final double defaultTaxRate;
  final bool defaultTaxInclusive;
  final bool enableVariants;
  final bool showStrength;
  final bool preferVolumeUnits;

  @override
  State<_ProductEditorDialog> createState() => _ProductEditorDialogState();
}

class _ProductEditorDialogState extends State<_ProductEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _sku;
  late final TextEditingController _barcode;
  late final TextEditingController _category;
  late final TextEditingController _brand;
  late final TextEditingController _manufacturer;
  late final TextEditingController _strength;
  late final TextEditingController _unit;
  late final TextEditingController _tax;
  late final TextEditingController _lowStockAlert;

  String? _nameError;
  String? _skuError;
  String? _barcodeError;
  String? _categoryError;
  String? _unitError;
  String? _taxError;
  String? _lowStockError;

  String? _imagePath;
  String? _pendingImageSource;
  ProductImageInfo? _imageInfo;
  bool _clearImage = false;
  bool _taxInclusive = true;
  bool _isActive = true;
  bool _hasVariants = false;
  bool _handlingClose = false;
  late final FocusNode _dialogFocus;
  final List<ProductVariantDraft> _variants = [];
  final _variantSize = TextEditingController();
  final _variantColor = TextEditingController();
  final _variantStock = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _dialogFocus = FocusNode(debugLabel: 'product-editor-dialog');
    HardwareKeyboard.instance.addHandler(_onHardwareKey);
    final e = widget.existing;
    var defaultUnit = widget.units.isNotEmpty ? widget.units.first : 'pcs';
    if (widget.preferVolumeUnits) {
      if (widget.units.any((u) => u.toLowerCase() == 'l')) {
        defaultUnit = widget.units.firstWhere((u) => u.toLowerCase() == 'l');
      } else if (widget.units.any((u) => u.toLowerCase() == 'ml')) {
        defaultUnit = widget.units.firstWhere((u) => u.toLowerCase() == 'ml');
      }
    }
    _name = TextEditingController(text: e?.name ?? '');
    _sku = TextEditingController(text: e?.sku ?? '');
    _barcode = TextEditingController(text: e?.barcode ?? '');
    _category = TextEditingController(text: e?.category ?? '');
    _brand = TextEditingController(text: e?.brand ?? '');
    _manufacturer = TextEditingController(text: e?.manufacturer ?? '');
    _strength = TextEditingController(text: e?.strength ?? '');
    _unit = TextEditingController(text: e?.unit ?? defaultUnit);
    final defaultRate = widget.taxEnabled ? widget.defaultTaxRate : 0.0;
    _tax = TextEditingController(
      text: e?.taxRate.toStringAsFixed(0) ?? defaultRate.toStringAsFixed(0),
    );
    _lowStockAlert = TextEditingController(
      text: resolveLowStockThreshold(e?.lowStockThreshold ?? 0).toString(),
    );
    _imagePath = e?.imagePath;
    _taxInclusive =
        e?.taxInclusive ??
        (widget.taxEnabled ? widget.defaultTaxInclusive : false);
    _isActive = e?.isActive ?? true;
    _hasVariants = e?.hasVariants ?? false;
    if (e != null) {
      _variants.addAll(
        e.variants.map(
          (v) => ProductVariantDraft(
            id: v.id,
            size: v.size,
            color: v.color,
            barcode: v.barcode,
            sku: v.sku,
            stock: v.stock,
            priceOverride: v.priceOverride,
            isActive: v.isActive,
          ),
        ),
      );
    }
    if (_imagePath != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshImageInfo());
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onHardwareKey);
    _dialogFocus.dispose();
    _name.dispose();
    _sku.dispose();
    _barcode.dispose();
    _category.dispose();
    _brand.dispose();
    _manufacturer.dispose();
    _strength.dispose();
    _unit.dispose();
    _tax.dispose();
    _lowStockAlert.dispose();
    _variantSize.dispose();
    _variantColor.dispose();
    _variantStock.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif'],
        allowMultiple: false,
        dialogTitle: 'Choose product image',
        withData: false,
      );
      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;

      final path = result.files.single.path;
      if (path == null || path.isEmpty) {
        AppToast.show(
          context,
          'Could not read the selected image. Try another file.',
        );
        return;
      }

      final staged = await ProductImageUtils.stagePickedImage(path);
      if (!mounted) return;

      setState(() {
        _pendingImageSource = staged;
        _imagePath = staged;
        _clearImage = false;
      });
      await _refreshImageInfo();
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, 'Could not use that image. Try another file.');
    }
  }

  Future<void> _refreshImageInfo() async {
    final path = _imagePath;
    if (path == null || path.isEmpty) {
      if (mounted) setState(() => _imageInfo = null);
      return;
    }
    final info = await ProductImageUtils.readInfo(path);
    if (mounted) setState(() => _imageInfo = info);
  }

  Future<void> _cropImage() async {
    final path = _imagePath;
    if (path == null || path.isEmpty) return;

    Uint8List bytes;
    try {
      bytes = await File(path).readAsBytes();
    } catch (_) {
      if (!mounted) return;
      AppToast.show(
        context,
        'Image file is no longer available. Choose it again.',
      );
      return;
    }

    if (!mounted) return;
    final cropped = await showProductImageCropDialog(
      context: context,
      imageBytes: bytes,
    );
    if (!mounted || cropped == null) return;

    try {
      final saved = await ProductImageUtils.saveCroppedBytes(cropped);
      if (!mounted) return;
      setState(() {
        _pendingImageSource = saved;
        _imagePath = saved;
        _clearImage = false;
      });
      await _refreshImageInfo();
    } catch (_) {
      if (!mounted) return;
      AppToast.show(context, 'Could not save cropped image. Please try again.');
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
      _pendingImageSource = null;
      _imageInfo = null;
      _clearImage = true;
    });
  }

  bool _canHandleKeys() {
    if (_handlingClose || !mounted) return false;
    final route = ModalRoute.of(context);
    return route != null && route.isCurrent;
  }

  void _closeDialog([ProductDraft? result]) {
    if (_handlingClose || !mounted) return;
    _handlingClose = true;
    Navigator.of(context).pop(result);
  }

  bool _onHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!_canHandleKeys()) return false;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _closeDialog();
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
      return true;
    }
    return false;
  }

  KeyEventResult _onDialogKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!_canHandleKeys()) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _closeDialog();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _submit() {
    final name = _name.text.trim();
    final sku = _sku.text.trim();
    final barcode = _barcode.text.trim();
    final category = _category.text.trim();
    final unit = _unit.text.trim();

    final duplicateSku = widget.products.any(
      (product) =>
          product.id != widget.existing?.id &&
          product.sku.trim().toLowerCase() == sku.toLowerCase(),
    );
    final duplicateBarcode = widget.products.any(
      (product) =>
          product.id != widget.existing?.id &&
          product.barcode.trim() == barcode,
    );

    final taxRaw = _tax.text.trim();
    final parsedTax = widget.taxEnabled ? double.tryParse(taxRaw) : 0.0;
    String? taxError;
    if (widget.taxEnabled && parsedTax == null) {
      taxError = 'Enter a valid tax percentage';
    } else if (widget.taxEnabled && (parsedTax! < 0 || parsedTax > 100)) {
      taxError = 'Tax must be between 0 and 100';
    }

    final lowStockRaw = _lowStockAlert.text.trim();
    final parsedLowStock = lowStockRaw.isEmpty
        ? kLowStockThreshold
        : int.tryParse(lowStockRaw);
    String? lowStockError;
    if (parsedLowStock == null) {
      lowStockError = 'Enter a whole number';
    } else if (parsedLowStock < 0 || parsedLowStock > 999999) {
      lowStockError = 'Enter a value from 0 to 999999';
    }

    setState(() {
      _nameError = name.isEmpty ? 'Enter the product name' : null;
      _skuError = sku.isEmpty
          ? 'Enter an SKU'
          : duplicateSku
          ? 'This SKU is already used'
          : null;
      _barcodeError = barcode.isEmpty
          ? 'Enter a barcode'
          : duplicateBarcode
          ? 'This barcode is already used'
          : null;
      _categoryError = category.isEmpty ? 'Enter or select a category' : null;
      _unitError = unit.isEmpty ? 'Enter or select a unit' : null;
      _taxError = taxError;
      _lowStockError = lowStockError;
    });

    if (_nameError != null ||
        _skuError != null ||
        _barcodeError != null ||
        _categoryError != null ||
        _unitError != null ||
        _taxError != null ||
        _lowStockError != null) {
      return;
    }

    _closeDialog(
      ProductDraft(
        name: name,
        sku: sku,
        barcode: barcode,
        category: category,
        brand: _brand.text.trim(),
        manufacturer: _manufacturer.text.trim(),
        strength: _strength.text.trim(),
        hasVariants: widget.enableVariants && _hasVariants,
        unit: unit,
        taxRate: parsedTax!,
        taxInclusive: widget.taxEnabled ? _taxInclusive : false,
        isActive: _isActive,
        lowStockThreshold: parsedLowStock!,
        imagePath: _clearImage ? null : _imagePath,
        pendingImageSourcePath: _pendingImageSource,
        clearImage: _clearImage,
        variants: List<ProductVariantDraft>.from(_variants),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Focus(
      focusNode: _dialogFocus,
      autofocus: true,
      onKeyEvent: _onDialogKey,
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.existing == null ? 'Add product' : 'Edit product',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _closeDialog(),
                      tooltip: 'Close (Esc)',
                      icon: const Icon(Symbols.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.xs,
                      bottom: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildImageHeader(theme),
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _name,
                          maxLength: FieldLimits.name,
                          onChanged: (_) {
                            if (_nameError != null) {
                              setState(() => _nameError = null);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Name *',
                            counterText: '',
                            errorText: _nameError,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _sku,
                                maxLength: FieldLimits.sku,
                                onChanged: (_) {
                                  if (_skuError != null) {
                                    setState(() => _skuError = null);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'SKU *',
                                  counterText: '',
                                  errorText: _skuError,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                controller: _barcode,
                                maxLength: FieldLimits.barcode,
                                inputFormatters: FieldLimits.barcodeChars,
                                onChanged: (_) {
                                  if (_barcodeError != null) {
                                    setState(() => _barcodeError = null);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Barcode *',
                                  counterText: '',
                                  errorText: _barcodeError,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _manufacturer,
                                maxLength: FieldLimits.brand,
                                decoration: const InputDecoration(
                                  labelText: 'Manufacturer (optional)',
                                  hintText: 'Company / maker',
                                  counterText: '',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: TextField(
                                controller: _brand,
                                maxLength: FieldLimits.brand,
                                decoration: const InputDecoration(
                                  labelText: 'Brand (optional)',
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (widget.showStrength) ...[
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _strength,
                            decoration: const InputDecoration(
                              labelText: 'Strength (optional)',
                              hintText: 'e.g. 500mg',
                            ),
                          ),
                        ],
                        if (widget.enableVariants) ...[
                          const SizedBox(height: AppSpacing.md),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Size / color variants'),
                            value: _hasVariants,
                            onChanged: (v) => setState(() => _hasVariants = v),
                          ),
                          if (_hasVariants) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _variantSize,
                                    decoration: const InputDecoration(
                                      labelText: 'Size',
                                      hintText: 'M',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: TextField(
                                    controller: _variantColor,
                                    decoration: const InputDecoration(
                                      labelText: 'Color',
                                      hintText: 'Black',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: _variantStock,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Qty',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    final size = _variantSize.text.trim();
                                    final color = _variantColor.text.trim();
                                    final stock =
                                        int.tryParse(_variantStock.text.trim()) ??
                                            0;
                                    if (size.isEmpty || color.isEmpty) return;
                                    setState(() {
                                      _variants.add(
                                        ProductVariantDraft(
                                          size: size,
                                          color: color,
                                          stock: stock,
                                        ),
                                      );
                                      _variantSize.clear();
                                      _variantColor.clear();
                                      _variantStock.text = '0';
                                    });
                                  },
                                  icon: const Icon(Symbols.add),
                                ),
                              ],
                            ),
                            for (var i = 0; i < _variants.length; i++)
                              ListTile(
                                dense: true,
                                title: Text(
                                  '${_variants[i].size} / ${_variants[i].color}',
                                ),
                                subtitle: Text('Stock: ${_variants[i].stock}'),
                                trailing: IconButton(
                                  icon: const Icon(Symbols.delete),
                                  onPressed: () => setState(() {
                                    _variants.removeAt(i);
                                  }),
                                ),
                              ),
                          ],
                        ],
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _category,
                          maxLength: FieldLimits.category,
                          onChanged: (_) {
                            if (_categoryError != null) {
                              setState(() => _categoryError = null);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Category *',
                            counterText: '',
                            errorText: _categoryError,
                          ),
                        ),
                        if (widget.categories.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          ScrollableChipWrap(
                            children: widget.categories
                                .map(
                                  (c) => ActionChip(
                                    label: Text(c),
                                    onPressed: () => setState(() {
                                      _category.text = c;
                                      _categoryError = null;
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _unit,
                          maxLength: FieldLimits.unit,
                          onChanged: (_) {
                            if (_unitError != null) {
                              setState(() => _unitError = null);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Unit *',
                            hintText: 'pcs, half, karahi…',
                            counterText: '',
                            errorText: _unitError,
                          ),
                        ),
                        if (widget.units.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          ScrollableChipWrap(
                            children: widget.units
                                .map(
                                  (u) => ActionChip(
                                    label: Text(u),
                                    onPressed: () => setState(() {
                                      _unit.text = u;
                                      _unitError = null;
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          widget.existing != null &&
                                  (widget.existing!.sellingPrice > 0 ||
                                      widget.existing!.purchasePrice > 0)
                              ? [
                                  if (widget.existing!.purchasePrice > 0)
                                    'Last cost ${CurrencyFormatter.format(widget.existing!.purchasePrice)}',
                                  if (widget.existing!.wholesalePrice > 0)
                                    'Wholesale ${CurrencyFormatter.format(widget.existing!.wholesalePrice)}',
                                  if (widget.existing!.sellingPrice > 0)
                                    'Selling ${CurrencyFormatter.format(widget.existing!.sellingPrice)}',
                                  'Change prices in Purchases',
                                ].join(' · ')
                              : 'Set purchase, wholesale, and selling prices when you receive stock in Purchases.',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (widget.taxEnabled) ...[
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _tax,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: FieldLimits.taxPercent,
                            onChanged: (_) {
                              if (_taxError != null) {
                                setState(() => _taxError = null);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Tax %',
                              helperText: 'Overrides store default',
                              errorText: _taxError,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        TextField(
                          controller: _lowStockAlert,
                          keyboardType: TextInputType.number,
                          inputFormatters: FieldLimits.stockQty,
                          onChanged: (_) {
                            if (_lowStockError != null) {
                              setState(() => _lowStockError = null);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Low stock alert',
                            hintText: 'Default: $kLowStockThreshold',
                            helperText:
                                'Leave empty to use default ($kLowStockThreshold units).',
                            errorText: _lowStockError,
                          ),
                        ),
                        if (widget.taxEnabled)
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Tax inclusive'),
                            value: _taxInclusive,
                            onChanged: (v) => setState(() => _taxInclusive = v),
                          ),
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
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.secondary,
                        onPressed: () => _closeDialog(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Save product',
                        icon: Symbols.save,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        borderRadius: AppRadii.mdAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Symbols.image,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                'Product image',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'POS tile preview',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: ProductImagePosPreview(
              path: _imagePath,
              size: 120,
              centered: true,
              showLabel: false,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _imageInfo?.summary ?? 'Square crop · shown on POS tiles',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildImageActions(theme),
        ],
      ),
    );
  }

  Widget _buildImageActions(ThemeData theme) {
    final hasImage = _imagePath != null && _imagePath!.isNotEmpty;
    final compact = OutlinedButton.styleFrom(
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: theme.textTheme.labelMedium,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xxs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          style: compact,
          onPressed: _pickImage,
          icon: const Icon(Symbols.image, size: 16),
          label: Text(hasImage ? 'Change' : 'Choose image'),
        ),
        if (hasImage)
          OutlinedButton.icon(
            style: compact,
            onPressed: _cropImage,
            icon: const Icon(Symbols.crop, size: 16),
            label: const Text('Crop'),
          ),
        if (hasImage)
          TextButton.icon(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: _removeImage,
            icon: Icon(
              Symbols.delete,
              size: 16,
              color: theme.colorScheme.error,
            ),
            label: const Text('Remove'),
          ),
      ],
    );
  }
}
