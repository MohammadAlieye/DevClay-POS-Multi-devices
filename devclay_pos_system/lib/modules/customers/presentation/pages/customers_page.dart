import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/customer_entities.dart';
import '../bloc/customers_bloc.dart';
import '../widgets/customer_balance_sheet.dart';
import '../widgets/customer_editor_sheet.dart';
import '../../../../widgets/app_toast.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomersBloc>()..add(const CustomersStarted()),
      child: const _CustomersView(),
    );
  }
}

class _CustomersView extends StatelessWidget {
  const _CustomersView();

  Future<void> _openEditor(
    BuildContext context, {
    CustomerItem? existing,
  }) async {
    final draft = await showCustomerEditorSheet(
      context: context,
      existing: existing,
    );
    if (draft == null || !context.mounted) return;
    context.read<CustomersBloc>().add(
      CustomerSaved(draft: draft, id: existing?.id),
    );
  }

  Future<void> _openBalanceSheet(
    BuildContext context,
    CustomerItem customer,
  ) async {
    final result = await showCustomerBalanceSheet(
      context: context,
      customerName: customer.name,
      balance: customer.balance,
    );
    if (result == null || !context.mounted) return;

    switch (result.action) {
      case CustomerBalanceAction.receivePayment:
        context.read<CustomersBloc>().add(
          CustomerPaymentRecorded(
            customerId: customer.id,
            amount: result.amount,
            note: result.note,
          ),
        );
      case CustomerBalanceAction.addDue:
        context.read<CustomersBloc>().add(
          CustomerBalanceAdjusted(
            customerId: customer.id,
            amountChange: result.amount,
            note: result.note,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomersBloc, CustomersState>(
      listenWhen: (prev, curr) =>
          curr is CustomersLoaded && curr.message != null,
      listener: (context, state) {
        if (state is CustomersLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<CustomersBloc>().add(const CustomersMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          CustomersInitial() || CustomersLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CustomersError(:final message) => EmptyState(
            title: 'Customers unavailable',
            message: message,
            icon: Symbols.group,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<CustomersBloc>().add(const CustomersStarted()),
            ),
          ),
          CustomersLoaded() => _CustomersLoadedView(
            state: state,
            onAdd: () => _openEditor(context),
            onEdit: (customer) => _openEditor(context, existing: customer),
            onBalance: (customer) => _openBalanceSheet(context, customer),
            onViewSales: (customer) => context.read<CustomersBloc>().add(
              CustomerSalesRequested(
                customerId: customer.id,
                customerName: customer.name,
              ),
            ),
          ),
        };
      },
    );
  }
}

class _CustomersLoadedView extends StatelessWidget {
  const _CustomersLoadedView({
    required this.state,
    required this.onAdd,
    required this.onEdit,
    required this.onBalance,
    required this.onViewSales,
  });

  final CustomersLoaded state;
  final VoidCallback onAdd;
  final ValueChanged<CustomerItem> onEdit;
  final ValueChanged<CustomerItem> onBalance;
  final ValueChanged<CustomerItem> onViewSales;

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
                  hintText: 'Search customer name or phone…',
                  onChanged: (value) => context.read<CustomersBloc>().add(
                    CustomersSearchChanged(value),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Add customer',
                icon: Symbols.person_add,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: 'Customers',
                value: '${state.customers.length}',
                icon: Symbols.group,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'To take',
                value: CurrencyFormatter.format(state.totalToTake),
                subtitle: '${state.takeCount} customers',
                icon: Symbols.call_received,
                valueColor: KhataBalanceRules.takeColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'To give',
                value: CurrencyFormatter.format(state.totalToGive),
                subtitle: '${state.giveCount} customers',
                icon: Symbols.call_made,
                valueColor: KhataBalanceRules.giveColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<CustomersTab>(
            segments: const [
              ButtonSegment(
                value: CustomersTab.all,
                label: Text('All'),
                icon: Icon(Symbols.group, size: 18),
              ),
              ButtonSegment(
                value: CustomersTab.toTake,
                label: Text('To take'),
                icon: Icon(Symbols.call_received, size: 18),
              ),
              ButtonSegment(
                value: CustomersTab.toGive,
                label: Text('To give'),
                icon: Icon(Symbols.call_made, size: 18),
              ),
              ButtonSegment(
                value: CustomersTab.topBuyers,
                label: Text('Top buyers'),
                icon: Icon(Symbols.trending_up, size: 18),
              ),
            ],
            selected: {state.tab},
            onSelectionChanged: (value) {
              context.read<CustomersBloc>().add(
                CustomersTabChanged(value.first),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _CustomersList(
                    customers: state.visibleCustomers,
                    onEdit: onEdit,
                    onBalance: onBalance,
                    onViewSales: onViewSales,
                    selectedName: state.selectedCustomerName,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: _CustomerSalesPanel(
                    customerName: state.selectedCustomerName,
                    sales: state.selectedCustomerSales,
                    khataEntries: state.selectedKhataEntries,
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

class _CustomersList extends StatelessWidget {
  const _CustomersList({
    required this.customers,
    required this.onEdit,
    required this.onBalance,
    required this.onViewSales,
    required this.selectedName,
  });

  final List<CustomerItem> customers;
  final ValueChanged<CustomerItem> onEdit;
  final ValueChanged<CustomerItem> onBalance;
  final ValueChanged<CustomerItem> onViewSales;
  final String? selectedName;

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return const EmptyState(
        title: 'No customers yet',
        message: 'Add customers to track purchases and outstanding balances.',
        icon: Symbols.group,
      );
    }

    return ListView.separated(
      itemCount: customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final customer = customers[index];
        final selected = customer.name == selectedName;

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
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
                    child: Text(
                      customer.name.isNotEmpty
                          ? customer.name[0].toUpperCase()
                          : '?',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: selected
                            ? AppColors.accent
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          customer.phone,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${customer.receiptCount} receipts · ${CurrencyFormatter.format(customer.totalPurchases)} purchased',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(customer.balance.abs()),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: KhataBalanceRules.colorFor(customer.balance),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        KhataBalanceRules.statusLabelFor(customer.balance),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: KhataBalanceRules.colorFor(customer.balance),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (customer.isOverLimit) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Over credit limit (${CurrencyFormatter.format(customer.creditLimit)})',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.warning),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  AppButton(
                    label: 'Sales',
                    variant: AppButtonVariant.secondary,
                    icon: Symbols.receipt_long,
                    onPressed: () => onViewSales(customer),
                  ),
                  AppButton(
                    label: 'Balance',
                    variant: AppButtonVariant.secondary,
                    icon: Symbols.payments,
                    onPressed: () => onBalance(customer),
                  ),
                  AppButton(
                    label: 'Edit',
                    variant: AppButtonVariant.ghost,
                    icon: Symbols.edit,
                    onPressed: () => onEdit(customer),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerSalesPanel extends StatelessWidget {
  const _CustomerSalesPanel({
    required this.customerName,
    required this.sales,
    required this.khataEntries,
  });

  final String? customerName;
  final List<CustomerSaleSummary> sales;
  final List<CustomerKhataEntry> khataEntries;

  @override
  Widget build(BuildContext context) {
    if (customerName == null) {
      return AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Text(
            'Select a customer and tap Sales to view khata and purchases.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final formatter = DateFormat('dd MMM yyyy · HH:mm');
    final total = sales.fold(0.0, (sum, sale) => sum + sale.total);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(customerName!, style: Theme.of(context).textTheme.titleMedium),
          Text(
            '${khataEntries.length} khata entries · ${sales.length} receipts · '
            '${CurrencyFormatter.format(total)} purchases',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: khataEntries.isEmpty && sales.isEmpty
                ? Center(
                    child: Text(
                      'No khata or linked POS sales yet.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView(
                    children: [
                      if (khataEntries.isNotEmpty) ...[
                        Text(
                          'Khata ledger',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ...khataEntries.map(
                          (entry) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              entry.isDebit
                                  ? Symbols.arrow_upward
                                  : Symbols.arrow_downward,
                              color: KhataBalanceRules.colorFor(
                                entry.balanceAfter,
                              ),
                            ),
                            title: Text(
                              '${entry.isDebit ? 'Udhar' : 'Jama'} · '
                              '${CurrencyFormatter.format(entry.amount)}',
                            ),
                            subtitle: Text(
                              [
                                formatter.format(entry.entryDate),
                                if (entry.reference != null) entry.reference!,
                                if (entry.note != null) entry.note!,
                              ].join(' · '),
                            ),
                            trailing: Text(
                              KhataBalanceRules.ledgerBalanceLabel(
                                entry.balanceAfter,
                              ),
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                color: KhataBalanceRules.colorFor(
                                  entry.balanceAfter,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                      if (sales.isNotEmpty) ...[
                        Text(
                          'Purchase history',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        ...sales.map(
                          (sale) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(sale.invoiceNo),
                            subtitle: Text(
                              '${formatter.format(sale.soldAt)} · ${sale.paymentMethod}',
                            ),
                            trailing: Text(
                              CurrencyFormatter.format(sale.total),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    ],
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
    this.subtitle,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = valueColor ?? theme.colorScheme.primary;
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 20, color: accent),
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
                      color: valueColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accent,
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
