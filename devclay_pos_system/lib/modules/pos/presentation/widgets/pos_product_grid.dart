import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_durations.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_shadows.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/measure_units.dart';
import '../../../../widgets/product_image.dart';
import '../../domain/entities/pos_entities.dart';
import '../bloc/pos_bloc.dart';
import 'pos_item_colors.dart';

enum PosProductLayout { grid, list }

class PosProductGrid extends StatelessWidget {
  const PosProductGrid({
    super.key,
    required this.products,
    required this.cartQuantities,
    this.layout = PosProductLayout.grid,
  });

  final List<PosProduct> products;
  final Map<int, int> cartQuantities;
  final PosProductLayout layout;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.search_off,
              size: 40,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No products match your search.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (layout == PosProductLayout.list) {
      return ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.xs),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final product = products[index];
          final cartQty = cartQuantities[product.id] ?? 0;
          return _ProductTile(
            product: product,
            cartQty: cartQty,
            layout: layout,
          );
        },
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xs),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 156,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        final cartQty = cartQuantities[product.id] ?? 0;
        return _ProductTile(product: product, cartQty: cartQty, layout: layout);
      },
    );
  }
}

Widget _statusBadge({
  required BuildContext context,
  required PosProductVisual visual,
}) {
  final label = visual.badgeLabel;
  if (label == null) return const SizedBox.shrink();
  final theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: visual.accent,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 10,
      ),
    ),
  );
}

Widget _stockBadge({
  required BuildContext context,
  required int availableStock,
  required PosProductVisual visual,
  PosProduct? product,
}) {
  final theme = Theme.of(context);
  final outOfStock = availableStock <= 0;
  final Color bg;
  final Color fg;
  if (outOfStock || visual.status == PosStockStatus.expired) {
    bg = AppColors.danger.withValues(alpha: 0.92);
    fg = Colors.white;
  } else if (visual.status == PosStockStatus.lowStock) {
    bg = AppColors.warning.withValues(alpha: 0.92);
    fg = Colors.white;
  } else {
    bg = const Color(0xFF1E293B).withValues(alpha: 0.82);
    fg = Colors.white;
  }
  final label = outOfStock
      ? 'Out'
      : product != null && product.isVariable
      ? MeasureUnits.formatStock(
          availableStock,
          product.unit,
          product.sellTypeEnum,
        )
      : '$availableStock';
  return AnimatedSwitcher(
    duration: AppDurations.fast,
    transitionBuilder: (child, animation) => ScaleTransition(
      scale: animation,
      child: FadeTransition(opacity: animation, child: child),
    ),
    child: Container(
      key: ValueKey(label),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    ),
  );
}

