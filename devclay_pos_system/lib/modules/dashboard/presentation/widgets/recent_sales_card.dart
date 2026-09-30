import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/section_header.dart';
import '../../domain/entities/dashboard_data.dart';

class RecentSalesCard extends StatelessWidget {
  const RecentSalesCard({super.key, required this.sales});

  final List<RecentSaleItem> sales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeFormat = DateFormat('h:mm a');

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent sales',
            subtitle: 'Latest tickets at the counter',
          ),
          const SizedBox(height: AppSpacing.md),
          ...sales.map((sale) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.45),
                borderRadius: AppRadii.smAll,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sale.invoiceNo, style: theme.textTheme.titleSmall),
                        Text(
                          sale.customerName,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      sale.paymentMethod,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      timeFormat.format(sale.soldAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(sale.amount),
                    style: theme.textTheme.titleSmall,
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
