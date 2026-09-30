import 'package:flutter/material.dart';

import '../themes/app_radii.dart';
import '../themes/app_spacing.dart';
import '../services/feedback/app_sound_service.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

/// Primary action button with consistent sizing and variants.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expanded = false,
    this.isLoading = false,
    this.height,
    this.iconSize = 18,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expanded;
  final bool isLoading;
  /// When set, overrides the default 48px touch height.
  final double? height;
  final double iconSize;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final minHeight = height ?? 48;
    final labelWidget = Text(
      label,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: labelStyle,
    );
    final child = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        else if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: AppSpacing.xs),
        ],
        if (expanded) Flexible(child: labelWidget) else labelWidget,
      ],
    );

    final sizeStyle = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(48, minHeight)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: height != null ? 24 : 20,
          vertical: height != null ? 16 : 14,
        ),
      ),
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: isLoading ? null : _wrapTap(onPressed),
          style: sizeStyle,
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: isLoading ? null : _wrapTap(onPressed),
          style: sizeStyle,
          child: child,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: isLoading ? null : _wrapTap(onPressed),
          style: sizeStyle,
          child: child,
        ),
      AppButtonVariant.danger => FilledButton(
          onPressed: isLoading ? null : _wrapTap(onPressed),
          style: sizeStyle.merge(
            FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
          child: child,
        ),
    };

    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  VoidCallback? _wrapTap(VoidCallback? onPressed) {
    if (onPressed == null) return null;
    return () {
      AppSounds.play(AppSound.tap);
      onPressed();
    };
  }
}


/// Icon-only button with large touch target.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.selected = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final button = InkWell(
      onTap: _wrapTap(onPressed),
      borderRadius: AppRadii.smAll,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: AppSpacing.touchTarget,
        height: AppSpacing.touchTarget,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: AppRadii.smAll,
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected
              ? theme.colorScheme.primary
              : theme.iconTheme.color,
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }

  VoidCallback? _wrapTap(VoidCallback? onPressed) {
    if (onPressed == null) return null;
    return () {
      AppSounds.play(AppSound.tap);
      onPressed();
    };
  }
}
