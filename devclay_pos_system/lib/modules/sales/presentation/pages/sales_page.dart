import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../services/hardware/receipt_print_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/sale_receipt_dialog.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../../settings/utils/sale_receipt_branding.dart';
import '../../domain/entities/sale_entities.dart';
import '../bloc/sales_bloc.dart';
import '../widgets/sale_return_sheet.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalesBloc>()..add(const SalesStarted()),
      child: const _SalesView(),
    );
  }
}

class _SalesView extends StatelessWidget {
  const _SalesView();

  Future<void> _showReceipt(BuildContext context, SaleRecord sale) async {
    final settingsRepo = sl<SettingsRepository>();
    final settings = await settingsRepo.getSettings();
    final branding = settingsRepo.receiptBranding(settings);
    if (!context.mounted) return;
    final operatorName =
        sale.cashierName ??
        context.read<AuthBloc>().state.sessionOrNull?.user.displayName;

    final receipt = SaleReceiptData.fromRecord(
      sale,
    ).withBranding(branding, operatorName: operatorName);

    await showSaleReceiptDialog(
      context,
      receipt,
      onPrint: () async {
        try {
          await ReceiptPrintService.printSaleReceipt(
            receipt: receipt,
            branding: branding,
            printerName: settings.printerName,
            paperWidthMm: settings.paperWidthMm,
          );
          if (context.mounted) {
            AppToast.show(context, 'Receipt sent to printer');
          }
        } catch (error) {
          if (context.mounted) {
            AppToast.show(context, 'Print failed: $error');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesBloc, SalesState>(
      builder: (context, state) {
        return switch (state) {
          SalesInitial() ||
          SalesLoading() => const Center(child: CircularProgressIndicator()),
          SalesError(:final message) => EmptyState(
            title: 'Sales unavailable',
            message: message,
            icon: Symbols.receipt_long,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<SalesBloc>().add(const SalesStarted()),
            ),
          ),
          SalesLoaded() => _SalesLoadedView(
            state: state,
            onReprint: (sale) => _showReceipt(context, sale),
            onChanged: () =>
                context.read<SalesBloc>().add(const SalesRefreshRequested()),
          ),
        };
      },
    );
  }
}

class _SalesLoadedView extends StatelessWidget {
  const _SalesLoadedView({
    required this.state,
    required this.onReprint,
    required this.onChanged,
  });

  final SalesLoaded state;
  final ValueChanged<SaleRecord> onReprint;
  final VoidCallback onChanged;

  String get _periodLabel => switch (state.period) {
    SalesPeriod.all => 'All time',
    SalesPeriod.today => 'Today',
    SalesPeriod.week => 'This week',
    SalesPeriod.month => 'This month',
  };

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
                  hintText: _searchHint(state.viewTab),
                  onChanged: (value) =>
                      context.read<SalesBloc>().add(SalesSearchChanged(value)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.secondary,
                icon: Symbols.refresh,
                onPressed: () => context.read<SalesBloc>().add(
                  const SalesRefreshRequested(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: '$_periodLabel sales',
                value: CurrencyFormatter.format(state.periodTotal),
                icon: Symbols.payments,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Receipts',
                value: '${state.periodReceiptCount}',
                icon: Symbols.receipt_long,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Units sold',
                value: '${state.periodUnitsSold}',
                icon: Symbols.inventory_2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: SalesPeriod.values.map((period) {
              final selected = state.period == period;
              return FilterChip(
                label: Text(_periodChipLabel(period)),
                selected: selected,
                onSelected: (_) =>
                    context.read<SalesBloc>().add(SalesPeriodChanged(period)),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SegmentedButton<SalesViewTab>(
              segments: const [
                ButtonSegment(
                  value: SalesViewTab.receipts,
                  label: Text('Receipts'),
                  icon: Icon(Symbols.receipt_long, size: 18),
                ),
                ButtonSegment(
                  value: SalesViewTab.returns,
                  label: Text('Returns / refunds'),
                  icon: Icon(Symbols.assignment_return, size: 18),
                ),
                ButtonSegment(
                  value: SalesViewTab.products,
                  label: Text('By product'),
                  icon: Icon(Symbols.inventory_2, size: 18),
                ),
                ButtonSegment(
                  value: SalesViewTab.payments,
                  label: Text('By payment'),
                  icon: Icon(Symbols.payments, size: 18),
                ),
                ButtonSegment(
                  value: SalesViewTab.customers,
                  label: Text('By customer'),
                  icon: Icon(Symbols.group, size: 18),
                ),
              ],
              selected: {state.viewTab},
              onSelectionChanged: (value) {
                context.read<SalesBloc>().add(SalesViewTabChanged(value.first));
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: switch (state.viewTab) {
              SalesViewTab.receipts => _ReceiptsList(
                sales: state.visibleSales,
                onReprint: onReprint,
                periodLabel: _periodLabel,
                onChanged: onChanged,
              ),
              SalesViewTab.returns => _ReturnsList(
                records: state.visibleReturns,
                periodLabel: _periodLabel,
              ),
              SalesViewTab.products => _ProductBreakdownList(
                products: state.productBreakdown,
                periodLabel: _periodLabel,
              ),
              SalesViewTab.payments => _PaymentBreakdownList(
                payments: state.paymentBreakdown,
                periodLabel: _periodLabel,
              ),
              SalesViewTab.customers => _CustomerBreakdownList(
                customers: state.customerBreakdown,
                periodLabel: _periodLabel,
              ),
            },
          ),
        ],
      ),
    );
  }

  String _searchHint(SalesViewTab tab) {
    return switch (tab) {
      SalesViewTab.receipts => 'Search invoice, customer, payment, product…',
      SalesViewTab.returns => 'Search return, invoice, customer, reason…',
      SalesViewTab.products => 'Search product name or SKU…',
      SalesViewTab.payments => 'Search payment method…',
      SalesViewTab.customers => 'Search customer name…',
    };
  }

  String _periodChipLabel(SalesPeriod period) {
    return switch (period) {
      SalesPeriod.all => 'All time',
      SalesPeriod.today => 'Today',
      SalesPeriod.week => 'This week',
      SalesPeriod.month => 'This month',
    };
  }
}

class _ReturnsList extends StatelessWidget {
  const _ReturnsList({required this.records, required this.periodLabel});

  final List<SaleReturnRecord> records;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return EmptyState(
        title: 'No returns in $periodLabel',
        message:
            'Customer item returns, refunds, and voided bills will appear here.',
        icon: Symbols.assignment_return,
      );
    }
    final formatter = DateFormat('dd MMM yyyy · HH:mm');
    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = records[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.warning.withValues(alpha: 0.12),
                child: Icon(
                  item.isVoid ? Symbols.cancel : Symbols.assignment_return,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.returnNo} · ${item.invoiceNo}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${item.customerName} · ${item.itemCount} item(s) · ${formatter.format(item.returnedAt)}',
                    ),
                    Text(
                      '${item.reason} · Approved by ${item.approvedByName ?? 'Manager'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(item.refundAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(item.isVoid ? 'VOIDED' : 'REFUNDED'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReceiptsList extends StatelessWidget {
  const _ReceiptsList({
    required this.sales,
    required this.onReprint,
    required this.periodLabel,
    required this.onChanged,
  });

  final List<SaleRecord> sales;
  final ValueChanged<SaleRecord> onReprint;
  final String periodLabel;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) {
      return EmptyState(
        title: 'No sales in $periodLabel',
        message: 'Try another period or complete a sale in POS.',
        icon: Symbols.receipt_long,
      );
    }

    final formatter = DateFormat('dd MMM · HH:mm');

    return ListView.separated(
      itemCount: sales.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final sale = sales[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.invoiceNo,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      sale.customerName,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${formatter.format(sale.soldAt)} · ${sale.itemCount} items · ${sale.paymentMethod}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(sale.total),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton(
                    label: 'Reprint',
                    variant: AppButtonVariant.secondary,
                    icon: Symbols.print,
                    onPressed: () => onReprint(sale),
                  ),
                  if (sale.canReturn) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final changed = await showSaleReturnSheet(
                              context,
                              sale: sale,
                            );
                            if (changed) onChanged();
                          },
                          icon: const Icon(Symbols.assignment_return, size: 16),
                          label: const Text('Return'),
                        ),
                        if (sale.status == 'completed')
                          TextButton.icon(
                            onPressed: () async {
                              final changed = await showSaleReturnSheet(
                                context,
                                sale: sale,
                                voidSale: true,
                              );
                              if (changed) onChanged();
                            },
                            icon: const Icon(Symbols.cancel, size: 16),
                            label: const Text('Void'),
                          ),
                      ],
                    ),
                  ] else
                    Text(
                      sale.status.replaceAll('_', ' ').toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w700,
                      ),
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

class _ProductBreakdownList extends StatelessWidget {
  const _ProductBreakdownList({
    required this.products,
    required this.periodLabel,
  });

  final List<ProductSalesSummary> products;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return EmptyState(
        title: 'No product sales',
        message: 'Product breakdown for $periodLabel will appear here.',
        icon: Symbols.inventory_2,
      );
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final product = products[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${product.productSku} · ${product.unitsSold} units · ${product.receiptCount} receipts',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(product.revenue),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PaymentBreakdownList extends StatelessWidget {
  const _PaymentBreakdownList({
    required this.payments,
    required this.periodLabel,
  });

  final List<PaymentSalesSummary> payments;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return EmptyState(
        title: 'No payment data',
        message: 'Payment breakdown for $periodLabel will appear here.',
        icon: Symbols.payments,
      );
    }

    final total = payments.fold(0.0, (sum, item) => sum + item.total);

    return ListView.separated(
      itemCount: payments.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final payment = payments[index];
        final share = total <= 0 ? 0.0 : (payment.total / total) * 100;
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      payment.paymentMethod,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(payment.total),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${payment.receiptCount} receipts · ${share.toStringAsFixed(1)}% of period',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              LinearProgressIndicator(
                value: total <= 0 ? 0 : payment.total / total,
                minHeight: 6,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerBreakdownList extends StatelessWidget {
  const _CustomerBreakdownList({
    required this.customers,
    required this.periodLabel,
  });

  final List<CustomerSalesSummary> customers;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return EmptyState(
        title: 'No customer sales',
        message: 'Customer breakdown for $periodLabel will appear here.',
        icon: Symbols.group,
      );
    }

    return ListView.separated(
      itemCount: customers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                child: Text(
                  customer.customerName.isNotEmpty
                      ? customer.customerName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.accent,
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
                      customer.customerName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      '${customer.receiptCount} receipts · ${customer.unitsSold} units',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(customer.total),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
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
