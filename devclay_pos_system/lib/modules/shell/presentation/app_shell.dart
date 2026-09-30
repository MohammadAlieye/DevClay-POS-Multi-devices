import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../constants/app_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/lan_api/client/lan_connection_monitor.dart';
import '../../../core/lan_api/lan_mode_service.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../modules/auth/presentation/widgets/sign_out_dialog.dart';
import '../../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../routes/app_routes.dart';
import '../../../modules/reports/domain/entities/report_catalog.dart';
import '../../../themes/app_colors.dart';
import '../../../themes/app_radii.dart';
import '../../../themes/app_spacing.dart';
import '../../../themes/theme_cubit.dart';
import '../../../widgets/app_toast.dart';
import 'widgets/app_sidebar.dart';
import 'widgets/shell_top_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _collapsed = false;
  bool _notificationsOpen = false;

  /// When on POS the sidebar is normally hidden; this pins it open.
  bool _posMenuOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().refresh();
      if (sl<LanModeService>().isClient) {
        sl<LanConnectionMonitor>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppBreakpoints.isCompact(context);
    final location = GoRouterState.of(context).uri.path;
    final onPos = location == AppRoutes.pos;
    final hideSidebar = onPos && !_posMenuOpen;
    final sidebarCollapsed = compact ? true : _collapsed;
    final authState = context.watch<AuthBloc>().state;
    final session = authState.sessionOrNull;
    final permissions = session?.user.permissions ?? const <String>[];
    final storeName = session?.store?.name ?? AppConstants.storeNamePlaceholder;
    final userName = session?.user.displayName ?? 'User';
    final userRole = session?.user.role ?? '';
    final unread = context.select<NotificationsCubit, int>(
      (c) => c.state.unreadCount,
    );

    // Rebuild shell + current page when theme accent/mode changes.
    return BlocBuilder<ThemeCubit, AppThemeState>(
      buildWhen: (prev, next) =>
          prev.accent != next.accent ||
          prev.primary != next.primary ||
          prev.mode != next.mode,
      builder: (context, _) {
        return Scaffold(
          body: Row(
            children: [
              AppSidebar(
                hidden: hideSidebar,
                collapsed: sidebarCollapsed,
                currentPath: location,
                permissions: permissions,
                onToggle: compact || hideSidebar
                    ? null
                    : () => setState(() => _collapsed = !_collapsed),
                onNavigate: (path) {
                  setState(() => _posMenuOpen = false);
                  if (sl<LanModeService>().isClient) {
                    sl<LanConnectionMonitor>().refresh();
                  }
                  context.go(path);
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    ShellTopBar(
                      title: _titleForPath(location),
                      storeName: storeName,
                      userName: userName,
                      userRole: userRole,
                      showGlobalSearch: _showGlobalSearch(location),
                      showBrandMenu: onPos,
                      brandMenuOpen: _posMenuOpen,
                      onBrandMenuPressed: onPos
                          ? () => setState(() => _posMenuOpen = !_posMenuOpen)
                          : null,
                      notificationCount: unread,
                      onNotificationsPressed: () async {
                        final opening = !_notificationsOpen;
                        setState(() => _notificationsOpen = opening);
                        if (opening) {
                          final cubit = context.read<NotificationsCubit>();
                          // Mark read first so badge clears; sync won't recreate.
                          await cubit.markAllRead();
                          if (!mounted) return;
                          await cubit.refresh();
                        }
                      },
                      notificationsOpen: _notificationsOpen,
                      onLogout: () => requestSignOut(context),
                      onSwitchStore: null,
                      showSwitchStore: false,
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          widget.child,
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.lg,
                            child:
                                BlocBuilder<
                                  NotificationsCubit,
                                  NotificationsState
                                >(
                                  buildWhen: (prev, next) =>
                                      prev.flashAlerts != next.flashAlerts,
                                  builder: (context, state) {
                                    if (state.flashAlerts.isEmpty) {
                                      return const SizedBox.shrink();
                                    }
                                    return _StockFlashStack(
                                      alerts: state.flashAlerts,
                                      onDismiss: () => context
                                          .read<NotificationsCubit>()
                                          .clearFlash(),
                                    );
                                  },
                                ),
                          ),
                          if (_notificationsOpen)
                            Positioned(
                              top: 0,
                              right: AppSpacing.lg,
                              child: _NotificationsPanel(
                                onDismiss: () =>
                                    setState(() => _notificationsOpen = false),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _titleForPath(String path) {
    if (path.startsWith('${AppRoutes.reports}/')) {
      final segment = path.split('/').last;
      final def = ReportCatalog.findByRoute(segment);
      return def?.title ?? 'Report';
    }
    return switch (path) {
      AppRoutes.dashboard => 'Dashboard',
      AppRoutes.pos => 'POS',
      AppRoutes.products => 'Products',
      AppRoutes.inventory => 'Inventory',
      AppRoutes.purchases => 'Purchases',
      AppRoutes.sales => 'Sales',
      AppRoutes.customers => 'Customers',
      AppRoutes.accounts => 'Accounts',
      AppRoutes.finance => 'Finance',
      AppRoutes.labels => 'Labels',
      AppRoutes.reports => 'Reports Center',
      AppRoutes.users => 'Users',
      AppRoutes.recycleBin => 'Recycle Bin',
      AppRoutes.settings => 'Settings',
      _ => AppConstants.appName,
    };
  }

  bool _showGlobalSearch(String path) {
    return switch (path) {
      AppRoutes.pos ||
      AppRoutes.products ||
      AppRoutes.inventory ||
      AppRoutes.purchases ||
      AppRoutes.sales ||
      AppRoutes.customers ||
      AppRoutes.accounts ||
      AppRoutes.finance ||
      AppRoutes.labels ||
      AppRoutes.reports ||
      AppRoutes.users ||
      AppRoutes.recycleBin ||
      AppRoutes.settings => false,
      _ => true,
    };
  }
}

class _StockFlashStack extends StatefulWidget {
  const _StockFlashStack({required this.alerts, required this.onDismiss});

  final List<AppNotificationItem> alerts;
  final VoidCallback onDismiss;

  @override
  State<_StockFlashStack> createState() => _StockFlashStackState();
}

class _StockFlashStackState extends State<_StockFlashStack> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 6), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final alert in widget.alerts.take(3))
            Container(
              width: 340,
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppRadii.mdAll,
                border: Border.all(
                  color: AppColors.danger.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.danger.withValues(alpha: 0.12),
                    child: const Icon(
                      Symbols.inventory_2,
                      size: 18,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.danger,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(alert.body, style: theme.textTheme.bodySmall),
                        const SizedBox(height: 4),
                        Text(
                          _formatNotificationTime(alert.createdAt),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: widget.onDismiss,
                    icon: const Icon(Symbols.close, size: 18),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationsPanel extends StatelessWidget {
  const _NotificationsPanel({required this.onDismiss});

  final VoidCallback onDismiss;

  Color _colorFor(String type) {
    return switch (type) {
      NotificationTypes.outOfStock => AppColors.danger,
      NotificationTypes.lowStock ||
      NotificationTypes.warning => AppColors.warning,
      NotificationTypes.backup => AppColors.accent,
      NotificationTypes.license => AppColors.danger,
      NotificationTypes.heldSale => AppColors.warning,
      NotificationTypes.recycle => AppColors.accent,
      NotificationTypes.success => AppColors.success,
      _ => AppColors.accent,
    };
  }

  IconData _iconFor(String type) {
    return switch (type) {
      NotificationTypes.outOfStock => Symbols.inventory_2,
      NotificationTypes.lowStock ||
      NotificationTypes.warning => Symbols.warning,
      NotificationTypes.backup => Symbols.backup,
      NotificationTypes.license => Symbols.verified,
      NotificationTypes.heldSale => Symbols.pause_circle,
      NotificationTypes.recycle => Symbols.delete,
      NotificationTypes.success => Symbols.trending_up,
      _ => Symbols.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = context.watch<NotificationsCubit>().state.items;
    final canClearAny = items.any((i) => i.canClear);

    return Material(
      elevation: 8,
      borderRadius: AppRadii.mdAll,
      color: theme.colorScheme.surface,
      child: Container(
        width: 380,
        constraints: const BoxConstraints(maxHeight: 460),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadii.mdAll,
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Notifications',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (canClearAny)
                  TextButton(
                    onPressed: () =>
                        context.read<NotificationsCubit>().clearDismissible(),
                    child: const Text('Clear'),
                  ),
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Symbols.close, size: 18),
                ),
              ],
            ),
            Text(
              'Tap × to dismiss any alert.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'No notifications right now.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final color = _colorFor(item.type);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.12),
                        child: Icon(
                          _iconFor(item.type),
                          size: 16,
                          color: color,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: theme.textTheme.titleSmall,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.displayBody,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatNotificationTime(item.createdAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (item.canUndo) ...[
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () async {
                                  final ok = await context
                                      .read<NotificationsCubit>()
                                      .undoNotification(item.id);
                                  if (!context.mounted) return;
                                  AppToast.show(
                                    context,
                                    ok
                                        ? 'Restored'
                                        : 'Could not undo — item may already be restored',
                                  );
                                },
                                child: const Text('Undo'),
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: item.canClear
                          ? IconButton(
                              tooltip: 'Remove',
                              visualDensity: VisualDensity.compact,
                              onPressed: () => context
                                  .read<NotificationsCubit>()
                                  .dismissOne(item.id),
                              icon: const Icon(Symbols.close, size: 16),
                            )
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _formatNotificationTime(DateTime time) {
  final local = time.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  final clock = DateFormat('h:mm a').format(local);

  if (day == today) return 'Today · $clock';
  if (day == today.subtract(const Duration(days: 1))) {
    return 'Yesterday · $clock';
  }
  return DateFormat('d MMM · h:mm a').format(local);
}
