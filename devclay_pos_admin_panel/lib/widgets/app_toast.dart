import 'package:flutter/material.dart';

enum AppToastTone { success, error, info }

/// Shared toast card used by [AppToast.show] across the admin panel.
class AppToastBanner extends StatelessWidget {
  const AppToastBanner({
    super.key,
    required this.message,
    this.tone = AppToastTone.info,
    this.onDismiss,
    this.maxWidth = 360,
  });

  final String message;
  final AppToastTone tone;
  final VoidCallback? onDismiss;
  final double maxWidth;

  static AppToastTone toneForMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('error') ||
        lower.contains('failed') ||
        lower.contains('required') ||
        lower.contains('select') ||
        lower.contains('invalid')) {
      return AppToastTone.error;
    }
    if (lower.contains('copied') ||
        lower.contains('saved') ||
        lower.contains('created') ||
        lower.contains('updated') ||
        lower.contains('success')) {
      return AppToastTone.success;
    }
    return AppToastTone.info;
  }

  Color get _accent => switch (tone) {
    AppToastTone.success => const Color(0xFF059669),
    AppToastTone.error => const Color(0xFFDC2626),
    AppToastTone.info => const Color(0xFF0F4C5C),
  };

  IconData get _icon => switch (tone) {
    AppToastTone.success => Icons.check_circle_outline,
    AppToastTone.error => Icons.error_outline,
    AppToastTone.info => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accent;

    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: accent.withValues(alpha: 0.12),
                child: Icon(_icon, size: 15, color: accent),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
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
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: onDismiss,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single toast API for the admin panel — use instead of raw SnackBars.
abstract final class AppToast {
  static const Duration duration = Duration(seconds: 3);

  static void show(
    BuildContext context,
    String message, {
    AppToastTone? tone,
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final screenHeight = media.size.height;
    final maxWidth = (media.size.width * 0.65).clamp(200.0, 360.0);
    final resolvedTone = tone ?? AppToastBanner.toneForMessage(message);

    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? AppToast.duration,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: screenHeight - topInset - 96,
        ),
        content: Align(
          alignment: Alignment.centerLeft,
          child: AppToastBanner(
            message: message,
            tone: resolvedTone,
            maxWidth: maxWidth,
            onDismiss: messenger.hideCurrentSnackBar,
          ),
        ),
      ),
    );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, tone: AppToastTone.success);

  static void error(BuildContext context, String message) =>
      show(context, message, tone: AppToastTone.error);

  static void info(BuildContext context, String message) =>
      show(context, message, tone: AppToastTone.info);
}
