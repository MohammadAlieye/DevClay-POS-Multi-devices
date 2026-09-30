import 'package:flutter/material.dart';

import '../themes/app_spacing.dart';

/// Section title with optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(subtitle!, style: theme.textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
