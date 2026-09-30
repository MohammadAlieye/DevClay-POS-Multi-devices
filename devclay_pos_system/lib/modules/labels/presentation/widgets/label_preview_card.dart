import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../services/labels/barcode_validator.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_card.dart';
import '../../domain/entities/label_entities.dart';

class LabelPreviewCard extends StatelessWidget {
  const LabelPreviewCard({
    super.key,
    required this.template,
    required this.line,
    this.storeName = '',
    this.onCopiesChanged,
  });

  final LabelTemplateItem template;
  final LabelProductLine line;
  final String storeName;
  final ValueChanged<int>? onCopiesChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rawBarcode =
        line.barcode.trim().isNotEmpty ? line.barcode : line.sku;
    final barcodeValue = BarcodeValidator.encode(rawBarcode, template.symbology);
    final corrected = template.symbology == LabelSymbology.ean13 &&
        BarcodeValidator.wasEan13Corrected(rawBarcode, barcodeValue);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (storeName.isNotEmpty)
                  Text(storeName, style: theme.textTheme.labelSmall),
                if (template.showProductName)
                  Text(
                    line.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                if (template.showBrand && line.brand?.isNotEmpty == true)
                  Text(line.brand!, style: const TextStyle(color: Colors.black54)),
                if (template.showSku)
                  Text('SKU: ${line.sku}', style: const TextStyle(color: Colors.black54)),
                if (template.showUnit && line.unit?.isNotEmpty == true)
                  Text(line.unit!, style: const TextStyle(color: Colors.black54)),
                if (template.showCategory)
                  Text(line.category, style: const TextStyle(color: Colors.black54)),
                if (template.showPrice)
                  Text(
                    CurrencyFormatter.format(line.sellingPrice),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                if (template.showBatchSlot && line.batchNo?.isNotEmpty == true)
                  Text('Batch: ${line.batchNo}', style: const TextStyle(fontSize: 11)),
                if (template.showExpirySlot && line.expiryDate?.isNotEmpty == true)
                  Text('Exp: ${line.expiryDate}', style: const TextStyle(fontSize: 11)),
                if (corrected)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'EAN-13 check digit auto-corrected ($rawBarcode → $barcodeValue)',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                BarcodeWidget(
                  barcode: BarcodeValidator.barcodeFor(template.symbology),
                  data: barcodeValue,
                  width: 180,
                  height: 56,
                  drawText: true,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text('Copies', style: theme.textTheme.bodySmall),
              const Spacer(),
              if (onCopiesChanged != null)
                LabelCopiesStepper(
                  key: ValueKey('preview-copies-${line.productId}'),
                  copies: line.copies,
                  onChanged: onCopiesChanged!,
                )
              else
                Text(
                  '×${line.copies}',
                  style: theme.textTheme.titleSmall,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact − / typed count / + control for per-product label copies.
class LabelCopiesStepper extends StatefulWidget {
  const LabelCopiesStepper({
    super.key,
    required this.copies,
    required this.onChanged,
  });

  final int copies;
  final ValueChanged<int> onChanged;

  @override
  State<LabelCopiesStepper> createState() => _LabelCopiesStepperState();
}

class _LabelCopiesStepperState extends State<LabelCopiesStepper> {
  static const int _maxCopies = 999;

  late final TextEditingController _controller;
  late final FocusNode _focus;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.copies}');
    _focus = FocusNode(debugLabel: 'label-copies');
    _focus.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(LabelCopiesStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing && oldWidget.copies != widget.copies) {
      _controller.text = '${widget.copies}';
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChanged);
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focus.hasFocus) {
      _editing = true;
      return;
    }
    _editing = false;
    _commit();
  }

  int _clamp(int value) {
    if (value < 1) return 1;
    if (value > _maxCopies) return _maxCopies;
    return value;
  }

  int _parsedCopies() {
    return int.tryParse(_controller.text.trim()) ?? widget.copies;
  }

  void _commit() {
    final copies = _clamp(_parsedCopies());
    if (_controller.text != '$copies') {
      _controller.text = '$copies';
    }
    if (copies != widget.copies) {
      widget.onChanged(copies);
    }
  }

  void _applyTyped(String text) {
    final parsed = int.tryParse(text.trim());
    if (parsed == null) return;
    final copies = _clamp(parsed);
    if (copies != widget.copies) {
      widget.onChanged(copies);
    }
  }

  void _step(int delta) {
    final next = _clamp(_parsedCopies() + delta);
    _controller.text = '$next';
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppColors.accent;
    final isDark = theme.brightness == Brightness.dark;
    final copies = _parsedCopies();

    return Tooltip(
      message: 'Copies — type a number or use + / −',
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CopiesStepButton(
                icon: Symbols.remove,
                onPressed: copies > 1 ? () => _step(-1) : null,
              ),
              SizedBox(
                width: 52,
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 8,
                    ),
                  ),
                  onTap: () {
                    _controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _controller.text.length,
                    );
                  },
                  onChanged: _applyTyped,
                  onSubmitted: (_) => _commit(),
                ),
              ),
              _CopiesStepButton(
                icon: Symbols.add,
                onPressed: copies < _maxCopies ? () => _step(1) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CopiesStepButton extends StatelessWidget {
  const _CopiesStepButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 16, color: AppColors.accent),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
