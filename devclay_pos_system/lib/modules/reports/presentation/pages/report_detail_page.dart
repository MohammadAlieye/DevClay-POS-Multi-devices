import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../../../routes/app_routes.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/report_catalog.dart';
import '../../domain/entities/report_filters.dart';
import '../bloc/reports_bloc.dart';
import '../widgets/report_export_builder.dart';
import '../widgets/report_filter_toolbar.dart';
import '../widgets/report_shared_widgets.dart';
import 'report_body.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    final definition = ReportCatalog.findByRoute(reportId);
    if (definition == null) {
      return EmptyState(
        title: 'Report not found',
        message: 'The report "$reportId" does not exist.',
        icon: Symbols.bar_chart,
        action: AppButton(
          label: 'Back to Reports',
          onPressed: () => context.go(AppRoutes.reports),
        ),
      );
    }

    return BlocProvider(
      create: (_) => sl<ReportsBloc>()
        ..add(ReportDetailStarted(
          reportId: definition.id,
          filters: _initialFilters(definition.id),
        )),
      child: _ReportDetailView(definition: definition),
    );
  }

  ReportFilters _initialFilters(ReportId id) {
    return switch (id) {
      ReportId.expiredProducts =>
        const ReportFilters(expiryWithinDays: -1),
      ReportId.expiringSoon =>
        const ReportFilters(expiryWithinDays: 30),
      ReportId.expiry =>
        const ReportFilters(expiryWithinDays: 90),
      _ => const ReportFilters(),
    };
  }
}

class _ReportDetailView extends StatelessWidget {
  const _ReportDetailView({required this.definition});

  final ReportDefinition definition;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsBloc, ReportsState>(
      builder: (context, state) {
        if (state is ReportDetailLoaded && state.reportId == definition.id) {
          return _LoadedScaffold(definition: definition, state: state);
        }
        if (state is ReportDetailLoading && state.reportId == definition.id) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ReportsError) {
          return EmptyState(
            title: 'Report unavailable',
            message: state.message,
            icon: Symbols.bar_chart,
            action: AppButton(
              label: 'Retry',
              onPressed: () => context.read<ReportsBloc>().add(
                    ReportDetailStarted(reportId: definition.id),
                  ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _LoadedScaffold extends StatelessWidget {
  const _LoadedScaffold({
    required this.definition,
    required this.state,
  });

  final ReportDefinition definition;
  final ReportDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rangeLabel = reportDateRangeDetail(state.dateRange, state.filters);

    if (!definition.available) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: EmptyState(
          title: definition.title,
          message: definition.unavailableMessage ??
              'This report is not available yet.',
          icon: definition.icon,
          action: AppButton(
            label: 'Back to Reports',
            onPressed: () => context.go(AppRoutes.reports),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => context.go(AppRoutes.reports),
                icon: const Icon(Symbols.arrow_back),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      definition.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.secondary,
                icon: Symbols.refresh,
                onPressed: () => context
                    .read<ReportsBloc>()
                    .add(const ReportsRefreshRequested()),
              ),
              const SizedBox(width: AppSpacing.xs),
              ReportExportButton(
                buildPayload: () async {
                  final settings = await sl<SettingsRepository>().getSettings();
                  return buildReportExportPayload(
                    definition: definition,
                    state: state,
                    businessName: settings.businessName.isNotEmpty
                        ? settings.businessName
                        : 'My Store',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            rangeLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ReportFilterToolbar(
            filters: state.filters,
            filterOptions: state.filterOptions,
            requiresPeriod: definition.requiresPeriod,
            showExpiryFilters: definition.id == ReportId.expiry ||
                definition.id == ReportId.expiringSoon,
            onFiltersChanged: (filters) => context.read<ReportsBloc>().add(
                  ReportFiltersChanged(filters),
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ReportBody(
              definition: definition,
              state: state,
              periodLabel: rangeLabel,
            ),
          ),
        ],
      ),
    );
  }
}
