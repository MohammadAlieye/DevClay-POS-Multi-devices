import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../routes/app_routes.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/section_header.dart';
import '../../domain/entities/dashboard_data.dart';

/// Snapshot of money in/out and credit from newer modules.
class BusinessSnapshotCard extends StatelessWidget {
  const BusinessSnapshotCard({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tiles = [
      _SnapshotTile(
        label: 'To take',
        value: CurrencyFormatter.format(data.receivablesDue),
        icon: Symbols.call_received,
        color: KhataBalanceRules.takeColor,
        route: AppRoutes.customers,
      ),
      _SnapshotTile(
        label: 'To give',
        value: CurrencyFormatter.format(data.payablesDue),
        icon: Symbols.local_shipping,
        color: KhataBalanceRules.giveColor,
        route: AppRoutes.purchases,
      ),
      _SnapshotTile(
        label: 'Cash on hand',
        value: CurrencyFormatter.format(data.cashOnHand),
        icon: Symbols.payments,
        color: AppColors.success,
        route: AppRoutes.accounts,
      ),
      _SnapshotTile(
        label: "Today's khata sales",
        value: CurrencyFormatter.format(data.todayKhataSales),
        icon: Symbols.receipt_long,
        color: AppColors.accent,
        route: AppRoutes.sales,
      ),
      _SnapshotTile(
        label: "Today's expenses",
        value: CurrencyFormatter.format(data.todayExpenses),
        icon: Symbols.money_off,
        color: AppColors.primary,
        route: AppRoutes.finance,
      ),
      _SnapshotTile(
        label: 'Month expenses',
        value: CurrencyFormatter.compact(data.monthlyExpenses),
        icon: Symbols.calendar_month,
        color: AppColors.primary,
        route: AppRoutes.finance,
      ),
    ];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Business snapshot',
            subtitle: 'Take, give, cash, and expenses',
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 720;
              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: tiles
                    .map(
                      (tile) => SizedBox(
                        width: wide
                            ? (constraints.maxWidth - AppSpacing.sm * 2) / 3
                            : (constraints.maxWidth - AppSpacing.sm) / 2,
                        child: _SnapshotTileView(tile: tile),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          if (data.topDebtors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Top khata balances',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...data.topDebtors.map(
              (debtor) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        debtor.name,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(debtor.balance),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: KhataBalanceRules.takeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SnapshotTile {
  const _SnapshotTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String route;
}

class _SnapshotTileView extends StatelessWidget {
  const _SnapshotTileView({required this.tile});

  final _SnapshotTile tile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(tile.route),
        borderRadius: AppRadii.smAll,
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: tile.color.withValues(alpha: 0.08),
            borderRadius: AppRadii.smAll,
            border: Border.all(color: tile.color.withValues(alpha: 0.16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(tile.icon, color: tile.color, size: 20),
              const SizedBox(height: AppSpacing.sm),
              Text(
                tile.label,
                style: theme.textTheme.labelMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                tile.value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Held bills + backup health strip.
class AttentionStripCard extends StatelessWidget {
  const AttentionStripCard({super.key, required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final backupLabel = data.lastBackupAt == null
        ? 'No backup yet'
        : 'Last backup ${dateFormat.format(data.lastBackupAt!)}';
    final backupDetail = data.lastBackupAt == null
        ? 'Create a backup from Settings'
        : data.backupAgeDays == 0
            ? 'Backed up today'
            : '${data.backupAgeDays} day(s) ago';

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _AttentionRow(
            icon: Symbols.pause_circle,
            color: data.heldSalesCount > 0
                ? AppColors.warning
                : AppColors.success,
            title: data.heldSalesCount > 0
                ? '${data.heldSalesCount} held sale(s)'
                : 'No held sales',
            subtitle: data.heldSalesCount > 0
                ? 'Resume unfinished bills in POS'
                : 'All open carts are clear',
            actionLabel: 'Open POS',
            onTap: () => context.go(AppRoutes.pos),
          ),
          const Divider(height: AppSpacing.lg),
          _AttentionRow(
            icon: Symbols.cloud_upload,
            color: data.backupNeedsAttention
                ? AppColors.danger
                : AppColors.success,
            title: backupLabel,
            subtitle: backupDetail,
            actionLabel: 'Backup',
            onTap: () => context.go(AppRoutes.settings),
          ),
          if (data.expiredProductCount > 0 ||
              data.expiringSoonCount > 0) ...[
            const Divider(height: AppSpacing.lg),
            _AttentionRow(
              icon: Symbols.event_busy,
              color: data.expiredProductCount > 0
                  ? AppColors.danger
                  : AppColors.warning,
              title: data.expiredProductCount > 0
                  ? '${data.expiredProductCount} expired · ${data.expiringSoonCount} soon'
                  : '${data.expiringSoonCount} product(s) expiring soon',
              subtitle: 'Check products with stock still on shelf',
              actionLabel: 'Products',
              onTap: () => context.go(AppRoutes.products),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pull to refresh anytime',
              style: theme.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: AppRadii.smAll,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        TextButton(onPressed: onTap, child: Text(actionLabel)),
      ],
    );
  }
}

class ExpiryWatchCard extends StatelessWidget {
  const ExpiryWatchCard({super.key, required this.items});

  final List<ExpiryWatchItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Expiry watch',
            subtitle: 'Expired or within 30 days',
          ),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty)
            Text(
              'No expiry alerts right now.',
              style: theme.textTheme.bodyMedium,
            )
          else
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: (item.isExpired
                                ? AppColors.danger
                                : AppColors.warning)
                            .withValues(alpha: 0.12),
                        borderRadius: AppRadii.xsAll,
                      ),
                      child: Icon(
                        item.isExpired
                            ? Symbols.event_busy
                            : Symbols.schedule,
                        size: 18,
                        color: item.isExpired
                            ? AppColors.danger
                            : AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: theme.textTheme.titleSmall),
                          Text(
                            '${item.sku} · ${dateFormat.format(item.expiryDate)}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.isExpired ? 'Expired' : 'Soon',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: item.isExpired
                                ? AppColors.danger
                                : AppColors.warning,
                          ),
                        ),
                        Text(
                          '${item.stock} left',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
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
