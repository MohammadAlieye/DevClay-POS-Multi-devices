import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../routes/app_routes.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/report_catalog.dart';
import '../../domain/entities/report_detail_payload.dart';
import '../bloc/reports_bloc.dart';
import '../widgets/report_section_grid.dart';
import 'report_detail_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reportId = GoRouterState.of(context).pathParameters['reportId'];
    if (reportId != null) {
      return ReportDetailPage(reportId: reportId);
    }
    return BlocProvider(
      create: (_) => sl<ReportsBloc>()..add(const ReportsCenterStarted()),
      child: const ReportsCenterPage(),
    );
  }
}

class ReportsCenterPage extends StatelessWidget {
  const ReportsCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        return switch (state) {
          ReportsInitial() || ReportsCenterReady() => _CenterContent(
            filterOptions: state is ReportsCenterReady
                ? state.filterOptions
                : const ReportFilterOptions(),
          ),
          ReportsError(:final message) => EmptyState(
            title: 'Reports unavailable',
            message: message,
            icon: Symbols.bar_chart,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<ReportsBloc>().add(const ReportsCenterStarted()),
            ),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}

class _CenterContent extends StatefulWidget {
  const _CenterContent({required this.filterOptions});

  final ReportFilterOptions filterOptions;

  @override
  State<_CenterContent> createState() => _CenterContentState();
}

class _CenterContentState extends State<_CenterContent> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleByCategory = <ReportCategory, List<ReportDefinition>>{
      for (final category in ReportCatalog.categories)
        category: ReportCatalog.forCategory(category).where((report) {
          if (normalizedQuery.isEmpty) return true;
          return report.title.toLowerCase().contains(normalizedQuery) ||
              report.description.toLowerCase().contains(normalizedQuery) ||
              category.label.toLowerCase().contains(normalizedQuery);
        }).toList(),
    };
    final visibleCount = visibleByCategory.values.fold<int>(
      0,
      (sum, reports) => sum + reports.length,
    );
    final availableCount = ReportCatalog.all
        .where((report) => report.available)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.45),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Symbols.monitoring,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reports Center',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Review business performance, inventory health, and financial activity.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$availableCount available',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppSearchField(
                width: double.infinity,
                hintText: 'Search reports by name or category…',
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (visibleCount == 0)
                const EmptyState(
                  title: 'No reports found',
                  message: 'Try a different report name or category.',
                  icon: Symbols.search_off,
                )
              else
                for (final category in ReportCatalog.categories)
                  if (visibleByCategory[category]!.isNotEmpty) ...[
                    ReportSectionGrid(
                      category: category,
                      reports: visibleByCategory[category]!,
                      onReportTap: (definition) {
                        context.go(
                          '${AppRoutes.reports}/${definition.routeSegment}',
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
            ],
          ),
        ),
      ),
    );
  }
}
