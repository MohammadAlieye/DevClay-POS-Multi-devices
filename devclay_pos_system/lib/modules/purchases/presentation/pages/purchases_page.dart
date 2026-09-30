import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/supplier_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/purchase_entities.dart';
import '../bloc/purchases_bloc.dart';
import '../widgets/purchase_editor_sheet.dart';
import '../widgets/purchase_payment_sheet.dart';
import '../widgets/purchase_return_sheet.dart';
import '../widgets/supplier_balance_sheet.dart';
import '../widgets/supplier_editor_sheet.dart';
import '../widgets/supplier_history_sheet.dart';
import '../../../../widgets/app_toast.dart';

class PurchasesPage extends StatelessWidget {
  const PurchasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PurchasesBloc>()..add(const PurchasesStarted()),
      child: const _PurchasesView(),
    );
  }
}

class _PurchasesView extends StatelessWidget {
  const _PurchasesView();

  Future<void> _openPurchaseEditor(BuildContext context) async {
    final state = context.read<PurchasesBloc>().state;
    if (state is! PurchasesLoaded) return;

    final draft = await showPurchaseEditorSheet(
      context: context,
      suppliers: state.suppliers,
      products: state.products,
      supplierDue: state.supplierDue,
    );
    if (draft == null || !context.mounted) return;
    context.read<PurchasesBloc>().add(PurchaseCreated(draft));
  }

  Future<void> _openSupplierEditor(
    BuildContext context, {
    SupplierItem? existing,
  }) async {
    final draft = await showSupplierEditorSheet(
      context: context,
      existing: existing,
    );
    if (draft == null || !context.mounted) return;
    context.read<PurchasesBloc>().add(
      SupplierSaved(draft: draft, id: existing?.id),
    );
  }

  Future<void> _openPaymentSheet(
    BuildContext context,
    PurchaseRecord purchase,
  ) async {
    final amount = await showPurchasePaymentSheet(
      context: context,
      invoiceNo: purchase.invoiceNo,
      dueAmount: purchase.dueAmount,
    );
    if (amount == null || !context.mounted) return;
    context.read<PurchasesBloc>().add(
      PurchasePaymentRecorded(purchaseId: purchase.id, amount: amount),
    );
  }

