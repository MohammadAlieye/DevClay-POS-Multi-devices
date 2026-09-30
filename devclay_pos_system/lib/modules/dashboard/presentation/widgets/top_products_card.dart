import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/section_header.dart';
import '../../domain/entities/dashboard_data.dart';

class TopProductsCard extends StatelessWidget {
  const TopProductsCard({super.key, required this.products});

  final List<TopProductItem> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Top products',
            subtitle: 'By units sold today',
          ),
          const SizedBox(height: AppSpacing.md),
          ...products.map((product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: AppRadii.xsAll,
                    ),
                    child: Text(
                      '${product.rank}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: theme.textTheme.titleMedium),
                        Text(product.sku, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.format(product.revenue),
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        '${product.unitsSold} sold',
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
