import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/empty_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/dashboard_data.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/business_snapshot_card.dart';
import '../widgets/dashboard_skeleton.dart';
import '../widgets/low_stock_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_sales_card.dart';
import '../widgets/sales_chart_card.dart';
import '../widgets/top_products_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(const DashboardStarted()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return switch (state) {
          DashboardInitial() || DashboardLoading() => const DashboardSkeleton(),
          DashboardError(:final message) => EmptyState(
              title: 'Could not load dashboard',
              message: message,
              icon: Symbols.warning,
              action: FilledButton(
                onPressed: () => context
                    .read<DashboardBloc>()
                    .add(const DashboardRefreshed()),
                child: const Text('Retry'),
              ),
            ),
          DashboardRefreshing() ||
          DashboardLoaded() =>
            _DashboardContent(
              isRefreshing: state is DashboardRefreshing,
            ),
        };
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.isRefreshing});

  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardBloc>().state;
    final data = switch (state) {
      DashboardLoaded(:final data) => data,
      DashboardRefreshing(:final data) => data,
      _ => null,
    };
    if (data == null) return const DashboardSkeleton();

    final storeName = context.select<AuthBloc, String>(
      (bloc) =>
          bloc.state.sessionOrNull?.store?.name ??
          AppConstants.storeNamePlaceholder,
    );

    final compact = AppBreakpoints.isCompact(context);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(const DashboardRefreshed());
        await context.read<DashboardBloc>().stream.firstWhere(
              (s) => s is DashboardLoaded || s is DashboardError,
            );
      },
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greetingForNow(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          storeName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (data.notifications.isNotEmpty)
                    _AlertsChip(count: data.notifications.length),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _KpiStrip(data: data, compact: compact),
              const SizedBox(height: AppSpacing.sm),
              _AttentionChips(data: data),
              const SizedBox(height: AppSpacing.sm),
              SalesChartCard(
                series: data.salesSeries,
                storeName: storeName,
                hourlySales: data.hourlySalesToday,
              ),
              const SizedBox(height: AppSpacing.sm),
              _MidGrid(data: data, compact: compact),
              const SizedBox(height: AppSpacing.sm),
              BusinessSnapshotCard(data: data),
              const SizedBox(height: AppSpacing.sm),
              if (compact) ...[
                TopProductsCard(products: data.topProducts),
                const SizedBox(height: AppSpacing.sm),
                RecentSalesCard(sales: data.recentSales),
                const SizedBox(height: AppSpacing.sm),
                LowStockCard(items: data.lowStockItems),
                const SizedBox(height: AppSpacing.sm),
                ExpiryWatchCard(items: data.expiryWatchItems),
                const SizedBox(height: AppSpacing.sm),
                const QuickActionsCard(),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          RecentSalesCard(sales: data.recentSales),
                          const SizedBox(height: AppSpacing.sm),
                          ExpiryWatchCard(items: data.expiryWatchItems),
                          const SizedBox(height: AppSpacing.sm),
                          const QuickActionsCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          TopProductsCard(products: data.topProducts),
                          const SizedBox(height: AppSpacing.sm),
                          LowStockCard(items: data.lowStockItems),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
          if (isRefreshing)
            const Positioned(
              top: 8,
              right: 16,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip({required this.data, required this.compact});

  final DashboardData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tiles = <_CompactKpi>[
      _CompactKpi(
        label: 'Today sales',
        value: CurrencyFormatter.format(data.todaySales),
        change: data.todaySalesChange,
        color: AppColors.accent,
      ),
      _CompactKpi(
        label: 'Today profit',
        value: CurrencyFormatter.format(data.todayProfit),
        change: data.todayProfitChange,
        color: AppColors.success,
      ),
      _CompactKpi(
        label: 'Avg ticket',
        value: CurrencyFormatter.format(data.avgTicket),
        color: AppColors.primary,
      ),
      _CompactKpi(
        label: 'Receipts',
        value: '${data.todayReceiptCount}',
        color: AppColors.primary,
      ),
      _CompactKpi(
        label: 'Month sales',
        value: CurrencyFormatter.compact(data.monthlySales),
        change: data.monthlySalesChange,
        color: AppColors.accent,
      ),
      _CompactKpi(
        label: 'Cash on hand',
        value: CurrencyFormatter.compact(data.cashOnHand),
        color: AppColors.success,
      ),
      if (data.isRestaurant) ...[
        _CompactKpi(
          label: 'Open tables',
          value: '${data.openTables}',
          color: AppColors.warning,
        ),
        _CompactKpi(
          label: 'Kitchen',
          value: '${data.kitchenOpenTickets}',
          color: AppColors.danger,
        ),
      ],
    ];

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final tile in tiles)
          SizedBox(
            width: compact
                ? (MediaQuery.sizeOf(context).width - AppSpacing.md * 2 - 4) / 2
                : 148,
            child: tile,
          ),
      ],
    );
  }
}

