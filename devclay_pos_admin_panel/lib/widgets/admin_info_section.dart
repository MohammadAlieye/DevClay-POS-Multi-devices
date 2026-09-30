import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_toast.dart';

/// Shared labeled info rows used across Admin detail dialogs.
class AdminInfoSection extends StatelessWidget {
  const AdminInfoSection({
    super.key,
    required this.title,
    required this.rows,
    this.trailing,
  });

  final String title;
  final List<AdminInfoRowData> rows;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = rows.where((r) => r.value.trim().isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.45,
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: [
              for (final row in visible) AdminInfoRow(data: row),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminInfoRowData {
  const AdminInfoRowData({
    required this.label,
    required this.value,
    this.monospace = false,
    this.copyable = true,
  });

  final String label;
  final String value;
  final bool monospace;
  final bool copyable;
}

class AdminInfoRow extends StatelessWidget {
  const AdminInfoRow({super.key, required this.data});

  final AdminInfoRowData data;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: data.value));
    if (!context.mounted) return;
    AppToast.show(context, '${data.label} copied');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              data.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              data.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: data.monospace ? 'monospace' : null,
              ),
            ),
          ),
          if (data.copyable)
            IconButton(
              tooltip: 'Copy ${data.label}',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.copy, size: 16),
              onPressed: () => _copy(context),
            ),
        ],
      ),
    );
  }
}

class AdminStatusChip extends StatelessWidget {
  const AdminStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
