import 'package:flutter/material.dart';

import '../themes/app_durations.dart';
import '../themes/app_radii.dart';
import '../themes/app_shadows.dart';
import '../themes/app_spacing.dart';

/// Elevated surface used for dashboard panels and lists.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = color ?? theme.cardTheme.color ?? theme.colorScheme.surface;

    // Material must own the card color so ListTile / SwitchListTile ink
    // paints on it. Putting color only on a Container above ListTiles
    // triggers Flutter's "ink splashes may be invisible" assertion.
    final card = AnimatedContainer(
      duration: AppDurations.fast,
      decoration: BoxDecoration(
        borderRadius: AppRadii.mdAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.6),
        ),
        boxShadow: AppShadows.sm(theme.brightness),
      ),
      child: Material(
        color: surface,
        borderRadius: AppRadii.mdAll,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );

    if (onTap == null) return card;

    return HoverScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdAll,
          child: card,
        ),
      ),
    );
  }
}

/// Subtle scale on desktop hover.
class HoverScale extends StatefulWidget {
  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.01,
  });

  final Widget child;
  final double scale;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.scale : 1,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
