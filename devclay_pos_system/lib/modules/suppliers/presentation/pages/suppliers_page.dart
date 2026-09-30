import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../routes/app_routes.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../../purchases/presentation/widgets/purchase_payment_sheet.dart';
import '../../../purchases/presentation/widgets/supplier_editor_sheet.dart';
import '../../domain/entities/supplier_entities.dart';
import '../bloc/suppliers_bloc.dart';
import '../../../../widgets/app_toast.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuppliersBloc>()..add(const SuppliersStarted()),
      child: const _SuppliersView(),
    );
  }
}

class _SuppliersView extends StatelessWidget {
  const _SuppliersView();

  SupplierItem _toItem(SupplierProfile profile) {
    return SupplierItem(
      id: profile.id,
      name: profile.name,
      phone: profile.phone,
      isActive: profile.isActive,
      balance: profile.balance,
      email: profile.email,
      address: profile.address,
      notes: profile.notes,
    );
  }

  Future<void> _openEditor(
    BuildContext context, {
    SupplierProfile? existing,
  }) async {
    final draft = await showSupplierEditorSheet(
      context: context,
      existing: existing == null ? null : _toItem(existing),
    );
    if (draft == null || !context.mounted) return;
    context.read<SuppliersBloc>().add(
      SupplierSaved(draft: draft, id: existing?.id),
    );
  }

