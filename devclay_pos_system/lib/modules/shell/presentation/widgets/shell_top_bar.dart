import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../constants/developer_contact.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/client/lan_connection_monitor.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_durations.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../themes/theme_cubit.dart';
import '../../../../widgets/app_button.dart';

class ShellTopBar extends StatelessWidget {
  const ShellTopBar({
    super.key,
    required this.title,
    required this.storeName,
    required this.userName,
    required this.userRole,
    this.showGlobalSearch = true,
    this.showBrandMenu = false,
    this.brandMenuOpen = false,
    this.onBrandMenuPressed,
    this.notificationCount = 0,
    required this.onNotificationsPressed,
    required this.notificationsOpen,
    required this.onLogout,
    this.onSwitchStore,
    this.showSwitchStore = false,
  });

  final String title;
  final String storeName;
  final String userName;
  final String userRole;
  final bool showGlobalSearch;
  final bool showBrandMenu;
  final bool brandMenuOpen;
  final VoidCallback? onBrandMenuPressed;
  final int notificationCount;
  final VoidCallback onNotificationsPressed;
  final bool notificationsOpen;
  final VoidCallback onLogout;
  final VoidCallback? onSwitchStore;
  final bool showSwitchStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: AppSpacing.topBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkShellHeaderGradient
            : AppColors.shellHeaderGradient,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
          ),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use the bar's own width (after sidebar), not full window width.
          final w = constraints.maxWidth;
          final showBrandLabel = showBrandMenu && w >= 520;
          final showStatusFull = w >= 720;
          final showStatusCompact = w >= 560 && !showStatusFull;
          final showStoreChip = w >= 420;
          final showStoreName = w >= 560;
          final showUserName = w >= 640;

          return Row(
            children: [
              if (showBrandMenu && onBrandMenuPressed != null) ...[
                showBrandLabel
                    ? AppButton(
                        label: 'DevClayPOS',
                        icon: brandMenuOpen ? Symbols.menu_open : Symbols.menu,
                        variant: AppButtonVariant.secondary,
                        onPressed: onBrandMenuPressed,
                      )
                    : AppIconButton(
                        icon: brandMenuOpen ? Symbols.menu_open : Symbols.menu,
                        tooltip: 'Menu',
                        selected: brandMenuOpen,
                        onPressed: onBrandMenuPressed!,
                      ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Flexible(
                flex: 2,
                child: AnimatedSwitcher(
                  duration: AppDurations.fast,
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Align(
                    key: ValueKey(title),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
              ),
              if (showStatusFull) ...[
                const SizedBox(width: AppSpacing.sm),
                const _OfflineStatusBanner(mode: _StatusMode.full),
              ] else if (showStatusCompact) ...[
                const SizedBox(width: AppSpacing.sm),
                const _OfflineStatusBanner(mode: _StatusMode.compact),
              ],
              const Spacer(),
              if (!showStatusFull && !showStatusCompact)
                const Padding(
                  padding: EdgeInsets.only(right: AppSpacing.xs),
                  child: _OfflineStatusBanner(mode: _StatusMode.icon),
                ),
              if (showStoreChip) ...[
                _StoreChip(storeName: storeName, showName: showStoreName),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (sl<LanModeService>().isClient) ...[
                const _LanHostStatusChip(),
                const SizedBox(width: AppSpacing.sm),
              ],
              BlocBuilder<ThemeCubit, AppThemeState>(
                buildWhen: (previous, current) => previous.mode != current.mode,
                builder: (context, themeState) {
                  final dark =
                      themeState.mode == ThemeMode.dark ||
                      (themeState.mode == ThemeMode.system &&
                          MediaQuery.platformBrightnessOf(context) ==
                              Brightness.dark);
                  return AppIconButton(
                    icon: dark ? Symbols.light_mode : Symbols.dark_mode,
                    tooltip: dark ? 'Light mode' : 'Dark mode',
                    onPressed: () => context.read<ThemeCubit>().toggle(),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.xs),
              Badge(
                isLabelVisible: notificationCount > 0,
                label: Text(
                  notificationCount > 9 ? '9+' : '$notificationCount',
                  style: const TextStyle(fontSize: 10),
                ),
                child: AppIconButton(
                  icon: notificationsOpen
                      ? Symbols.notifications_active
                      : Symbols.notifications,
                  tooltip: 'Notifications',
                  selected: notificationsOpen,
                  onPressed: onNotificationsPressed,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              PopupMenuButton<String>(
                tooltip: 'Account',
                offset: const Offset(0, 48),
                onSelected: (value) {
                  if (value == 'logout') onLogout();
                  if (value == 'switch') onSwitchStore?.call();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, style: theme.textTheme.titleSmall),
                        Text(userRole, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  if (showSwitchStore)
                    const PopupMenuItem(
                      value: 'switch',
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Symbols.store, size: 18),
                        title: Text('Switch store'),
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Symbols.logout, size: 18),
                      title: Text('Sign out'),
                    ),
                  ),
                ],
                child: _AccountChip(userName: userName, showName: showUserName),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _StatusMode { full, compact, icon }

class _LanHostStatusChip extends StatelessWidget {
  const _LanHostStatusChip();

  @override
  Widget build(BuildContext context) {
    final monitor = sl<LanConnectionMonitor>();
    return AnimatedBuilder(
      animation: monitor,
      builder: (context, _) {
        final online = monitor.online;
        final theme = Theme.of(context);
        return Tooltip(
          message: monitor.status ?? (online ? 'Host online' : 'Host offline'),
          child: InkWell(
            onTap: () => monitor.refresh(),
            borderRadius: AppRadii.xsAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: AppRadii.xsAll,
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: online ? AppColors.success : AppColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    online ? 'Host online' : 'Host offline',
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OfflineStatusBanner extends StatelessWidget {
  const _OfflineStatusBanner({required this.mode});

  final _StatusMode mode;

  static const _tooltip = 'Offline · Ready\n${DeveloperContact.mobile}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    if (mode == _StatusMode.icon) {
      return Tooltip(
        message: _tooltip,
        child: Icon(
          Symbols.call,
          size: 18,
          color: AppColors.accent.withValues(alpha: 0.85),
        ),
      );
    }

    return Tooltip(
      message: _tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.75),
          borderRadius: AppRadii.xsAll,
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Software by ${DeveloperContact.developerCompany} : ${DeveloperContact.mobile}',
              style: theme.textTheme.labelMedium?.copyWith(color: muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreChip extends StatelessWidget {
  const _StoreChip({required this.storeName, required this.showName});

  final String storeName;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: showName ? 10 : 8, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: AppRadii.xsAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.location_on, size: 14),
          if (showName) ...[
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  const _AccountChip({required this.userName, required this.showName});

  final String userName;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: showName ? 10 : 6, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.85),
        borderRadius: AppRadii.smAll,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.accent.withValues(alpha: 0.15),
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : '?',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showName) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Symbols.expand_more, size: 18),
          ],
        ],
      ),
    );
  }
}
