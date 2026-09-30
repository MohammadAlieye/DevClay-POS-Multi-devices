import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/stat_card.dart';
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
    final cardWidth = compact
        ? double.infinity
        : (MediaQuery.sizeOf(context).width - 280 - (AppSpacing.lg * 3)) / 4;

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
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                _greetingForNow(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Here is how $storeName is performing today.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  SizedBox(
                    width: compact ? double.infinity : cardWidth.clamp(220, 320),
                    child: StatCard(
                      title: "Today's sales",
                      value: CurrencyFormatter.format(data.todaySales),
                      icon: Symbols.payments,
                      changePercent: data.todaySalesChange,
                      accentColor: AppColors.accent,
                    ),
                  ),
                  SizedBox(
                    width: compact ? double.infinity : cardWidth.clamp(220, 320),
                    child: StatCard(
                      title: "Today's profit",
                      value: CurrencyFormatter.format(data.todayProfit),
                      icon: Symbols.trending_up,
                      changePercent: data.todayProfitChange,
                      accentColor: AppColors.success,
                    ),
                  ),
                  SizedBox(
                    width: compact ? double.infinity : cardWidth.clamp(220, 320),
                    child: StatCard(
                      title: 'Monthly sales',
                      value: CurrencyFormatter.compact(data.monthlySales),
                      icon: Symbols.calendar_month,
                      changePercent: data.monthlySalesChange,
                      accentColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(
                    width: compact ? double.infinity : cardWidth.clamp(220, 320),
                    child: StatCard(
                      title: 'Monthly profit',
                      value: CurrencyFormatter.compact(data.monthlyProfit),
                      icon: Symbols.account_balance_wallet,
                      changePercent: data.monthlyProfitChange,
                      accentColor: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              AttentionStripCard(data: data),
              const SizedBox(height: AppSpacing.lg),
              BusinessSnapshotCard(data: data),
              const SizedBox(height: AppSpacing.lg),
              SalesChartCard(series: data.salesSeries, storeName: storeName),
              const SizedBox(height: AppSpacing.lg),
              if (compact) ...[
                TopProductsCard(products: data.topProducts),
                const SizedBox(height: AppSpacing.md),
                RecentSalesCard(sales: data.recentSales),
                const SizedBox(height: AppSpacing.md),
                LowStockCard(items: data.lowStockItems),
                const SizedBox(height: AppSpacing.md),
                ExpiryWatchCard(items: data.expiryWatchItems),
                const SizedBox(height: AppSpacing.md),
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
                          const SizedBox(height: AppSpacing.md),
                          ExpiryWatchCard(items: data.expiryWatchItems),
                          const SizedBox(height: AppSpacing.md),
                          const QuickActionsCard(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          TopProductsCard(products: data.topProducts),
                          const SizedBox(height: AppSpacing.md),
                          LowStockCard(items: data.lowStockItems),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.xxl),
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

String _greetingForNow() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}
