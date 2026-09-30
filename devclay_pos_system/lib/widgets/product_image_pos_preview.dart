import 'dart:io';

import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_radii.dart';
import '../themes/app_spacing.dart';
import 'product_image.dart';

/// Shows how a product image will appear on POS tiles — square crop, cover fit.
class ProductImagePosPreview extends StatelessWidget {
  const ProductImagePosPreview({
    super.key,
    required this.path,
    this.size = 132,
    this.label = 'POS preview',
    this.centered = false,
    this.showLabel = true,
  });

  final String? path;
  final double size;
  final String label;
  final bool centered;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasFile =
        path != null && path!.isNotEmpty && File(path!).existsSync();

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Text(
            label,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
        ],
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            foregroundPainter: _DashedBorderPainter(
              radius: AppRadii.sm,
              color: isDark
                  ? AppColors.accent.withValues(alpha: 0.7)
                  : AppColors.accent.withValues(alpha: 0.55),
            ),
            child: ClipRRect(
              borderRadius: AppRadii.smAll,
              child: ProductImage(
                path: hasFile ? path : null,
                size: size,
                borderRadius: AppRadii.sm,
                backgroundColor: isDark
                    ? AppColors.darkSurfaceMuted
                    : const Color(0xFFF3F6FA),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.radius, required this.color});

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dash = 6.0;
    const gap = 4.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
