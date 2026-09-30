import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/field_limits.dart';
import '../../../../widgets/product_image.dart';
import '../../domain/entities/inventory_entities.dart';
import '../bloc/inventory_bloc.dart';
import '../widgets/inventory_product_detail_sheet.dart';
import '../widgets/stock_adjust_sheet.dart';
import '../widgets/stock_write_off_sheet.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<InventoryBloc>()..add(const InventoryStarted()),
      child: BlocListener<NotificationsCubit, NotificationsState>(
        listenWhen: (previous, current) =>
            previous.undoRevision != current.undoRevision &&
            current.lastUndoActionType == NotificationTypes.restoreProduct,
        listener: (context, state) {
          context.read<InventoryBloc>().add(const InventoryRefreshRequested());
        },
        child: const _InventoryView(),
      ),
    );
  }
}

class _InventoryView extends StatelessWidget {
  const _InventoryView();

  Future<void> _openAdjustSheet(
    BuildContext context, {
    required InventoryProduct product,
    bool openingStock = false,
  }) async {
    final result = await showStockAdjustSheet(
      context: context,
      product: product,
      openingStock: openingStock,
    );
    if (result == null || !context.mounted) return;
    context.read<InventoryBloc>().add(
      InventoryAdjustRequested(
        StockAdjustRequest(
          productId: product.id,
          quantityChange: result.quantityChange,
          type: result.type,
          note: result.note,
          expiryDate: result.expiryDate,
          manufactureDate: result.manufactureDate,
          batchCode: result.batchCode,
          purchasePrice: result.purchasePrice,
          sellingPrice: result.sellingPrice,
          wholesalePrice: result.wholesalePrice,
          itemsPerBox: result.itemsPerBox,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryBloc, InventoryState>(
      listenWhen: (prev, curr) =>
          curr is InventoryLoaded && curr.message != null,
      listener: (context, state) {
        if (state is InventoryLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<InventoryBloc>().add(const InventoryMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          InventoryInitial() || InventoryLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          InventoryError(:final message) => EmptyState(
            title: 'Inventory unavailable',
            message: message,
            icon: Symbols.warehouse,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<InventoryBloc>().add(const InventoryStarted()),
            ),
          ),
          InventoryLoaded() => _InventoryLoadedView(
            state: state,
            onAdjust: _openAdjustSheet,
          ),
        };
      },
    );
  }
}

class _InventoryLoadedView extends StatelessWidget {
  const _InventoryLoadedView({required this.state, required this.onAdjust});

  final InventoryLoaded state;
  final Future<void> Function(
    BuildContext context, {
    required InventoryProduct product,
    bool openingStock,
  })
  onAdjust;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = state.visibleProducts;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppSearchField(
                  width: double.infinity,
                  hintText: 'Search stock by name, SKU, category…',
                  onChanged: (value) => context.read<InventoryBloc>().add(
                    InventorySearchChanged(value),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.secondary,
                icon: Symbols.refresh,
                onPressed: () => context.read<InventoryBloc>().add(
                  const InventoryRefreshRequested(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: 'Products',
                value: '${state.products.length}',
                icon: Symbols.inventory_2,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Stock value',
                value: CurrencyFormatter.format(state.totalStockValue),
                icon: Symbols.payments,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Low stock',
                value: '${state.lowStockCount}',
                icon: Symbols.warning,
                highlight: true,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Expired',
                value: '${state.expiredCount}',
                icon: Symbols.event_busy,
                highlight: state.expiredCount > 0,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<InventoryTab>(
            segments: const [
              ButtonSegment(
                value: InventoryTab.stock,
                label: Text('Stock'),
                icon: Icon(Symbols.inventory_2, size: 18),
              ),
              ButtonSegment(
                value: InventoryTab.history,
                label: Text('History'),
                icon: Icon(Symbols.history, size: 18),
              ),
            ],
            selected: {state.tab},
            onSelectionChanged: (value) {
              context.read<InventoryBloc>().add(
                InventoryTabChanged(value.first),
              );
            },
          ),
          if (state.tab == InventoryTab.stock) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ScrollableChipWrap(
                    maxLines: 2,
                    children: InventoryListFilter.values
                        .map(
                          (filter) => FilterChip(
                            label: Text(_inventoryFilterLabel(filter)),
                            selected: state.filter == filter,
                            onSelected: (_) => context
                                .read<InventoryBloc>()
                                .add(InventoryFilterChanged(filter)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                PopupMenuButton<InventoryListSort>(
                  tooltip: 'Sort stock',
                  initialValue: state.sort,
                  onSelected: (sort) => context.read<InventoryBloc>().add(
                    InventorySortChanged(sort),
                  ),
                  itemBuilder: (context) => InventoryListSort.values
                      .map(
                        (sort) => CheckedPopupMenuItem(
                          value: sort,
                          checked: state.sort == sort,
                          child: Text(_inventorySortLabel(sort)),
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
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.sort,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Sort', style: theme.textTheme.labelLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${visible.length} shown · ${_inventorySortLabel(state.sort)}'
              '${state.expiringSoonCount > 0 ? ' · ${state.expiringSoonCount} expiring soon' : ''}',
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: switch (state.tab) {
              InventoryTab.history => _HistoryList(movements: state.movements),
              InventoryTab.stock => _StockList(
                products: visible,
                filter: state.filter,
                onAdjust: onAdjust,
                onOpen: (product) => showInventoryProductDetailSheet(
                  context: context,
                  product: product,
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}

String _inventoryFilterLabel(InventoryListFilter filter) => switch (filter) {
  InventoryListFilter.all => 'All',
  InventoryListFilter.lowStock => 'Low stock',
  InventoryListFilter.outOfStock => 'Out of stock',
  InventoryListFilter.expired => 'Expired',
  InventoryListFilter.expiringSoon => 'Expiring soon',
  InventoryListFilter.noExpiry => 'No expiry',
  InventoryListFilter.inactive => 'Inactive',
};

String _inventorySortLabel(InventoryListSort sort) => switch (sort) {
  InventoryListSort.nameAsc => 'Name A–Z',
  InventoryListSort.nameDesc => 'Name Z–A',
  InventoryListSort.stockLowHigh => 'Stock low → high',
  InventoryListSort.stockHighLow => 'Stock high → low',
  InventoryListSort.valueHighLow => 'Value high → low',
  InventoryListSort.expirySoonest => 'Expiry soonest',
  InventoryListSort.expiryLatest => 'Expiry latest',
};

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: highlight ? AppColors.warning : theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelMedium),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockList extends StatelessWidget {
  const _StockList({
    required this.products,
    required this.filter,
    required this.onAdjust,
    required this.onOpen,
  });

  final List<InventoryProduct> products;
  final InventoryListFilter filter;
  final Future<void> Function(
    BuildContext context, {
    required InventoryProduct product,
    bool openingStock,
  })
  onAdjust;
  final ValueChanged<InventoryProduct> onOpen;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return EmptyState(
        title: filter == InventoryListFilter.all ? 'No products' : 'No matches',
        message: filter == InventoryListFilter.all
            ? 'Add products first, then manage stock here.'
            : 'Nothing matches this filter. Try another filter or clear search.',
        icon: Symbols.warehouse,
      );
    }

    final dateFormat = DateFormat('dd MMM yyyy');

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final product = products[index];
        final expiry = product.expiryDate;
        return AppCard(
          onTap: () => onOpen(product),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ProductImage(path: product.imagePath, size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${product.sku} · ${product.category}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Value ${CurrencyFormatter.format(product.stockValue)}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      '${product.activeBatchCount} active ${product.activeBatchCount == 1 ? 'batch' : 'batches'} · Tap to view all',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (expiry != null)
                      Text(
                        product.isExpired
                            ? 'Expired ${dateFormat.format(expiry)}'
                            : product.isExpiringSoon()
                            ? 'Expires ${dateFormat.format(expiry)}'
                            : 'Expiry ${dateFormat.format(expiry)}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: product.isExpired
                              ? AppColors.danger
                              : product.isExpiringSoon()
                              ? AppColors.warning
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.formattedStock,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: product.isOutOfStock
                          ? AppColors.danger
                          : product.isLowStock
                          ? AppColors.warning
                          : null,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    product.isVariable ? 'on hand' : 'units',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  if (product.isExpired)
                    Text(
                      'Expired',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else if (product.isExpiringSoon())
                    Text(
                      'Expiring soon',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              PopupMenuButton<String>(
                tooltip: 'Stock actions',
                onSelected: (value) async {
                  switch (value) {
                    case 'adjust':
                      onAdjust(context, product: product);
                    case 'opening':
                      onAdjust(context, product: product, openingStock: true);
                    case 'write_off':
                      final changed = await showStockWriteOffSheet(
                        context,
                        product: product,
                      );
                      if (changed && context.mounted) {
                        context.read<InventoryBloc>().add(
                          const InventoryRefreshRequested(),
                        );
                      }
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'adjust',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Symbols.tune, size: 18),
                      title: Text('Adjust stock'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'write_off',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Symbols.delete_sweep, size: 18),
                      title: Text('Damaged / wasted stock'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'opening',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Symbols.playlist_add, size: 18),
                      title: Text('Set opening stock'),
                    ),
                  ),
                ],
                icon: const Icon(Symbols.more_vert),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.movements});

  final List<StockMovementItem> movements;

  @override
  Widget build(BuildContext context) {
    if (movements.isEmpty) {
      return const EmptyState(
        title: 'No stock history yet',
        message: 'Adjustments, opening stock, and POS sales will appear here.',
        icon: Symbols.history,
      );
    }

    final formatter = DateFormat('dd MMM yyyy · HH:mm');

    return ListView.separated(
      itemCount: movements.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final movement = movements[index];
        final changeText = movement.quantityChange >= 0
            ? '+${movement.quantityChange}'
            : '${movement.quantityChange}';
        final changeColor = movement.quantityChange >= 0
            ? AppColors.success
            : AppColors.warning;

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movement.productName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${movement.productSku} · ${_typeLabel(movement.type)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (movement.note != null)
                      Text(
                        movement.note!,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    Text(
                      formatter.format(movement.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    changeText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: changeColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'After ${movement.quantityAfter}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _typeLabel(String type) {
    return switch (type) {
      'opening' => 'Opening stock',
      'adjustment' => 'Adjustment',
      'sale' => 'POS sale',
      'purchase' => 'Purchase',
      _ => type,
    };
  }
}
