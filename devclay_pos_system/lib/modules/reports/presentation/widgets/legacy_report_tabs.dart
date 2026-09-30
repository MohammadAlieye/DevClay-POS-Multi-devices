import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/trend_line_chart.dart';
import '../../domain/entities/report_entities.dart';

/// Legacy chart/tab views preserved from the original monolithic reports page.

TrendDateLabelBuilder? legacyTrendDateLabel(ReportsPeriod period) {
  if (period != ReportsPeriod.today) return null;
  return (date, index, total) => DateFormat('ha').format(date);
}

ReportsPeriod legacyPeriodFromFilters(ReportPeriodPreset preset) {
  return preset.toLegacy() ?? ReportsPeriod.month;
}

class LegacySalesTab extends StatelessWidget {
  const LegacySalesTab({
    super.key,
    required this.data,
    required this.period,
    required this.periodLabel,
  });

  final ReportsData data;
  final ReportsPeriod period;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TrendLineChart(
          title: 'Sales trend',
          subtitle: periodLabel,
          values: data.trend.map((point) => point.sales).toList(),
          dates: data.trend.map((point) => point.date).toList(),
          dateLabelBuilder: legacyTrendDateLabel(period),
        ),
        const SizedBox(height: AppSpacing.md),
        if (data.payments.isNotEmpty) ...[
          _PaymentPieChart(payments: data.payments, periodLabel: periodLabel),
          const SizedBox(height: AppSpacing.md),
        ],
        if (data.topProducts.isNotEmpty) ...[
          _ProductRevenueChart(products: data.topProducts.take(5).toList()),
          const SizedBox(height: AppSpacing.md),
        ],
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Payment methods', subtitle: periodLabel),
              const SizedBox(height: AppSpacing.sm),
              ...data.payments.map(
                (payment) => _ProgressRow(
                  label: payment.method,
                  value: payment.total,
                  total: data.summary.totalSales,
                  trailing: '${payment.count} receipts',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _TopProductsList(products: data.topProducts),
      ],
    );
  }
}

class LegacyProfitTab extends StatelessWidget {
  const LegacyProfitTab({
    super.key,
    required this.summary,
    required this.products,
    required this.trend,
    required this.period,
    required this.periodLabel,
    this.usedBatchCost = false,
  });

  final ReportSummary summary;
  final List<ReportProductRow> products;
  final List<ReportTrendPoint> trend;
  final ReportsPeriod period;
  final String periodLabel;
  final bool usedBatchCost;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TrendLineChart(
          title: 'Profit trend',
          subtitle: periodLabel,
          values: trend.map((point) => point.profit).toList(),
          dates: trend.map((point) => point.date).toList(),
          color: AppColors.success,
          dateLabelBuilder: legacyTrendDateLabel(period),
        ),
        const SizedBox(height: AppSpacing.md),
        _ProfitComparisonChart(summary: summary, periodLabel: periodLabel),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profit summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              _MetricRow(
                label: '$periodLabel sales',
                value: CurrencyFormatter.format(summary.totalSales),
              ),
              _MetricRow(
                label: 'Estimated gross profit',
                value: CurrencyFormatter.format(summary.estimatedProfit),
                valueColor: AppColors.success,
              ),
              _MetricRow(
                label: '$periodLabel expenses',
                value: CurrencyFormatter.format(summary.totalExpenses),
                valueColor: AppColors.warning,
              ),
              _MetricRow(
                label: 'Net estimate',
                value: CurrencyFormatter.format(summary.netEstimate),
                valueColor: summary.netEstimate >= 0
                    ? AppColors.success
                    : AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                usedBatchCost
                    ? 'Profit uses FEFO batch costs where recorded, with catalog cost as fallback.'
                    : 'Profit uses batch/FEFO costs when available, otherwise current product cost.',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _TopProductsList(products: products, showProfit: true),
      ],
    );
  }
}

class LegacyExpensesTab extends StatelessWidget {
  const LegacyExpensesTab({
    super.key,
    required this.summary,
    required this.trend,
    required this.expenseCategories,
    required this.period,
    required this.periodLabel,
  });

