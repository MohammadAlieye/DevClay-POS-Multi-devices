import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/measure_units.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/product_image.dart';
import '../../domain/entities/inventory_entities.dart';
import '../../domain/repositories/inventory_repository.dart';

Future<void> showInventoryProductDetailSheet({
  required BuildContext context,
  required InventoryProduct product,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _InventoryProductDetailDialog(product: product),
  );
}

class _InventoryProductDetailDialog extends StatelessWidget {
  const _InventoryProductDetailDialog({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 760),
        child: FutureBuilder<InventoryProductDetail>(
          future: sl<InventoryRepository>().getProductDetail(product.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('Could not load details: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return _DetailBody(detail: snapshot.data!);
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.detail});

  final InventoryProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy');
    final dateTimeFormat = DateFormat('d MMM yyyy');
    final product = detail.product;
    final activeLots = detail.lots.where((lot) => lot.quantity > 0).toList();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(path: product.imagePath, size: 72),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      [
                        product.sku,
                        product.category,
                        if (detail.brand != null && detail.brand!.isNotEmpty)
                          detail.brand,
                      ].join(' · '),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Stock ${product.formattedStock} · Last cost ${CurrencyFormatter.format(product.purchasePrice)} · Sell ${CurrencyFormatter.format(detail.sellingPrice)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.35,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Symbols.inventory_2,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${activeLots.length} active ${activeLots.length == 1 ? 'batch' : 'batches'} · ${product.formattedStock} on hand',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'POS uses the earliest expiry first automatically (FEFO). The cashier can also choose a specific batch from the product card.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'All recorded batches',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (detail.lots.isEmpty)
                  Text(
                    'No lots yet. Stock will split into batches when you receive in Purchases.',
                    style: theme.textTheme.bodySmall,
                  )
                else
                  ...detail.lots.asMap().entries.map((entry) {
                    final lot = entry.value;
                    final sellsNext =
                        lot.quantity > 0 &&
                        activeLots.isNotEmpty &&
                        identical(lot, activeLots.first);
                    final expired =
                        lot.expiryDate != null &&
                        DateTime(
                          lot.expiryDate!.year,
                          lot.expiryDate!.month,
                          lot.expiryDate!.day,
                        ).isBefore(
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                        );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lot.batchCode ?? 'No batch code',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    [
                                      if (lot.expiryDate != null)
                                        'Exp ${dateFormat.format(lot.expiryDate!)}'
                                      else
                                        'No expiry',
                                      'Cost ${CurrencyFormatter.format(lot.unitCost)}',
                                      if (lot.manufactureDate != null)
                                        'Mfg ${dateFormat.format(lot.manufactureDate!)}',
                                      'Received ${dateTimeFormat.format(lot.receivedAt)}',
                                    ].join(' · '),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  MeasureUnits.formatQuantity(
                                    lot.quantity,
                                    product.unit,
                                    product.sellType,
                                  ),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  lot.quantity <= 0
                                      ? 'Depleted'
                                      : sellsNext
                                      ? 'Sells next'
                                      : expired
                                      ? 'Expired'
                                      : 'Available',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: lot.quantity <= 0
                                        ? theme.colorScheme.onSurfaceVariant
                                        : expired
                                        ? theme.colorScheme.error
                                        : sellsNext
                                        ? theme.colorScheme.primary
                                        : null,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Purchase history',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (detail.purchases.isEmpty)
                  Text(
                    'No purchases yet for this product.',
                    style: theme.textTheme.bodySmall,
                  )
                else
                  ...detail.purchases.map((row) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Symbols.local_shipping, size: 18),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${row.invoiceNo} · ${row.supplierName}',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  [
                                    dateFormat.format(row.purchaseDate),
                                    '${row.quantity} pcs',
                                    'Cost ${CurrencyFormatter.format(row.unitCost)}',
                                    if (row.batchCode != null)
                                      'Batch ${row.batchCode}',
                                    if (row.expiryDate != null)
                                      'Exp ${dateFormat.format(row.expiryDate!)}',
                                    if (row.sellingPrice != null)
                                      'Sell ${CurrencyFormatter.format(row.sellingPrice!)}',
                                  ].join(' · '),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Close',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
