import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../themes/app_colors.dart';
import '../themes/app_radii.dart';
import '../themes/app_spacing.dart';
import 'app_card.dart';

/// KPI metric card with optional trend indicator.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.changePercent,
    this.accentColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final double? changePercent;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final change = changePercent;
    final isPositive = change == null || change >= 0;
    final accent = accentColor ?? AppColors.accent;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: AppRadii.smAll,
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const Spacer(),
              if (change != null)
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (isPositive ? AppColors.success : AppColors.danger)
                          .withValues(alpha: 0.12),
                      borderRadius: AppRadii.xsAll,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Symbols.trending_up
                              : Symbols.trending_down,
                          size: 14,
                          color:
                              isPositive ? AppColors.success : AppColors.danger,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${change.abs().toStringAsFixed(1)}%',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: isPositive
                                  ? AppColors.success
                                  : AppColors.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