  final ReportSummary summary;
  final List<ReportTrendPoint> trend;
  final List<ReportExpenseCategoryRow> expenseCategories;
  final ReportsPeriod period;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    if (summary.totalExpenses <= 0 && expenseCategories.isEmpty) {
      return const EmptyState(
        title: 'No expenses yet',
        message:
            'Record salaries, rent, bills and other costs from Finance → Expenses.',
        icon: Symbols.payments,
      );
    }

    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: '$periodLabel expenses',
                value: CurrencyFormatter.format(summary.totalExpenses),
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricCard(
                label: 'Categories',
                value: '${expenseCategories.length}',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricCard(
                label: 'Net after expenses',
                value: CurrencyFormatter.format(summary.netEstimate),
                color: summary.netEstimate >= 0
                    ? AppColors.success
                    : AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TrendLineChart(
          title: 'Expense trend',
          subtitle: periodLabel,
          values: trend.map((point) => point.expenses).toList(),
          dates: trend.map((point) => point.date).toList(),
          color: AppColors.warning,
          dateLabelBuilder: legacyTrendDateLabel(period),
          emptyMessage: 'No expense entries in this period.',
        ),
        const SizedBox(height: AppSpacing.md),
        if (expenseCategories.isNotEmpty) ...[
          _ExpenseCategoryPieChart(
            categories: expenseCategories,
            periodLabel: periodLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          _ExpenseCategoryBarChart(
            categories: expenseCategories.take(8).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: 'Expense breakdown',
                  subtitle: 'By category · $periodLabel',
                ),
                const SizedBox(height: AppSpacing.sm),
                ...expenseCategories.map(
                  (row) => _ProgressRow(
                    label: row.category,
                    value: row.total,
                    total: summary.totalExpenses,
                    trailing:
                        '${row.count} entr${row.count == 1 ? 'y' : 'ies'}',
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How to use',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Record business costs in Finance → Expenses '
                '(Salary, Rent, Electricity, Internet, Fuel, Tax, and more). '
                'They appear here with charts for the selected period.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color ?? AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCategoryPieChart extends StatelessWidget {
  const _ExpenseCategoryPieChart({
    required this.categories,
    required this.periodLabel,
  });

  final List<ReportExpenseCategoryRow> categories;
  final String periodLabel;

  static final _colors = [
    AppColors.warning,
    AppColors.accent,
    AppColors.success,
    const Color(0xFF6366F1),
    const Color(0xFFEC4899),
    const Color(0xFF14B8A6),
    const Color(0xFFF59E0B),
    const Color(0xFF8B5CF6),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = categories.fold(0.0, (sum, row) => sum + row.total);
    final top = categories.take(6).toList();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Expenses by category', subtitle: periodLabel),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 34,
                      sections: [
                        for (var i = 0; i < top.length; i++)
                          PieChartSectionData(
                            value: top[i].total,
                            color: _colors[i % _colors.length],
                            radius: 58,
                            title: total <= 0
                                ? ''
                                : '${((top[i].total / total) * 100).round()}%',
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < top.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _colors[i % _colors.length],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  top[i].category,
                                  style: theme.textTheme.labelSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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

class _ExpenseCategoryBarChart extends StatelessWidget {
  const _ExpenseCategoryBarChart({required this.categories});

  final List<ReportExpenseCategoryRow> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataMax = categories
        .map((row) => row.total)
        .reduce((a, b) => a > b ? a : b);
    final maxY = ChartAxisHelper.niceMaxY(dataMax);
    final interval = ChartAxisHelper.intervalFor(maxY);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Top expense categories',
            subtitle: 'Amount spent by type',
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY <= 0 ? 1 : maxY,
                gridData: ChartAxisHelper.horizontalGrid(theme, interval),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: ChartAxisHelper.leftAxisTitles(
                    maxY: maxY <= 0 ? 1 : maxY,
                    style: theme.textTheme.labelSmall,
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= categories.length) {
                          return const SizedBox.shrink();
                        }
                        final label = categories[index].category;
                        final short = label.length > 9
                            ? '${label.substring(0, 9)}…'
                            : label;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(short, style: theme.textTheme.labelSmall),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < categories.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: categories[i].total,
                          color: AppColors.warning.withValues(
                            alpha: 1 - (i * 0.08),
                          ),
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                ],
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final row = categories[group.x];
                      return BarTooltipItem(
                        '${row.category}\n${CurrencyFormatter.format(rod.toY)}',
                        theme.textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LegacyInventoryTab extends StatelessWidget {
  const LegacyInventoryTab({
    super.key,
    required this.summary,
    required this.lowStock,
    required this.categories,
  });

  final ReportSummary summary;
  final List<ReportLowStockRow> lowStock;
  final List<ReportCategoryRow> categories;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock value',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      CurrencyFormatter.format(summary.stockValue),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Low stock items',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      '${summary.lowStockCount}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (categories.isNotEmpty) ...[
          _CategoryStockChart(categories: categories),
          const SizedBox(height: AppSpacing.md),
        ],
        if (lowStock.isEmpty)
          const EmptyState(
            title: 'No low stock alerts',
            message: 'Products above the threshold look healthy.',
            icon: Symbols.inventory_2,
          )
        else
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'Low stock',
                  subtitle:
                      'Uses each product alert (default $kLowStockReportThreshold)',
                ),
                const SizedBox(height: AppSpacing.sm),
                ...lowStock.map(
                  (item) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.name),
                    subtitle: Text('${item.sku} · ${item.stock} units'),
                    trailing: Text(
                      CurrencyFormatter.format(item.value),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class LegacyPurchasesTab extends StatelessWidget {
  const LegacyPurchasesTab({
    super.key,
    required this.summary,
    required this.trend,
    required this.period,
    required this.periodLabel,
  });

  final ReportSummary summary;
  final List<ReportTrendPoint> trend;
  final ReportsPeriod period;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TrendLineChart(
          title: 'Purchase trend',
          subtitle: periodLabel,
          values: trend.map((point) => point.purchases).toList(),
          dates: trend.map((point) => point.date).toList(),
          color: AppColors.warning,
          dateLabelBuilder: legacyTrendDateLabel(period),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Purchase summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              _MetricRow(
                label: '$periodLabel purchases',
                value: CurrencyFormatter.format(summary.totalPurchases),
              ),
              _MetricRow(
                label: 'Outstanding give (all time)',
                value: CurrencyFormatter.format(summary.totalPurchaseDue),
                valueColor: AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentPieChart extends StatelessWidget {
  const _PaymentPieChart({required this.payments, required this.periodLabel});

  final List<ReportPaymentRow> payments;
  final String periodLabel;

  static final _colors = [
    AppColors.accent,
    AppColors.success,
    AppColors.warning,
    const Color(0xFF6366F1),
    const Color(0xFFEC4899),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = payments.fold(0.0, (sum, row) => sum + row.total);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Payment mix', subtitle: periodLabel),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 34,
                      sections: [
                        for (var i = 0; i < payments.length; i++)
                          PieChartSectionData(
                            value: payments[i].total,
                            color: _colors[i % _colors.length],
                            radius: 58,
                            title: total <= 0
                                ? ''
                                : '${((payments[i].total / total) * 100).round()}%',
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < payments.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _colors[i % _colors.length],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  payments[i].method,
                                  style: theme.textTheme.labelSmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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

class _ProductRevenueChart extends StatelessWidget {
  const _ProductRevenueChart({required this.products});

  final List<ReportProductRow> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataMax = products
        .map((product) => product.revenue)
        .reduce((a, b) => a > b ? a : b);
    final maxY = ChartAxisHelper.niceMaxY(dataMax);
    final interval = ChartAxisHelper.intervalFor(maxY);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Top products',
            subtitle: 'Revenue by product',
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY <= 0 ? 1 : maxY,
                gridData: ChartAxisHelper.horizontalGrid(theme, interval),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: ChartAxisHelper.leftAxisTitles(
                    maxY: maxY <= 0 ? 1 : maxY,
                    style: theme.textTheme.labelSmall,
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= products.length) {
                          return const SizedBox.shrink();
                        }
                        final label = products[index].name;
                        final short = label.length > 8
                            ? '${label.substring(0, 8)}…'
                            : label;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(short, style: theme.textTheme.labelSmall),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < products.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: products[i].revenue,
                          color: AppColors.accent,
                          width: 18,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfitComparisonChart extends StatelessWidget {
  const _ProfitComparisonChart({
    required this.summary,
    required this.periodLabel,
  });

  final ReportSummary summary;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bars = [
      _BarSpec('Sales', summary.totalSales, AppColors.accent),
      _BarSpec('Profit', summary.estimatedProfit, AppColors.success),
      _BarSpec('Expenses', summary.totalExpenses, AppColors.warning),
    ];
    final maxY = ChartAxisHelper.niceMaxY(
      bars.map((bar) => bar.value).reduce((a, b) => a > b ? a : b),
    );
    final interval = ChartAxisHelper.intervalFor(maxY);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Sales vs profit vs expenses',
            subtitle: periodLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY <= 0 ? 1 : maxY,
                gridData: ChartAxisHelper.horizontalGrid(theme, interval),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: ChartAxisHelper.leftAxisTitles(
                    maxY: maxY <= 0 ? 1 : maxY,
                    style: theme.textTheme.labelSmall,
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= bars.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            bars[index].label,
                            style: theme.textTheme.labelSmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < bars.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: bars[i].value,
                          color: bars[i].color,
                          width: 28,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarSpec {
  const _BarSpec(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}

class _CategoryStockChart extends StatelessWidget {
  const _CategoryStockChart({required this.categories});

  final List<ReportCategoryRow> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataMax = categories
        .map((row) => row.stockValue)
        .reduce((a, b) => a > b ? a : b);
    final maxY = ChartAxisHelper.niceMaxY(dataMax);
    final interval = ChartAxisHelper.intervalFor(maxY);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Stock by category',
            subtitle: 'Inventory value at cost',
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxY <= 0 ? 1 : maxY,
                gridData: ChartAxisHelper.horizontalGrid(theme, interval),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: ChartAxisHelper.leftAxisTitles(
                    maxY: maxY <= 0 ? 1 : maxY,
                    style: theme.textTheme.labelSmall,
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= categories.length) {
                          return const SizedBox.shrink();
                        }
                        final label = categories[index].category;
                        final short = label.length > 10
                            ? '${label.substring(0, 10)}…'
                            : label;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(short, style: theme.textTheme.labelSmall),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < categories.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: categories[i].stockValue,
                          color: AppColors.accent.withValues(
                            alpha: 1 - (i * 0.08),
                          ),
                          width: 20,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                ],
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final row = categories[group.x];
                      return BarTooltipItem(
                        '${row.category}\n${CurrencyFormatter.format(rod.toY)}',
                        theme.textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopProductsList extends StatelessWidget {
  const _TopProductsList({required this.products, this.showProfit = false});

  final List<ReportProductRow> products;
  final bool showProfit;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyState(
        title: 'No product data',
        message: 'Top products appear after POS sales in this period.',
        icon: Symbols.inventory_2,
      );
    }

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Top products', subtitle: 'By revenue'),
          const SizedBox(height: AppSpacing.sm),
          ...products.map(
            (product) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(product.name),
              subtitle: Text(
                '${product.sku} · ${product.unitsSold} units sold',
              ),
              trailing: Text(
                showProfit
                    ? CurrencyFormatter.format(product.estimatedProfit)
                    : CurrencyFormatter.format(product.revenue),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: showProfit ? AppColors.success : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.total,
    required this.trailing,
  });

  final String label;
  final double value;
  final double total;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final share = total <= 0 ? 0.0 : value / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(CurrencyFormatter.format(value)),
            ],
          ),
          Text(trailing, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: share,
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
