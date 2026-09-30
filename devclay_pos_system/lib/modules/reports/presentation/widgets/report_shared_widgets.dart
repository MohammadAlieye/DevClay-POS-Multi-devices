import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_toast.dart';
import '../../data/services/report_export_service.dart';

class ReportExportButton extends StatelessWidget {
  const ReportExportButton({
    super.key,
    required this.buildPayload,
  });

  final Future<ReportExportPayload> Function() buildPayload;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReportExportFormat>(
      tooltip: 'Export report',
      icon: const Icon(Symbols.download),
      onSelected: (format) async {
        try {
          final payload = await buildPayload();
          final path = await ReportExportService.export(
            payload: payload,
            format: format,
          );
          if (!context.mounted) return;
          if (path == null) return;
          AppToast.success(context, 'Report saved');
        } catch (error) {
          if (!context.mounted) return;
          AppToast.error(context, 'Export failed: $error');
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: ReportExportFormat.pdf,
          child: Text('Export PDF'),
        ),
        PopupMenuItem(
          value: ReportExportFormat.xlsx,
          child: Text('Export Excel'),
        ),
        PopupMenuItem(
          value: ReportExportFormat.csv,
          child: Text('Export CSV'),
        ),
      ],
    );
  }
}

class ReportSummaryCards extends StatelessWidget {
  const ReportSummaryCards({super.key, required this.cards});

  final List<ReportSummaryCardData> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final count = width >= 1000
            ? 4
            : width >= 700
                ? 3
                : width >= 480
                    ? 2
                    : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: count == 1 ? 3.5 : 2.2,
          children: cards.map((c) => _SummaryCard(data: c)).toList(),
        );
      },
    );
  }
}

class ReportSummaryCardData {
  const ReportSummaryCardData({
    required this.label,
    required this.value,
    this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color? color;
  final IconData? icon;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final ReportSummaryCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (data.icon != null) ...[
                  Icon(data.icon, size: 18, color: data.color),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    data.label,
                    style: theme.textTheme.labelMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              data.value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: data.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDataTable extends StatelessWidget {
  const ReportDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyMessage = 'No data found for this period.',
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(child: Text(emptyMessage)),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns,
        rows: rows,
      ),
    );
  }
}
