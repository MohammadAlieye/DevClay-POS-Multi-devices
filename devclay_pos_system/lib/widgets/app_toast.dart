import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../themes/app_colors.dart';
import '../themes/app_radii.dart';
import '../themes/app_spacing.dart';
import '../services/feedback/app_sound_service.dart';

enum AppToastTone { success, error, info }

/// Visual toast card — use via [AppToast.show] or embed (e.g. POS flash).
class AppToastBanner extends StatelessWidget {
  const AppToastBanner({
    super.key,
    required this.message,
    this.tone = AppToastTone.info,
    this.title,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.compact = true,
    this.maxWidth = 360,
  });

  final String message;
  final AppToastTone tone;
  final String? title;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;
  final double maxWidth;

  static AppToastTone toneForMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('error') ||
        lower.contains('failed') ||
        lower.contains('out of stock') ||
        lower.contains('not found') ||
        lower.contains('please refill') ||
        lower.contains('cannot') ||
        lower.contains('invalid') ||
        lower.contains('required') ||
        lower.contains('too long') ||
        lower.contains('already exists') ||
        lower.contains('recycle bin')) {
      if (lower.contains('recycle bin') || lower.contains('moved to')) {
        return AppToastTone.info;
      }
      return AppToastTone.error;
    }
    if (lower.contains('copied') ||
        lower.contains('saved') ||
        lower.contains('sent') ||
        lower.contains('updated') ||
        lower.contains('created') ||
        lower.contains('restored') ||
        lower.contains('done') ||
        lower.contains('success')) {
      return AppToastTone.success;
    }
    return AppToastTone.info;
  }

  Color get _accent => switch (tone) {
    AppToastTone.success => AppColors.success,
    AppToastTone.error => AppColors.danger,
    AppToastTone.info => AppColors.accent,
  };

  IconData get _icon => switch (tone) {
    AppToastTone.success => Symbols.check_circle,
    AppToastTone.error => Symbols.error,
    AppToastTone.info => Symbols.info,
  };

  String get _resolvedTitle =>
      title ??
      switch (tone) {
        AppToastTone.success => 'Done',
        AppToastTone.error => 'Notice',
        AppToastTone.info => 'Info',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accent;
    final hasAction = actionLabel != null && onAction != null;

    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            compact ? AppSpacing.sm : AppSpacing.md,
            AppSpacing.xs,
            compact ? AppSpacing.sm : AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.mdAll,
            border: Border.all(color: accent.withValues(alpha: 0.45)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: compact ? 14 : 18,
                backgroundColor: accent.withValues(alpha: 0.12),
                child: Icon(_icon, size: compact ? 15 : 18, color: accent),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: compact
                    ? Text(
                        message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _resolvedTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            message,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
              ),
              if (hasAction)
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  child: Text(
                    actionLabel!,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: accent,
                    ),
                  ),
                ),
              if (onDismiss != null)
                IconButton(
                  tooltip: 'Dismiss',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  icon: Icon(Symbols.close, size: compact ? 16 : 18),
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single app-wide toast API. Prefer this over raw [SnackBar]s.
abstract final class AppToast {
  static const Duration duration = Duration(seconds: 3);

  static void show(
    BuildContext context,
    String message, {
    AppToastTone? tone,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final screenHeight = media.size.height;
    final maxWidth = (media.size.width * 0.62).clamp(220.0, 420.0);
    final resolvedTone = tone ?? AppToastBanner.toneForMessage(message);
    final hasAction = actionLabel != null && onAction != null;

    AppSounds.play(switch (resolvedTone) {
      AppToastTone.success => AppSound.success,
      AppToastTone.error => AppSound.error,
      AppToastTone.info => AppSound.info,
    });

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        duration: duration ??
            (hasAction ? const Duration(seconds: 6) : AppToast.duration),
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: screenHeight - topInset - 96,
        ),
        content: Align(
          alignment: Alignment.centerLeft,
          child: AppToastBanner(
            message: message,
            tone: resolvedTone,
            compact: true,
            maxWidth: maxWidth,
            actionLabel: actionLabel,
            onAction: hasAction
                ? () {
                    messenger.hideCurrentSnackBar();
                    onAction();
                  }
                : null,
            onDismiss: messenger.hideCurrentSnackBar,
          ),
        ),
      ),
    );
  }

  static void withUndo(
    BuildContext context,
    String message, {
    required VoidCallback onUndo,
    Duration duration = const Duration(seconds: 6),
  }) {
    show(
      context,
      message,
      tone: AppToastTone.info,
      duration: duration,
      actionLabel: 'Undo',
      onAction: onUndo,
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, tone: AppToastTone.success);

  static void error(BuildContext context, String message) =>
      show(context, message, tone: AppToastTone.error);

  static void info(BuildContext context, String message) =>
      show(context, message, tone: AppToastTone.info);
}