Widget _buildListContent({
  required BuildContext context,
  required PosProduct product,
  required PosProductVisual visual,
  required int availableStock,
  required int cartQty,
}) {
  final theme = Theme.of(context);
  final expiry = product.expiryDate;
  final brandOrMaker = [
    product.brand,
    product.manufacturer,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).firstOrNull;
  final meta = [
    product.category,
    ?brandOrMaker,
    if (product.sku.trim().isNotEmpty) product.sku,
  ].join(' · ');

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProductImage(
          path: product.imagePath,
          size: 52,
          borderRadius: AppRadii.sm,
          backgroundColor: visual.fill,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                  ),
                  if (visual.badgeLabel != null) ...[
                    const SizedBox(width: 6),
                    _statusBadge(context: context, visual: visual),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                meta,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              if (expiry != null) ...[
                Text(
                  product.isExpired
                      ? 'Expired · ${_dateLabel(expiry)}'
                      : 'Expiry ${_dateLabel(expiry)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: product.isExpired
                        ? AppColors.danger
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ],
              if (product.batches.length > 1)
                Text(
                  '${product.batches.length} batches · automatic FEFO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              CurrencyFormatter.format(product.sellingPrice),
              style: theme.textTheme.titleMedium?.copyWith(
                color: visual.isAlert
                    ? visual.accent
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            _stockBadge(
              context: context,
              availableStock: availableStock,
              visual: visual,
              product: product,
            ),
            if (cartQty > 0) ...[
              const SizedBox(height: 2),
              Text(
                '${_cartQtyLabel(product, cartQty)} in cart',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/${date.year}';

String _cartQtyLabel(PosProduct product, int cartQtyBase) {
  if (cartQtyBase <= 0) return '';
  if (product.isVariable) {
    return MeasureUnits.formatQuantity(
      cartQtyBase,
      product.unit,
      product.sellTypeEnum,
    );
  }
  return '$cartQtyBase';
}

String _gridMetaLabel(PosProduct product) {
  return [
    product.category,
    product.manufacturer,
  ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' · ');
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.cartQty,
    required this.layout,
  });

  final PosProduct product;
  final int cartQty;
  final PosProductLayout layout;

  void _addProduct(BuildContext context) async {
    var product = this.product;
    if (product.hasVariants && product.variants.isNotEmpty) {
      final picked = await showDialog<PosVariantOption>(
        context: context,
        builder: (context) => _VariantPickDialog(product: product),
      );
      if (picked == null || !context.mounted) return;
      product = PosProduct(
        id: product.id,
        sku: picked.sku?.isNotEmpty == true ? picked.sku! : product.sku,
        barcode:
            picked.barcode?.isNotEmpty == true ? picked.barcode! : product.barcode,
        name: '${product.name} (${picked.label})',
        category: product.category,
        brand: product.brand,
        manufacturer: product.manufacturer,
        unit: product.unit,
        sellType: product.sellType,
        itemsPerBox: product.itemsPerBox,
        sellingPrice: picked.priceOverride > 0
            ? picked.priceOverride
            : product.sellingPrice,
        wholesalePrice: product.wholesalePrice,
        purchasePrice: product.purchasePrice,
        taxRate: product.taxRate,
        taxInclusive: product.taxInclusive,
        stock: picked.stock,
        lowStockThreshold: product.lowStockThreshold,
        expiryDate: product.expiryDate,
        imagePath: product.imagePath,
        batches: product.batches,
        hasVariants: true,
        variants: product.variants,
        selectedVariantId: picked.id,
      );
    }
    if (!context.mounted) return;
    context.read<PosBloc>().add(PosProductAdded(product));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cartQty = this.cartQty;
    final availableStock = (product.stock - cartQty).clamp(0, product.stock);
    final visual = PosProductVisual.forProduct(
      context,
      product,
      availableStock: availableStock,
    );
    final unavailable = availableStock <= 0;
    final panelColor = isDark ? AppColors.darkCard : Colors.white;
    final panelBorder = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : const Color(0xFFD5DCE8);
    final cardShadow = unavailable
        ? AppShadows.sm(theme.brightness)
        : [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: unavailable ? null : () => _addProduct(context),
        borderRadius: AppRadii.mdAll,
        child: Container(
          padding: layout == PosProductLayout.list
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 7)
              : const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: visual.status == PosStockStatus.normal
                ? panelColor
                : visual.fill,
            borderRadius: AppRadii.mdAll,
            border: Border.all(
              color: visual.border,
              width: visual.isAlert ? 1.5 : 1.1,
            ),
            boxShadow: cardShadow,
          ),
          child: Opacity(
            opacity: unavailable ? 0.62 : 1,
            child: layout == PosProductLayout.list
                ? _buildListContent(
                    context: context,
                    product: product,
                    visual: visual,
                    availableStock: availableStock,
                    cartQty: cartQty,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.darkSurfaceMuted
                                      : const Color(0xFFF4F6FA),
                                  borderRadius: AppRadii.smAll,
                                  border: Border.all(
                                    color: panelBorder.withValues(alpha: 0.7),
                                  ),
                                ),
                                child: ProductImage(
                                  path: product.imagePath,
                                  size: double.infinity,
                                  borderRadius: AppRadii.sm,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: _stockBadge(
                                context: context,
                                availableStock: availableStock,
                                visual: visual,
                                product: product,
                              ),
                            ),
                            if (visual.badgeLabel != null)
                              Positioned(
                                left: 5,
                                bottom: 5,
                                child: _statusBadge(
                                  context: context,
                                  visual: visual,
                                ),
                              ),
                            if (cartQty > 0)
                              Positioned(
                                top: 5,
                                left: 5,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.92,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    _cartQtyLabel(product, cartQty),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (_gridMetaLabel(product).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            _gridMetaLabel(product),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 9,
                              height: 1.15,
                            ),
                          ),
                        ),
                      if (product.batches.length > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            '${product.batches.length} batches · automatic FEFO',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceMuted
                              : const Color(0xFFF1F4F9),
                          borderRadius: AppRadii.xsAll,
                          border: Border.all(color: panelBorder),
                        ),
                        child: Text(
                          CurrencyFormatter.format(product.sellingPrice),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: visual.isAlert
                                ? visual.accent
                                : theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _VariantPickDialog extends StatefulWidget {
  const _VariantPickDialog({required this.product});

  final PosProduct product;

  @override
  State<_VariantPickDialog> createState() => _VariantPickDialogState();
}

class _VariantPickDialogState extends State<_VariantPickDialog> {
  String? _size;

  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants;
    final sizes = variants.map((v) => v.size).toSet().toList()..sort();
    final colors = variants
        .where((v) => _size == null || v.size == _size)
        .map((v) => v.color)
        .toSet()
        .toList()
      ..sort();

    return AlertDialog(
      title: Text('Size & color — ${widget.product.name}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final size in sizes)
                  ChoiceChip(
                    label: Text(size),
                    selected: _size == size,
                    onSelected: (_) => setState(() => _size = size),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final color in colors)
                  ActionChip(
                    label: Text(color),
                    onPressed: _size == null
                        ? null
                        : () {
                            final match = variants.firstWhere(
                              (v) => v.size == _size && v.color == color,
                            );
                            Navigator.pop(context, match);
                          },
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