class _CompactKpi extends StatelessWidget {
  const _CompactKpi({
    required this.label,
    required this.value,
    required this.color,
    this.change,
  });

  final String label;
  final String value;
  final Color color;
  final double? change;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.smAll,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (change != null)
                Text(
                  '${change! >= 0 ? '+' : ''}${change!.toStringAsFixed(0)}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: change! >= 0 ? AppColors.success : AppColors.danger,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttentionChips extends StatelessWidget {
  const _AttentionChips({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      if (data.heldSalesCount > 0)
        _chip(context, 'Held ${data.heldSalesCount}', AppColors.warning),
      if (data.lowStockItems.isNotEmpty)
        _chip(context, 'Low stock ${data.lowStockItems.length}', AppColors.danger),
      if (data.expiredProductCount > 0)
        _chip(context, 'Expired ${data.expiredProductCount}', AppColors.danger),
      if (data.expiringSoonCount > 0)
        _chip(context, 'Expiry soon ${data.expiringSoonCount}', AppColors.warning),
      if (data.backupNeedsAttention)
        _chip(context, 'Backup due', AppColors.danger),
      if (data.receivablesDue > 0)
        _chip(
          context,
          'Khata ${CurrencyFormatter.compact(data.receivablesDue)}',
          AppColors.accent,
        ),
      if (data.voidedToday > 0)
        _chip(
          context,
          'Voided ${CurrencyFormatter.compact(data.voidedToday)}',
          AppColors.danger,
        ),
      if (data.webOrdersPending > 0)
        _chip(context, 'Web orders ${data.webOrdersPending}', AppColors.accent),
    ];
    if (chips.isEmpty) {
      return Text(
        'All clear — no attention items',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Wrap(spacing: 6, runSpacing: 6, children: chips);
  }

  Widget _chip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.xsAll,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

class _MidGrid extends StatelessWidget {
  const _MidGrid({required this.data, required this.compact});

  final DashboardData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mix = data.paymentMix;
    final total = mix.total;
    Widget pct(String label, double amount, Color color) {
      final p = total <= 0 ? 0.0 : (amount / total) * 100;
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            Text(
              '${p.toStringAsFixed(0)}%',
              style: theme.textTheme.titleSmall?.copyWith(color: color),
            ),
          ],
        ),
      );
    }

    final paymentCard = Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment mix today', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              pct('Cash', mix.cash, AppColors.success),
              pct('Card', mix.card, AppColors.primary),
              pct('Wallet', mix.wallet, AppColors.accent),
              pct('Khata', mix.khata, AppColors.warning),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Returns ${CurrencyFormatter.format(data.returnsToday)} · '
            'Voids ${CurrencyFormatter.format(data.voidedToday)}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );

    final staffCard = Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: AppRadii.smAll,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Staff sales today', style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          if (data.staffSalesToday.isEmpty)
            Text('No receipts yet', style: theme.textTheme.bodySmall)
          else
            ...data.staffSalesToday.take(4).map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(s.name, style: theme.textTheme.bodySmall)),
                        Text(
                          '${s.receipts} · ${CurrencyFormatter.compact(s.amount)}',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );

    if (compact) {
      return Column(
        children: [
          paymentCard,
          const SizedBox(height: AppSpacing.sm),
          staffCard,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: paymentCard),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: staffCard),
      ],
    );
  }
}

class _AlertsChip extends StatelessWidget {
  const _AlertsChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: AppRadii.xsAll,
      ),
      child: Text(
        '$count alerts',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.warning,
            ),
      ),
    );
  }
}

String _greetingForNow() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}
