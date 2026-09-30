import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../routes/app_routes.dart';
import '../../../../constants/developer_contact.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_durations.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../themes/theme_cubit.dart';
import '../../../../widgets/app_logo.dart';
import '../../../../widgets/app_toast.dart';

class SidebarItem {
  const SidebarItem({
    required this.label,
    required this.path,
    required this.icon,
    this.permission,
  });

  final String label;
  final String path;
  final IconData icon;
  final String? permission;
}

const List<SidebarItem> kSidebarItems = [
  SidebarItem(
    label: 'Quick Sale',
    path: AppRoutes.pos,
    icon: Symbols.bolt,
    permission: AppPermission.posAccess,
  ),
  SidebarItem(
    label: 'Dashboard',
    path: AppRoutes.dashboard,
    icon: Symbols.dashboard,
    permission: AppPermission.dashboardView,
  ),
  SidebarItem(
    label: 'Products',
    path: AppRoutes.products,
    icon: Symbols.inventory_2,
    permission: AppPermission.productsManage,
  ),

  SidebarItem(
    label: 'Inventory',
    path: AppRoutes.inventory,
    icon: Symbols.warehouse,
    permission: AppPermission.inventoryManage,
  ),
  SidebarItem(
    label: 'Purchases',
    path: AppRoutes.purchases,
    icon: Symbols.assignment,
    permission: AppPermission.purchasesManage,
  ),
  SidebarItem(
    label: 'Labels',
    path: AppRoutes.labels,
    icon: Symbols.barcode,
    permission: AppPermission.labelsPrint,
  ),
  SidebarItem(
    label: 'Sales',
    path: AppRoutes.sales,
    icon: Symbols.receipt_long,
    permission: AppPermission.salesView,
  ),
  SidebarItem(
    label: 'Customers',
    path: AppRoutes.customers,
    icon: Symbols.group,
    permission: AppPermission.customersManage,
  ),

  SidebarItem(
    label: 'Finance',
    path: AppRoutes.finance,
    icon: Symbols.account_balance_wallet,
    permission: AppPermission.accountsView,
  ),
  SidebarItem(
    label: 'Reports',
    path: AppRoutes.reports,
    icon: Symbols.bar_chart,
    permission: AppPermission.reportsView,
  ),

  SidebarItem(
    label: 'Accounts',
    path: AppRoutes.accounts,
    icon: Symbols.account_balance,
    permission: AppPermission.accountsView,
  ),
  SidebarItem(
    label: 'Users',
    path: AppRoutes.users,
    icon: Symbols.manage_accounts,
    permission: AppPermission.usersManage,
  ),
  SidebarItem(
    label: 'Recycle Bin',
    path: AppRoutes.recycleBin,
    icon: Symbols.delete,
    permission: AppPermission.settingsManage,
  ),
  SidebarItem(
    label: 'Settings',
    path: AppRoutes.settings,
    icon: Symbols.settings,
    permission: AppPermission.settingsManage,
  ),
];

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.collapsed,
    required this.currentPath,
    required this.onNavigate,
    required this.permissions,
    this.onToggle,
    this.hidden = false,
  });

  final bool collapsed;
  final bool hidden;
  final String currentPath;
  final ValueChanged<String> onNavigate;
  final List<String> permissions;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    // Rebuild when accent / mode changes so logo + active tile pick new colors.
    return BlocBuilder<ThemeCubit, AppThemeState>(
      buildWhen: (prev, next) =>
          prev.accent != next.accent ||
          prev.primary != next.primary ||
          prev.mode != next.mode,
      builder: (context, themeState) => _buildSidebar(context, themeState),
    );
  }

  Widget _buildSidebar(BuildContext context, AppThemeState themeState) {
    final expandedWidth = collapsed
        ? AppSpacing.sidebarCollapsedWidth
        : AppSpacing.sidebarWidth;
    final items = kSidebarItems
        .where(
          (item) =>
              item.permission == null || permissions.contains(item.permission),
        )
        .toList();

    // AnimatedContainer(width:0) + OverflowBox can busy-loop frames on macOS.
    if (hidden) {
      return const SizedBox.shrink();
    }

    final accent = themeState.accent.accent;
    const logo = AppLogo(size: 36);

    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: Curves.easeInOutCubic,
      width: expandedWidth,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: themeState.primary.color,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                collapsed ? AppSpacing.sm : AppSpacing.md,
                AppSpacing.lg,
                collapsed ? AppSpacing.sm : AppSpacing.md,
                AppSpacing.md,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // During expand/collapse animation the row can be narrower
                  // than the expanded header; fall back to logo-only.
                  final showExpandedHeader = constraints.maxWidth >= 160;
                  if (!showExpandedHeader) {
                    return const Center(child: logo);
                  }
                  return Row(
                    children: [
                      logo,
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(
                        child: Text(
                          'DevClayPOS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      if (onToggle != null)
                        IconButton(
                          onPressed: onToggle,
                          tooltip: 'Collapse',
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          icon: const Icon(
                            Symbols.left_panel_close,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                // Force tiles to refresh when accent changes.
                key: ValueKey('sidebar-items-${themeState.accent.id}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = currentPath == item.path;

                  return _SidebarTile(
                    item: item,
                    collapsed: collapsed,
                    selected: isSelected,
                    accent: accent,
                    onTap: () => onNavigate(item.path),
                  );
                },
              ),
            ),
            if (collapsed && onToggle != null)
              IconButton(
                onPressed: onToggle,
                tooltip: 'Expand',
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(
                  minWidth: AppSpacing.touchTarget,
                  minHeight: AppSpacing.touchTarget,
                ),
                icon: const Icon(
                  Symbols.left_panel_open,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            if (collapsed)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
                child: _SidebarDeveloperContact(collapsed: true),
              ),
            if (!collapsed)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: _SidebarDeveloperContact(collapsed: false),
              ),
          ],
        ),
      ),
    );
  }
}

