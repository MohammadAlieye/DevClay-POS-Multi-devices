import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../themes/app_colors.dart';
import '../themes/app_radii.dart';

/// Renders a local product image or a placeholder.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.path,
    this.size = 48,
    this.borderRadius = AppRadii.sm,
    this.backgroundColor,
  });

  final String? path;

  /// Pass [double.infinity] to expand inside a bounded parent.
  final double size;
  final double borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final hasFile =
        path != null && path!.isNotEmpty && File(path!).existsSync();
    final expand = size == double.infinity;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.darkCard : Colors.white);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: expand ? double.infinity : size,
        height: expand ? double.infinity : size,
        color: bg,
        alignment: Alignment.center,
        child: hasFile
            ? Image.file(
                File(path!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, error, stackTrace) =>
                    _placeholder(expand ? 40 : size),
              )
            : _placeholder(expand ? 40 : size),
      ),
    );
  }

  Widget _placeholder(double iconBox) {
    return Icon(
      Symbols.inventory_2,
      color: AppColors.accent,
      size: iconBox * 0.8,
    );
  }
}
