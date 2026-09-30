import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/section_header.dart';
import '../../domain/entities/dashboard_data.dart';

class LowStockCard extends StatelessWidget {
  const LowStockCard({super.key, required this.items});

  final List<LowStockAlert> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Low stock',
            subtitle: 'Needs attention',
          ),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty)
            Text(
              'Stock levels look healthy.',
              style: theme.textTheme.bodyMedium,
            )
          else
            ...items.map((item) {
            final critical = item.quantity <= (item.reorderLevel / 4);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (critical ? AppColors.danger : AppColors.warning)
                          .withValues(alpha: 0.12),
                      borderRadius: AppRadii.xsAll,
                    ),
                    child: Icon(
                      Symbols.inventory,
                      size: 18,
                      color: critical ? AppColors.danger : AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: theme.textTheme.titleSmall),
                        Text(
                          '${item.sku} · reorder at ${item.reorderLevel}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${item.quantity} left',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: critical ? AppColors.danger : AppColors.warning,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
