import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_card.dart';
import '../../domain/entities/report_catalog.dart';

class ReportSectionGrid extends StatelessWidget {
  const ReportSectionGrid({
    super.key,
    required this.category,
    required this.onReportTap,
    this.reports,
  });

  final ReportCategory category;
  final ValueChanged<ReportDefinition> onReportTap;
  final List<ReportDefinition>? reports;

  @override
  Widget build(BuildContext context) {
    final categoryReports = reports ?? ReportCatalog.forCategory(category);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              category.label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadii.full),
              ),
              child: Text(
                '${categoryReports.length}',
                style: theme.textTheme.labelSmall,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 1200
                ? 4
                : constraints.maxWidth >= 860
                ? 3
                : constraints.maxWidth >= 600
                ? 2
                : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                mainAxisExtent: crossAxisCount == 1 ? 116 : 132,
              ),
              itemCount: categoryReports.length,
              itemBuilder: (context, index) {
                final report = categoryReports[index];
                return _ReportCard(
                  definition: report,
                  onTap: () => onReportTap(report),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.definition, required this.onTap});

  final ReportDefinition definition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unavailable = !definition.available;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: unavailable
                    ? theme.colorScheme.surfaceContainerHighest
                    : AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: Icon(
                definition.icon,
                color: unavailable ? theme.disabledColor : AppColors.accent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    definition.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    definition.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            if (unavailable)
              Tooltip(
                message: 'Coming soon',
                child: Icon(Symbols.lock, size: 18, color: theme.disabledColor),
              )
            else
              Icon(Symbols.arrow_forward, size: 18, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
