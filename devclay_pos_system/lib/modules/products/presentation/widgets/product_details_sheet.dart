import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/product_image.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../domain/entities/product_item.dart';

Future<void> showProductDetailsSheet({
  required BuildContext context,
  required ProductItem product,
  required VoidCallback onEdit,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) =>
        _ProductDetailsDialog(product: product, onEdit: onEdit),
  );
}

class _ProductDetailsDialog extends StatelessWidget {
  const _ProductDetailsDialog({required this.product, required this.onEdit});

  final ProductItem product;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy');
    final hasPrices =
        product.sellingPrice > 0 ||
        product.wholesalePrice > 0 ||
        product.purchasePrice > 0;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImage(path: product.imagePath, size: 88),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            _StatusChip(
                              label: product.isActive ? 'Active' : 'Inactive',
                              color: product.isActive
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                            if (product.isOutOfStock)
                              const _StatusChip(
                                label: 'Out of stock',
                                color: AppColors.danger,
                              )
                            else if (product.isLowStock)
                              const _StatusChip(
                                label: 'Low stock',
                                color: AppColors.warning,
                              ),
                            if (product.isExpired)
                              const _StatusChip(
                                label: 'Expired',
                                color: AppColors.danger,
                              )
                            else if (product.isExpiringSoon())
                              const _StatusChip(
                                label: 'Expiring soon',
                                color: AppColors.warning,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Symbols.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    children: [
                      const _SectionTitle('Catalog'),
                      _DetailRow(label: 'SKU', value: product.sku),
                      _DetailRow(
                        label: 'Barcode',
                        value: product.barcode.isEmpty ? '—' : product.barcode,
                      ),
                      _DetailRow(label: 'Category', value: product.category),
                      _DetailRow(
                        label: 'Brand',
                        value: product.brand?.trim().isNotEmpty == true
                            ? product.brand!
                            : '—',
                      ),
                      _DetailRow(
                        label: 'Manufacturer',
                        value: product.manufacturer?.trim().isNotEmpty == true
                            ? product.manufacturer!
                            : '—',
                      ),
                      _DetailRow(
                        label: 'Unit',
                        value: product.unit?.trim().isNotEmpty == true
                            ? product.unit!
                            : '—',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _SectionTitle('Stock & dates'),
                      _DetailRow(
                        label: 'On hand',
                        value: '${product.stock}',
                        valueColor: product.isOutOfStock
                            ? AppColors.danger
                            : product.isLowStock
                            ? AppColors.warning
                            : null,
                      ),
                      _DetailRow(
                        label: 'Low-stock alert',
                        value: product.lowStockThreshold > 0
                            ? '${product.lowStockThreshold}'
                            : 'Default ($kLowStockThreshold)',
                      ),
                      _DetailRow(
                        label: 'Manufacture',
                        value: product.manufactureDate == null
                            ? '—'
                            : dateFormat.format(product.manufactureDate!),
                      ),
                      _DetailRow(
                        label: 'Expiry',
                        value: product.expiryDate == null
                            ? 'No expiry'
                            : dateFormat.format(product.expiryDate!),
                        valueColor: product.isExpired
                            ? AppColors.danger
                            : product.isExpiringSoon()
                            ? AppColors.warning
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _SectionTitle('Prices (from last purchase)'),
                      if (!hasPrices)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(
                            'No prices yet. Set cost, wholesale, and selling when you receive stock in Purchases.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      _DetailRow(
                        label: 'Selling',
                        value: CurrencyFormatter.format(product.sellingPrice),
                        valueColor: AppColors.accent,
                      ),
                      _DetailRow(
                        label: 'Wholesale',
                        value: CurrencyFormatter.format(product.wholesalePrice),
                      ),
                      _DetailRow(
                        label: 'Last cost',
                        value: CurrencyFormatter.format(product.purchasePrice),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const _SectionTitle('Tax'),
                      _DetailRow(
                        label: 'Rate',
                        value: '${product.taxRate.toStringAsFixed(1)}%',
                      ),
                      _DetailRow(
                        label: 'Inclusive',
                        value: product.taxInclusive ? 'Yes' : 'No',
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
                      label: 'Close',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: 'Edit catalog',
                      icon: Symbols.edit,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.full),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
