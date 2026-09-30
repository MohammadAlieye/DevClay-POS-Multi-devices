import 'package:flutter/material.dart';

import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_skeleton.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: List.generate(
            4,
            (_) => const SizedBox(
              width: 260,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppSkeleton(width: 40, height: 40, borderRadius: AppRadii.sm),
                    SizedBox(height: AppSpacing.md),
                    AppSkeleton(width: 100, height: 12),
                    SizedBox(height: AppSpacing.sm),
                    AppSkeleton(width: 140, height: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeleton(width: 160, height: 18),
              SizedBox(height: AppSpacing.md),
              AppSkeleton(height: 220, borderRadius: AppRadii.md),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppCard(
                child: Column(
                  children: [
                    AppSkeleton(height: 18, width: 120),
                    SizedBox(height: AppSpacing.md),
                    AppSkeleton(height: 180),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppCard(
                child: Column(
                  children: [
                    AppSkeleton(height: 18, width: 120),
                    SizedBox(height: AppSpacing.md),
                    AppSkeleton(height: 180),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
