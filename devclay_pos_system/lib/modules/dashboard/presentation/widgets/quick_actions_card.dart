import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../routes/app_routes.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/section_header.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        label: 'New sale',
        icon: Symbols.shopping_cart,
        color: AppColors.accent,
        route: AppRoutes.pos,
      ),
      const _QuickAction(
        label: 'Add product',
        icon: Symbols.add_box,
        color: AppColors.success,
        route: AppRoutes.products,
      ),
      const _QuickAction(
        label: 'Purchases',
        icon: Symbols.local_shipping,
        color: AppColors.warning,
        route: AppRoutes.purchases,
      ),
      _QuickAction(
        label: 'Customers',
        icon: Symbols.group,
        color: AppColors.accent,
        route: AppRoutes.customers,
      ),
      _QuickAction(
        label: 'Finance',
        icon: Symbols.account_balance,
        color: AppColors.primary,
        route: AppRoutes.finance,
      ),
      _QuickAction(
        label: 'Reports',
        icon: Symbols.bar_chart,
        color: AppColors.primary,
        route: AppRoutes.reports,
      ),
    ];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Quick actions',
            subtitle: 'Jump into daily workflows',
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: actions
                .map(
                  (action) => _QuickActionTile(
                    action: action,
                    onTap: () => context.go(action.route),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String route;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action, required this.onTap});

  final _QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smAll,
        child: Ink(
          width: 150,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: action.color.withValues(alpha: 0.08),
            borderRadius: AppRadii.smAll,
            border: Border.all(color: action.color.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(action.icon, color: action.color, size: 22),
              const SizedBox(height: AppSpacing.sm),
              Text(action.label, style: theme.textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