  Future<void> _openPaymentSheet(
    BuildContext context,
    SupplierPurchaseSummary purchase,
  ) async {
    final amount = await showPurchasePaymentSheet(
      context: context,
      invoiceNo: purchase.invoiceNo,
      dueAmount: purchase.dueAmount,
    );
    if (amount == null || !context.mounted) return;
    context.read<SuppliersBloc>().add(
      SupplierPurchasePaymentRecorded(purchaseId: purchase.id, amount: amount),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SupplierProfile supplier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Symbols.delete, color: AppColors.danger),
        title: const Text('Delete supplier?'),
        content: Text(
          'Are you sure you want to delete "${supplier.name}"?\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<SuppliersBloc>().add(SupplierDeleted(supplier.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuppliersBloc, SuppliersState>(
      listenWhen: (prev, curr) =>
          curr is SuppliersLoaded && curr.message != null,
      listener: (context, state) {
        if (state is SuppliersLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<SuppliersBloc>().add(const SuppliersMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          SuppliersInitial() || SuppliersLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          SuppliersError(:final message) => EmptyState(
            title: 'Suppliers unavailable',
            message: message,
            icon: Symbols.local_shipping,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<SuppliersBloc>().add(const SuppliersStarted()),
            ),
          ),
          SuppliersLoaded() => _SuppliersLoadedView(
            state: state,
            onAdd: () => _openEditor(context),
            onEdit: (supplier) => _openEditor(context, existing: supplier),
            onTapSupplier: (supplier) => context.read<SuppliersBloc>().add(
              SupplierPurchasesRequested(supplier.id),
            ),
            onDelete: (supplier) => _confirmDelete(context, supplier),
            onPayDue: (purchase) => _openPaymentSheet(context, purchase),
          ),
        };
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Sort label helper
// ---------------------------------------------------------------------------
String _sortLabel(SuppliersSort sort) {
  return switch (sort) {
    SuppliersSort.nameAZ => 'Name A → Z',
    SuppliersSort.nameZA => 'Name Z → A',
    SuppliersSort.recentlyAdded => 'Recently added',
    SuppliersSort.oldestFirst => 'Oldest first',
    SuppliersSort.highestDue => 'Highest give',
    SuppliersSort.highestPurchase => 'Top purchased',
  };
}

IconData _sortIcon(SuppliersSort sort) {
  return switch (sort) {
    SuppliersSort.nameAZ => Symbols.sort_by_alpha,
    SuppliersSort.nameZA => Symbols.sort_by_alpha,
    SuppliersSort.recentlyAdded => Symbols.schedule,
    SuppliersSort.oldestFirst => Symbols.history,
    SuppliersSort.highestDue => Symbols.payments,
    SuppliersSort.highestPurchase => Symbols.trending_up,
  };
}

class _SuppliersLoadedView extends StatelessWidget {
  const _SuppliersLoadedView({
    required this.state,
    required this.onAdd,
    required this.onEdit,
    required this.onTapSupplier,
    required this.onDelete,
    required this.onPayDue,
  });

  final SuppliersLoaded state;
  final VoidCallback onAdd;
  final ValueChanged<SupplierProfile> onEdit;
  final ValueChanged<SupplierProfile> onTapSupplier;
  final ValueChanged<SupplierProfile> onDelete;
  final ValueChanged<SupplierPurchaseSummary> onPayDue;

  @override
  Widget build(BuildContext context) {
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
                  hintText: 'Search supplier name, phone, address…',
                  onChanged: (value) => context.read<SuppliersBloc>().add(
                    SuppliersSearchChanged(value),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Add supplier',
                icon: Symbols.local_shipping,
                onPressed: onAdd,
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Purchases',
                variant: AppButtonVariant.secondary,
                icon: Symbols.assignment,
                onPressed: () => context.go(AppRoutes.purchases),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: 'Suppliers',
                value: '${state.suppliers.length}',
                icon: Symbols.local_shipping,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Total purchased',
                value: CurrencyFormatter.format(state.totalPurchased),
                icon: Symbols.receipt_long,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'To give',
                value: CurrencyFormatter.format(state.totalDue),
                icon: Symbols.payments,
                highlight: state.totalDue > 0,
                highlightColor: KhataBalanceRules.giveColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Tabs + Sort row
          Row(
            children: [
              Expanded(
                child: SegmentedButton<SuppliersTab>(
                  segments: const [
                    ButtonSegment(
                      value: SuppliersTab.all,
                      label: Text('All'),
                      icon: Icon(Symbols.local_shipping, size: 18),
                    ),
                    ButtonSegment(
                      value: SuppliersTab.active,
                      label: Text('Active'),
                      icon: Icon(Symbols.check_circle, size: 18),
                    ),
                    ButtonSegment(
                      value: SuppliersTab.withDue,
                      label: Text('To give'),
                      icon: Icon(Symbols.payments, size: 18),
                    ),
                    ButtonSegment(
                      value: SuppliersTab.topSuppliers,
                      label: Text('Top'),
                      icon: Icon(Symbols.trending_up, size: 18),
                    ),
                  ],
                  selected: {state.tab},
                  onSelectionChanged: (value) {
                    context.read<SuppliersBloc>().add(
                      SuppliersTabChanged(value.first),
                    );
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Sort dropdown
              PopupMenuButton<SuppliersSort>(
                initialValue: state.sort,
                tooltip: 'Sort suppliers',
                onSelected: (sort) {
                  context.read<SuppliersBloc>().add(
                    SuppliersSortChanged(sort),
                  );
                },
                itemBuilder: (_) => SuppliersSort.values
                    .map(
                      (sort) => PopupMenuItem(
                        value: sort,
                        child: Row(
                          children: [
                            Icon(
                              _sortIcon(sort),
                              size: 18,
                              color: sort == state.sort
                                  ? AppColors.accent
                                  : null,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              _sortLabel(sort),
                              style: sort == state.sort
                                  ? TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                child: AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_sortIcon(state.sort), size: 18),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _sortLabel(state.sort),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Icon(Symbols.arrow_drop_down, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _SuppliersList(
                    suppliers: state.visibleSuppliers,
                    selectedId: state.selectedSupplierId,
                    onEdit: onEdit,
                    onTap: onTapSupplier,
                    onDelete: onDelete,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: _SupplierPurchasesPanel(
                    supplierName: state.selectedSupplierName,
                    purchases: state.selectedPurchases,
                    onPayDue: onPayDue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuppliersList extends StatelessWidget {
  const _SuppliersList({
    required this.suppliers,
    required this.selectedId,
    required this.onEdit,
    required this.onTap,
    required this.onDelete,
  });

  final List<SupplierProfile> suppliers;
  final int? selectedId;
  final ValueChanged<SupplierProfile> onEdit;
  final ValueChanged<SupplierProfile> onTap;
  final ValueChanged<SupplierProfile> onDelete;

  @override
  Widget build(BuildContext context) {
    if (suppliers.isEmpty) {
      return const EmptyState(
        title: 'No suppliers yet',
        message: 'Add wholesalers and distributors you buy stock from.',
        icon: Symbols.local_shipping,
      );
    }

    final dateFormat = DateFormat('dd MMM yyyy');

    return ListView.separated(
      itemCount: suppliers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final supplier = suppliers[index];
        final selected = supplier.id == selectedId;

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () => onTap(supplier),
          child: Container(
            decoration: selected
                ? BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColors.accent,
                        width: 3,
                      ),
                    ),
                  )
                : null,
            padding: selected
                ? const EdgeInsets.only(left: AppSpacing.sm)
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: selected
                          ? AppColors.accent.withValues(alpha: 0.18)
                          : Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.12),
                      child: const Icon(Symbols.local_shipping, size: 18),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplier.name,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: selected ? AppColors.accent : null,
                                ),
                          ),
                          if (supplier.phone.trim().isNotEmpty)
                            Text(
                              supplier.phone,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (supplier.address != null)
                            Text(
                              supplier.address!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          Text(
                            '${supplier.purchaseCount} purchases · ${CurrencyFormatter.format(supplier.totalPurchased)}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          if (supplier.lastPurchaseDate != null)
                            Text(
                              'Last purchase ${dateFormat.format(supplier.lastPurchaseDate!)}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          KhataBalanceRules.supplierNetLabel(supplier.totalDue),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: KhataBalanceRules.colorForSupplier(
                                  supplier.totalDue,
                                ),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          KhataBalanceRules.statusLabelForSupplier(
                            supplier.totalDue,
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        if (!supplier.isActive)
                          const Chip(
                            label: Text('Inactive'),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    AppButton(
                      label: 'Edit',
                      variant: AppButtonVariant.ghost,
                      icon: Symbols.edit,
                      onPressed: () => onEdit(supplier),
                    ),
                    AppButton(
                      label: 'Delete',
                      variant: AppButtonVariant.ghost,
                      icon: Symbols.delete,
                      onPressed: () => onDelete(supplier),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SupplierPurchasesPanel extends StatelessWidget {
  const _SupplierPurchasesPanel({
    required this.supplierName,
    required this.purchases,
    required this.onPayDue,
  });

  final String? supplierName;
  final List<SupplierPurchaseSummary> purchases;
  final ValueChanged<SupplierPurchaseSummary> onPayDue;

  @override
  Widget build(BuildContext context) {
    if (supplierName == null) {
      return AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.touch_app,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tap a supplier to view\npurchase history & give/take',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final formatter = DateFormat('dd MMM yyyy');
    final total = purchases.fold(0.0, (sum, item) => sum + item.total);
    final due = purchases.fold(0.0, (sum, item) => sum + item.dueAmount);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                child: const Icon(Symbols.local_shipping, size: 16),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  supplierName!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Summary row
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${purchases.length} purchases',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Text(
                        CurrencyFormatter.format(total),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      KhataBalanceRules.statusLabelForSupplier(due),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      KhataBalanceRules.supplierNetLabel(due),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: KhataBalanceRules.colorForSupplier(due),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Purchase history',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: purchases.isEmpty
                ? Center(
                    child: Text(
                      'No purchases linked yet.\nCreate one from Purchases.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    itemCount: purchases.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final purchase = purchases[index];
                      return Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status indicator
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: KhataBalanceRules.colorForPayable(
                                  purchase.dueAmount,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    purchase.invoiceNo,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  Text(
                                    formatter.format(purchase.purchaseDate),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  CurrencyFormatter.format(purchase.total),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                if (purchase.dueAmount > 0)
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () => onPayDue(purchase),
                                    child: Text(
                                      KhataBalanceRules.payableLabel(
                                        purchase.dueAmount,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium?.copyWith(
                                        color: KhataBalanceRules.giveColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    'Settled',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: KhataBalanceRules.settledColor,
                                        ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
    this.highlightColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = highlight
        ? (highlightColor ?? KhataBalanceRules.giveColor)
        : theme.colorScheme.primary;
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: accent,
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
