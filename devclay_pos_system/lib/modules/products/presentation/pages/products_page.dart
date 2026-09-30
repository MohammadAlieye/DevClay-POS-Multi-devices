import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/store_profile/store_profile_service.dart';
import '../../../../core/store_profile/store_profiles.dart';
import '../../../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../../modules/settings/domain/repositories/settings_repository.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/field_limits.dart';
import '../../../../widgets/product_image.dart';
import '../../domain/entities/product_item.dart';
import '../../domain/repositories/products_repository.dart';
import '../bloc/products_bloc.dart';
import '../widgets/product_details_sheet.dart';
import '../widgets/product_editor_sheet.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductsBloc>()..add(const ProductsStarted()),
      child: BlocListener<NotificationsCubit, NotificationsState>(
        listenWhen: (previous, current) =>
            previous.undoRevision != current.undoRevision &&
            current.lastUndoActionType == NotificationTypes.restoreProduct,
        listener: (context, state) {
          context.read<ProductsBloc>().add(const ProductsRefreshRequested());
        },
        child: const _ProductsView(),
      ),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  Future<void> _openEditor(
    BuildContext context, {
    ProductItem? existing,
    required List<String> categories,
    required List<ProductItem> products,
  }) async {
    List<String> units = DefaultProductUnits.all;
    var taxEnabled = true;
    var defaultTaxRate = 17.0;
    var defaultTaxInclusive = true;
    try {
      final settings = await sl<SettingsRepository>().getSettings();
      units = settings.productUnits;
      taxEnabled = settings.taxEnabled;
      defaultTaxRate = settings.defaultTaxRate;
      defaultTaxInclusive = settings.defaultTaxInclusive;
    } catch (_) {
      // Fall back to defaults if settings are unavailable.
    }
    if (!context.mounted) return;
    final flags = await sl<StoreProfileService>().currentFlags();
    final profileId = await sl<StoreProfileService>().currentProfileId();
    if (!context.mounted) return;
    final draft = await showProductEditorSheet(
      context: context,
      categories: categories,
      products: products,
      units: units,
      existing: existing,
      taxEnabled: taxEnabled,
      defaultTaxRate: defaultTaxRate,
      defaultTaxInclusive: defaultTaxInclusive,
      enableVariants: flags.enableProductVariants,
      showStrength: profileId == StoreProfileId.pharmacy,
      preferVolumeUnits: flags.preferVolumeUnits,
    );
    if (draft == null || !context.mounted) return;
    context.read<ProductsBloc>().add(
      ProductSaved(draft: draft, id: existing?.id),
    );
  }

  Future<void> _openDetails(
    BuildContext context, {
    required ProductItem product,
    required List<String> categories,
    required List<ProductItem> products,
  }) {
    return showProductDetailsSheet(
      context: context,
      product: product,
      onEdit: () => _openEditor(
        context,
        existing: product,
        categories: categories,
        products: products,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listenWhen: (prev, curr) =>
          curr is ProductsLoaded && curr.message != null,
      listener: (context, state) {
        if (state is ProductsLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<ProductsBloc>().add(const ProductsMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          ProductsInitial() ||
          ProductsLoading() => const Center(child: CircularProgressIndicator()),
          ProductsError(:final message) => EmptyState(
            title: 'Products unavailable',
            message: message,
            icon: Symbols.inventory_2,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<ProductsBloc>().add(const ProductsStarted()),
            ),
          ),
          ProductsLoaded loaded => Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        width: double.infinity,
                        hintText: 'Search products by name, SKU, barcode…',
                        onChanged: (value) => context.read<ProductsBloc>().add(
                          ProductsSearchChanged(value),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppButton(
                      label: 'Add product',
                      icon: Symbols.add,
                      onPressed: () => _openEditor(
                        context,
                        categories: loaded.categories,
                        products: loaded.products,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ScrollableChipWrap(
                        maxLines: 2,
                        children: ProductsListFilter.values
                            .map(
                              (item) => FilterChip(
                                label: Text(_productsFilterLabel(item)),
                                selected: loaded.filter == item,
                                onSelected: (_) => context
                                    .read<ProductsBloc>()
                                    .add(ProductsFilterChanged(item)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    PopupMenuButton<ProductsListSort>(
                      tooltip: 'Sort products',
                      initialValue: loaded.sort,
                      onSelected: (value) => context.read<ProductsBloc>().add(
                        ProductsSortChanged(value),
                      ),
                      itemBuilder: (context) => ProductsListSort.values
                          .map(
                            (item) => CheckedPopupMenuItem(
                              value: item,
                              checked: loaded.sort == item,
                              child: Text(_productsSortLabel(item)),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Symbols.sort,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Sort',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  loaded.query.isEmpty
                      ? '${loaded.visibleProducts.length} products · ${_productsSortLabel(loaded.sort)}'
                      : '${loaded.visibleProducts.length} results for "${loaded.query}"',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: loaded.visibleProducts.isEmpty
                      ? EmptyState(
                          title:
                              loaded.filter == ProductsListFilter.all &&
                                  loaded.query.isEmpty
                              ? 'No products yet'
                              : 'No matches',
                          message:
                              loaded.filter == ProductsListFilter.all &&
                                  loaded.query.isEmpty
                              ? 'Add the catalog item first. Set prices when you receive stock in Purchases.'
                              : 'Try another filter, sort, or search.',
                          icon: Symbols.package_2,
                          action:
                              loaded.filter == ProductsListFilter.all &&
                                  loaded.query.isEmpty
                              ? AppButton(
                                  label: 'Add product',
                                  onPressed: () => _openEditor(
                                    context,
                                    categories: loaded.categories,
                                    products: loaded.products,
                                  ),
                                )
                              : null,
                        )
                      : ListView.separated(
                          itemCount: loaded.visibleProducts.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final product = loaded.visibleProducts[index];
                            return _ProductRow(
                              product: product,
                              onOpen: () => _openDetails(
                                context,
                                product: product,
                                categories: loaded.categories,
                                products: loaded.products,
                              ),
                              onEdit: () => _openEditor(
                                context,
                                existing: product,
                                categories: loaded.categories,
                                products: loaded.products,
                              ),
                              onDelete: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete product?'),
                                    content: Text(
                                      'Move "${product.name}" to the Recycle Bin? '
                                      'You can restore it later.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok != true || !context.mounted) return;
                                final id = product.id;
                                final name = product.name;
                                context.read<ProductsBloc>().add(
                                  ProductDeleted(id),
                                );
                                await sl<NotificationsCubit>().notifyRecycle(
                                  title: 'Product deleted',
                                  body: '"$name" moved to Recycle Bin',
                                  actionType: NotificationTypes.restoreProduct,
                                  entityId: id,
                                );
                                if (!context.mounted) return;
                                AppToast.withUndo(
                                  context,
                                  '"$name" moved to Recycle Bin',
                                  onUndo: () async {
                                    await sl<ProductsRepository>()
                                        .restoreProduct(id);
                                    sl<NotificationsCubit>().announceRestore(
                                      NotificationTypes.restoreProduct,
                                    );
                                    if (!context.mounted) return;
                                    AppToast.success(
                                      context,
                                      '"$name" restored',
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        };
      },
    );
  }
}

String _productsFilterLabel(ProductsListFilter filter) => switch (filter) {
  ProductsListFilter.all => 'All',
  ProductsListFilter.active => 'Active',
  ProductsListFilter.inactive => 'Inactive',
  ProductsListFilter.lowStock => 'Low stock',
  ProductsListFilter.outOfStock => 'Out of stock',
  ProductsListFilter.expired => 'Expired',
  ProductsListFilter.expiringSoon => 'Expiring soon',
  ProductsListFilter.noExpiry => 'No expiry',
};

String _productsSortLabel(ProductsListSort sort) => switch (sort) {
  ProductsListSort.nameAsc => 'Name A–Z',
  ProductsListSort.nameDesc => 'Name Z–A',
  ProductsListSort.stockLowHigh => 'Stock low → high',
  ProductsListSort.stockHighLow => 'Stock high → low',
  ProductsListSort.priceLowHigh => 'Price low → high',
  ProductsListSort.priceHighLow => 'Price high → low',
  ProductsListSort.expirySoonest => 'Expiry soonest',
  ProductsListSort.expiryLatest => 'Expiry latest',
};

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductItem product;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ProductImage(path: product.imagePath, size: 56),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: theme.textTheme.titleMedium),
                    Text(
                      '${product.sku} · ${product.barcode} · ${product.category}',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (product.brand != null || product.unit != null)
                      Text(
                        [
                          if (product.brand != null) product.brand,
                          if (product.unit != null) product.unit,
                        ].join(' · '),
                        style: theme.textTheme.bodySmall,
                      ),
                    if (product.expiryDate != null)
                      Text(
                        product.isExpired
                            ? 'Expired'
                            : product.isExpiringSoon()
                            ? 'Expiring soon'
                            : 'Has expiry date',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: product.isExpired
                              ? AppColors.danger
                              : product.isExpiringSoon()
                              ? AppColors.warning
                              : null,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(product.sellingPrice),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                  Text(
                    'Stock ${product.stock}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: product.isOutOfStock
                          ? AppColors.danger
                          : product.isLowStock
                          ? AppColors.warning
                          : null,
                    ),
                  ),
                  Text(
                    'alert ≤ ${product.lowStockThreshold}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: product.isLowStock ? AppColors.warning : null,
                    ),
                  ),
                  if (!product.isActive)
                    Text(
                      'Inactive',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              AppIconButton(
                icon: Symbols.edit,
                tooltip: 'Edit',
                onPressed: onEdit,
              ),
              AppIconButton(
                icon: Symbols.delete,
                tooltip: 'Delete',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