class _SidebarDeveloperContact extends StatelessWidget {
  const _SidebarDeveloperContact({required this.collapsed});

  final bool collapsed;

  static const _muted = TextStyle(color: Colors.white38, fontSize: 11);
  static const _tooltip =
      'Software by ${DeveloperContact.developerName}\n'
      '${DeveloperContact.mobile}\n'
      '${DeveloperContact.email}';

  Future<void> _copy(BuildContext context, String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      AppToast.show(context, '$label copied');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (collapsed) {
      return Tooltip(
        message: _tooltip,
        child: Icon(
          Symbols.support_agent,
          size: 18,
          color: Colors.white.withValues(alpha: 0.45),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Software by ${DeveloperContact.developerCompany}',
          style: _muted.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 6),
        _SidebarContactRow(
          icon: Symbols.call,
          value: DeveloperContact.mobile,
          copyLabel: 'Phone',
          onCopy: () => _copy(context, DeveloperContact.mobile, 'Phone'),
        ),
        const SizedBox(height: 4),
        _SidebarContactRow(
          icon: Symbols.mail,
          value: DeveloperContact.email,
          copyLabel: 'Email',
          onCopy: () => _copy(context, DeveloperContact.email, 'Email'),
        ),
      ],
    );
  }
}

class _SidebarContactRow extends StatelessWidget {
  const _SidebarContactRow({
    required this.icon,
    required this.value,
    required this.copyLabel,
    required this.onCopy,
  });

  final IconData icon;
  final String value;
  final String copyLabel;
  final VoidCallback onCopy;

  static const _value = TextStyle(color: Colors.white60, fontSize: 11);

  @override
  Widget build(BuildContext context) {
    final iconColor = Colors.white.withValues(alpha: 0.45);
    return Row(
      children: [
        Icon(icon, size: 12, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: _value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: onCopy,
          tooltip: 'Copy $copyLabel',
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          icon: Icon(Symbols.content_copy, size: 14, color: iconColor),
        ),
      ],
    );
  }
}

class _SidebarTile extends StatefulWidget {
  const _SidebarTile({
    required this.item,
    required this.collapsed,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final SidebarItem item;
  final bool collapsed;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final selected = widget.selected;
    final background = selected
        ? widget.accent
        : _hovered
        ? AppColors.sidebarHover
        : Colors.transparent;

    final child = AnimatedContainer(
      duration: AppDurations.fast,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.symmetric(
        horizontal: widget.collapsed ? 0 : AppSpacing.sm,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smAll,
      ),
      child: Row(
        mainAxisAlignment: widget.collapsed
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: 20,
            color: selected || _hovered ? Colors.white : Colors.white70,
          ),
          if (!widget.collapsed) ...[
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    final button = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadii.smAll,
          child: child,
        ),
      ),
    );

    if (!widget.collapsed) return button;
    return Tooltip(message: item.label, child: button);
  }
}