  Future<void> _openPurchaseReturn(
    BuildContext context,
    PurchaseRecord purchase,
  ) async {
    final changed = await showPurchaseReturnSheet(context, purchase);
    if (changed && context.mounted) {
      context.read<PurchasesBloc>().add(const PurchasesRefreshRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchasesBloc, PurchasesState>(
      listenWhen: (prev, curr) =>
          curr is PurchasesLoaded && curr.message != null,
      listener: (context, state) {
        if (state is PurchasesLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<PurchasesBloc>().add(const PurchasesMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          PurchasesInitial() || PurchasesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          PurchasesError(:final message) => EmptyState(
            title: 'Purchases unavailable',
            message: message,
            icon: Symbols.assignment,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<PurchasesBloc>().add(const PurchasesStarted()),
            ),
          ),
          PurchasesLoaded loaded => _PurchasesLoadedView(
            state: loaded,
            onNewPurchase: () => _openPurchaseEditor(context),
            onNewSupplier: () => _openSupplierEditor(context),
            onEditSupplier: (supplier) =>
                _openSupplierEditor(context, existing: supplier),
            onRecordPayment: (purchase) => _openPaymentSheet(context, purchase),
            onReturnPurchase: (purchase) =>
                _openPurchaseReturn(context, purchase),
            onPaySupplierDue: (supplier) =>
                _openSupplierDuePayment(context, loaded, supplier),
            onAdjustSupplierBalance: (supplier) =>
                _openSupplierBalanceAdjust(context, loaded, supplier),
            onViewSupplierHistory: (supplier) =>
                _openSupplierHistory(context, loaded, supplier),
          ),
        };
      },
    );
  }

  Future<void> _openSupplierDuePayment(
    BuildContext context,
    PurchasesLoaded state,
    SupplierItem supplier,
  ) async {
    final invoiceDue = state.supplierInvoiceDue(supplier.id);
    final balance = supplier.balance;
    final payableBalance = balance > 0.009 ? balance : 0.0;
    final totalDue = invoiceDue + payableBalance;

    if (totalDue <= 0.009) {
      AppToast.show(context, 'Nothing to give for ${supplier.name}.');
      return;
    }

    final openPurchases = state.purchases
        .where(
          (purchase) =>
              purchase.supplierId == supplier.id && purchase.dueAmount > 0.009,
        )
        .toList();

    final amount = await showSupplierPaymentSheet(
      context: context,
      supplierName: supplier.name,
      dueAmount: totalDue,
      openInvoiceCount: openPurchases.length,
      openingBalanceDue: payableBalance > 0.009 ? payableBalance : null,
    );
    if (amount == null || !context.mounted) return;

    context.read<PurchasesBloc>().add(
      SupplierPaymentRecorded(supplierId: supplier.id, amount: amount),
    );
  }

  Future<void> _openSupplierBalanceAdjust(
    BuildContext context,
    PurchasesLoaded state,
    SupplierItem supplier,
  ) async {
    final result = await showSupplierBalanceSheet(
      context: context,
      supplierName: supplier.name,
      balance: supplier.balance,
      invoiceDue: state.supplierInvoiceDue(supplier.id),
    );
    if (result == null || !context.mounted) return;

    context.read<PurchasesBloc>().add(
      SupplierBalanceAdjusted(
        supplierId: supplier.id,
        amountChange: result.amountChange,
        note: result.note,
      ),
    );
  }

  Future<void> _openSupplierHistory(
    BuildContext context,
    PurchasesLoaded state,
    SupplierItem supplier,
  ) async {
    await showSupplierHistorySheet(
      context: context,
      supplier: supplier,
      purchases: state.purchasesForSupplier(supplier.id),
      onPayDue: () => _openSupplierDuePayment(context, state, supplier),
      onPurchaseTap: (purchase) => _showPurchaseDetails(context, purchase),
    );
  }
}

class _PurchasesLoadedView extends StatelessWidget {
  const _PurchasesLoadedView({
    required this.state,
    required this.onNewPurchase,
    required this.onNewSupplier,
    required this.onEditSupplier,
    required this.onRecordPayment,
    required this.onPaySupplierDue,
    required this.onAdjustSupplierBalance,
    required this.onReturnPurchase,
    required this.onViewSupplierHistory,
  });

  final PurchasesLoaded state;
  final VoidCallback onNewPurchase;
  final VoidCallback onNewSupplier;
  final ValueChanged<SupplierItem> onEditSupplier;
  final ValueChanged<PurchaseRecord> onRecordPayment;
  final ValueChanged<SupplierItem> onPaySupplierDue;
  final ValueChanged<SupplierItem> onAdjustSupplierBalance;
  final ValueChanged<PurchaseRecord> onReturnPurchase;
  final ValueChanged<SupplierItem> onViewSupplierHistory;

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
                  hintText: state.tab == PurchasesTab.suppliers
                      ? 'Search supplier name, phone, email or address…'
                      : 'Search invoice, supplier or product…',
                  onChanged: (value) => context.read<PurchasesBloc>().add(
                    PurchasesSearchChanged(value),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Add supplier',
                variant: AppButtonVariant.secondary,
                icon: Symbols.local_shipping,
                onPressed: onNewSupplier,
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'New purchase',
                icon: Symbols.add,
                onPressed: onNewPurchase,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: 'Purchases',
                value: CurrencyFormatter.format(state.totalPurchases),
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
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Suppliers',
                value: '${state.suppliers.length}',
                icon: Symbols.local_shipping,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<PurchasesTab>(
            segments: const [
              ButtonSegment(
                value: PurchasesTab.purchases,
                label: Text('Purchases'),
                icon: Icon(Symbols.assignment, size: 18),
              ),
              ButtonSegment(
                value: PurchasesTab.due,
                label: Text('To give'),
                icon: Icon(Symbols.payments, size: 18),
              ),
              ButtonSegment(
                value: PurchasesTab.suppliers,
                label: Text('Suppliers'),
                icon: Icon(Symbols.local_shipping, size: 18),
              ),
            ],
            selected: {state.tab},
            onSelectionChanged: (value) {
              context.read<PurchasesBloc>().add(
                PurchasesTabChanged(value.first),
              );
            },
          ),
          if (state.tab == PurchasesTab.suppliers) ...[
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final filter in SupplierFilter.values)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: FilterChip(
                        label: Text(switch (filter) {
                          SupplierFilter.all => 'All',
                          SupplierFilter.active => 'Active',
                          SupplierFilter.inactive => 'Inactive',
                          SupplierFilter.hasDue => 'To give',
                          SupplierFilter.cleared => 'Settled',
                        }),
                        selected: state.supplierFilter == filter,
                        onSelected: (_) => context.read<PurchasesBloc>().add(
                          PurchasesSupplierFilterChanged(filter),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: switch (state.tab) {
              PurchasesTab.suppliers => _SuppliersList(
                suppliers: state.visibleSuppliers,
                purchases: state.purchases,
                supplierDue: state.supplierDue,
                onEdit: onEditSupplier,
                onAdd: onNewSupplier,
                onPayDue: onPaySupplierDue,
                onAdjustBalance: onAdjustSupplierBalance,
                onViewHistory: onViewSupplierHistory,
              ),
              PurchasesTab.purchases || PurchasesTab.due => _PurchasesList(
                purchases: state.visiblePurchases,
                onRecordPayment: onRecordPayment,
                onReturnPurchase: onReturnPurchase,
              ),
            },
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

class _PurchasesList extends StatelessWidget {
  const _PurchasesList({
    required this.purchases,
    required this.onRecordPayment,
    required this.onReturnPurchase,
  });

  final List<PurchaseRecord> purchases;
  final ValueChanged<PurchaseRecord> onRecordPayment;
  final ValueChanged<PurchaseRecord> onReturnPurchase;

  @override
  Widget build(BuildContext context) {
    if (purchases.isEmpty) {
      return const EmptyState(
        title: 'No purchases yet',
        message: 'Record supplier purchases to update stock and track give/take.',
        icon: Symbols.assignment,
      );
    }

    final formatter = DateFormat('dd MMM yyyy');

    return ListView.separated(
      itemCount: purchases.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final purchase = purchases[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () => _showPurchaseDetails(context, purchase),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchase.invoiceNo,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          purchase.supplierName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${formatter.format(purchase.purchaseDate)} · ${purchase.totalUnits} units',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        Text(
                          '${purchase.lines.length} product${purchase.lines.length == 1 ? '' : 's'} · Tap for full details',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.accent,
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
                        CurrencyFormatter.format(purchase.total),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      if (purchase.dueAmount > 0)
                        Text(
                          KhataBalanceRules.payableLabel(purchase.dueAmount),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: KhataBalanceRules.colorForPayable(
                                  purchase.dueAmount,
                                ),
                              ),
                        )
                      else
                        Text(
                          'Paid',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppColors.success),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ...purchase.lines
                  .take(3)
                  .map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Row(
                        children: [
                          const Icon(Symbols.inventory_2, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              line.productName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            '${line.productSku} · ${line.displayQuantity} '
                            '${line.displayUnit} × '
                            '${CurrencyFormatter.format(line.displayUnitCost)}',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              if (purchase.lines.length > 3)
                Text(
                  '+${purchase.lines.length - 3} more product${purchase.lines.length - 3 == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (purchase.dueAmount > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton(
                    label: 'Give',
                    variant: AppButtonVariant.secondary,
                    icon: Symbols.payments,
                    onPressed: () => onRecordPayment(purchase),
                  ),
                ),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => onReturnPurchase(purchase),
                  icon: const Icon(Symbols.undo, size: 16),
                  label: const Text('Return to supplier'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showPurchaseDetails(
  BuildContext context,
  PurchaseRecord purchase,
) {
  final date = DateFormat('dd MMM yyyy');
  final dateTime = DateFormat('dd MMM yyyy · hh:mm a');

  return showDialog<void>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return Dialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680, maxHeight: 720),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            purchase.invoiceNo,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            purchase.supplierName,
                            style: theme.textTheme.titleMedium,
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
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _PurchaseMeta(
                      icon: Symbols.calendar_today,
                      label: 'Purchased ${date.format(purchase.purchaseDate)}',
                    ),
                    _PurchaseMeta(
                      icon: Symbols.schedule,
                      label: 'Recorded ${dateTime.format(purchase.createdAt)}',
                    ),
                    _PurchaseMeta(
                      icon: Symbols.inventory_2,
                      label:
                          '${purchase.lines.length} products · ${purchase.totalUnits} units',
                    ),
                  ],
                ),
                if (purchase.notes?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Notes: ${purchase.notes}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Purchased items',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    itemCount: purchase.lines.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final line = purchase.lines[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(
                          line.productName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          [
                            'SKU ${line.productSku}',
                            if (line.unitsPerPackage > 1)
                              '${line.displayQuantity} ${line.displayUnit} = '
                                  '${line.quantity} items · '
                                  '${CurrencyFormatter.format(line.displayUnitCost)} / ${line.displayUnit}'
                            else
                              '${line.displayQuantity} ${line.displayUnit} × '
                                  '${CurrencyFormatter.format(line.displayUnitCost)}',
                            if (line.batchCode != null) 'Lot ${line.batchCode}',
                            if (line.manufactureDate != null)
                              'Mfg ${DateFormat('dd MMM yyyy').format(line.manufactureDate!)}',
                            if (line.expiryDate != null)
                              'Exp ${DateFormat('dd MMM yyyy').format(line.expiryDate!)}',
                          ].join(' · '),
                        ),
                        trailing: Text(
                          CurrencyFormatter.format(line.lineTotal),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                _PurchaseTotalRow(label: 'Subtotal', amount: purchase.subtotal),
                if (purchase.taxAmount > 0)
                  _PurchaseTotalRow(label: 'Tax', amount: purchase.taxAmount),
                _PurchaseTotalRow(
                  label: 'Total',
                  amount: purchase.total,
                  emphasized: true,
                ),
                _PurchaseTotalRow(label: 'Paid', amount: purchase.paidAmount),
                _PurchaseTotalRow(
                  label: purchase.dueAmount > 0 ? 'Give' : 'Status',
                  amount: purchase.dueAmount,
                  emphasized: purchase.dueAmount > 0,
                  settled: purchase.dueAmount <= 0,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _PurchaseMeta extends StatelessWidget {
  const _PurchaseMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _PurchaseTotalRow extends StatelessWidget {
  const _PurchaseTotalRow({
    required this.label,
    required this.amount,
    this.emphasized = false,
    this.settled = false,
  });

  final String label;
  final double amount;
  final bool emphasized;
  final bool settled;

  @override
  Widget build(BuildContext context) {
    final color = settled
        ? KhataBalanceRules.settledColor
        : emphasized
        ? KhataBalanceRules.giveColor
        : null;
    final style = Theme.of(context).textTheme.titleSmall?.copyWith(
      color: color,
      fontWeight: emphasized || settled ? FontWeight.w800 : null,
    );
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(
            settled ? 'Paid in full' : CurrencyFormatter.format(amount),
            style: style,
          ),
        ],
      ),
    );
  }
}

class _SuppliersList extends StatelessWidget {
  const _SuppliersList({
    required this.suppliers,
    required this.purchases,
    required this.supplierDue,
    required this.onEdit,
    required this.onAdd,
    required this.onPayDue,
    required this.onAdjustBalance,
    required this.onViewHistory,
  });

  final List<SupplierItem> suppliers;
  final List<PurchaseRecord> purchases;
  final double Function(int supplierId) supplierDue;
  final ValueChanged<SupplierItem> onEdit;
  final VoidCallback onAdd;
  final ValueChanged<SupplierItem> onPayDue;
  final ValueChanged<SupplierItem> onAdjustBalance;
  final ValueChanged<SupplierItem> onViewHistory;

  @override
  Widget build(BuildContext context) {
    if (suppliers.isEmpty) {
      return EmptyState(
        title: 'No suppliers found',
        message: 'Add wholesalers and distributors you purchase stock from.',
        icon: Symbols.local_shipping,
        action: AppButton(
          label: 'Add supplier',
          icon: Symbols.add,
          onPressed: onAdd,
        ),
      );
    }

    final formatter = DateFormat('dd MMM yyyy');
    return ListView.separated(
      itemCount: suppliers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final supplier = suppliers[index];
        final supplierPurchases = purchases
            .where((purchase) => purchase.supplierId == supplier.id)
            .toList();
        final total = supplierPurchases.fold<double>(
          0,
          (sum, purchase) => sum + purchase.total,
        );
        final due = supplierPurchases.fold<double>(
          0,
          (sum, purchase) => sum + purchase.dueAmount,
        );
        final netDue = supplierDue(supplier.id);
        final openingBalance = KhataBalanceRules.money(supplier.balance);
        final lastPurchase = supplierPurchases.isEmpty
            ? null
            : supplierPurchases
                  .map((purchase) => purchase.purchaseDate)
                  .reduce((a, b) => a.isAfter(b) ? a : b);

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () => onViewHistory(supplier),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                child: Icon(Symbols.local_shipping, color: AppColors.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            supplier.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Chip(
                          label: Text(
                            supplier.isActive ? 'Active' : 'Inactive',
                          ),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: supplier.isActive
                              ? AppColors.success.withValues(alpha: 0.12)
                              : Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                        ),
                      ],
                    ),
                    if (supplier.phone.trim().isNotEmpty)
                      _SupplierDetail(
                        icon: Symbols.phone,
                        value: supplier.phone,
                      ),
                    if (supplier.email?.trim().isNotEmpty == true)
                      _SupplierDetail(
                        icon: Symbols.mail,
                        value: supplier.email!,
                      ),
                    if (supplier.address?.trim().isNotEmpty == true)
                      _SupplierDetail(
                        icon: Symbols.location_on,
                        value: supplier.address!,
                      ),
                    if (supplier.notes?.trim().isNotEmpty == true)
                      _SupplierDetail(
                        icon: Symbols.notes,
                        value: supplier.notes!,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${supplierPurchases.length} purchase${supplierPurchases.length == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      CurrencyFormatter.format(total),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      SupplierBalanceRules.netDueLabel(netDue),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: KhataBalanceRules.colorForSupplier(netDue),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (SupplierBalanceRules.hasBalance(openingBalance) &&
                        due > 0.009)
                      Text(
                        'Opening ${SupplierBalanceRules.detailLabel(openingBalance)}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SupplierBalanceRules.colorFor(openingBalance),
                        ),
                      ),
                    if (lastPurchase != null)
                      Text(
                        'Last purchase ${formatter.format(lastPurchase)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    Text(
                      'Tap card for full history',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      alignment: WrapAlignment.end,
                      children: [
                        AppButton(
                          label: 'History',
                          icon: Symbols.history,
                          variant: AppButtonVariant.secondary,
                          onPressed: () => onViewHistory(supplier),
                        ),
                        if (netDue > 0.009)
                          AppButton(
                            label: 'Give',
                            icon: Symbols.payments,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => onPayDue(supplier),
                          ),
                        AppButton(
                          label: 'Give / Take',
                          icon: Symbols.account_balance_wallet,
                          variant: AppButtonVariant.secondary,
                          onPressed: () => onAdjustBalance(supplier),
                        ),
                        AppButton(
                          label: 'Edit',
                          icon: Symbols.edit,
                          variant: AppButtonVariant.ghost,
                          onPressed: () => onEdit(supplier),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SupplierDetail extends StatelessWidget {
  const _SupplierDetail({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
