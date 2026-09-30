import 'package:flutter/material.dart';

import '../../../../themes/app_colors.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../domain/entities/pos_entities.dart';

/// POS product/cart colours — **purpose only** (not decorative stripes).
enum PosStockStatus { normal, lowStock, expired, outOfStock }

class PosProductVisual {
  const PosProductVisual({
    required this.status,
    required this.accent,
    required this.fill,
    required this.border,
    this.badgeLabel,
  });

  final PosStockStatus status;
  final Color accent;
  final Color fill;
  final Color border;

  /// Shown on tile / cart row when not normal (e.g. Expired, Low stock, Out).
  final String? badgeLabel;

  bool get isAlert => status != PosStockStatus.normal;

  static PosStockStatus statusOf(PosProduct product, {int? availableStock}) {
    if (product.isExpired) return PosStockStatus.expired;
    final stock = availableStock ?? product.stock;
    if (stock <= 0) return PosStockStatus.outOfStock;
    if (stock <= resolveLowStockThreshold(product.lowStockThreshold)) {
      return PosStockStatus.lowStock;
    }
    return PosStockStatus.normal;
  }

  static PosProductVisual forProduct(
    BuildContext context,
    PosProduct product, {
    int? availableStock,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final normalFill = isDark ? AppColors.darkCard : Colors.white;
    final normalBorder = isDark
        ? AppColors.darkBorder
        : const Color(0xFFD5DCE8);
    final normalAccent = theme.colorScheme.onSurface;

    switch (statusOf(product, availableStock: availableStock)) {
      case PosStockStatus.expired:
        return PosProductVisual(
          status: PosStockStatus.expired,
          accent: AppColors.danger,
          fill: AppColors.danger.withValues(alpha: isDark ? 0.16 : 0.07),
          border: AppColors.danger.withValues(alpha: 0.42),
          badgeLabel: 'Expired',
        );
      case PosStockStatus.outOfStock:
        return PosProductVisual(
          status: PosStockStatus.outOfStock,
          accent: AppColors.danger,
          fill: normalFill,
          border: AppColors.danger.withValues(alpha: 0.35),
          badgeLabel: 'Out',
        );
      case PosStockStatus.lowStock:
        return PosProductVisual(
          status: PosStockStatus.lowStock,
          accent: AppColors.warning,
          fill: AppColors.warning.withValues(alpha: isDark ? 0.14 : 0.09),
          border: AppColors.warning.withValues(alpha: 0.42),
          badgeLabel: 'Low stock',
        );
      case PosStockStatus.normal:
        return PosProductVisual(
          status: PosStockStatus.normal,
          accent: normalAccent,
          fill: normalFill,
          border: normalBorder,
        );
    }
  }
}

/// Legacy helpers — prefer [PosProductVisual.forProduct].
abstract final class PosItemColors {
  static PosProductVisual visualFor(BuildContext context, PosProduct product) {
    return PosProductVisual.forProduct(context, product);
  }
}
