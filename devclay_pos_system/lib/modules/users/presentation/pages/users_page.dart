import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../core/di/injection.dart';
import '../../../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/section_header.dart';
import '../../domain/entities/user_entities.dart';
import '../bloc/users_bloc.dart';
import '../widgets/user_editor_sheet.dart';
import '../../../../widgets/app_toast.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.read<AuthBloc>().state.sessionOrNull;
    final currentUserId = session?.user.id ?? 0;
    final currentUserRole = session?.user.role ?? AppRoles.cashier;

    return BlocProvider(
      create: (_) =>
          sl<UsersBloc>(param1: currentUserId, param2: currentUserRole)
            ..add(const UsersStarted()),
      child: const _UsersView(),
    );
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView();

  Future<void> _openEditor(
    BuildContext context, {
    StaffUserItem? existing,
    required int currentUserId,
    required String editorRole,
  }) async {
    final draft = await showUserEditorSheet(
      context: context,
      existing: existing,
      isSelf: existing?.id == currentUserId,
      editorRole: editorRole,
    );
    if (draft == null || !context.mounted) return;
    context.read<UsersBloc>().add(UserSaved(draft: draft, id: existing?.id));
  }

  Future<void> _openPasswordReset(
    BuildContext context,
    StaffUserItem user,
  ) async {
    final password = await showUserPasswordSheet(
      context: context,
      username: user.username,
    );
    if (password == null || !context.mounted) return;
    context.read<UsersBloc>().add(
      UserPasswordReset(userId: user.id, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listenWhen: (prev, curr) => curr is UsersLoaded && curr.message != null,
      listener: (context, state) {
        if (state is UsersLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          if (state.message == 'Staff updated') {
            context.read<AuthBloc>().add(const AuthSessionRefreshed());
          }
          context.read<UsersBloc>().add(const UsersMessageDismissed());
        }
      },
      builder: (context, state) {
        if (state is UsersInitial || state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UsersError) {
          return EmptyState(
            title: 'Users unavailable',
            message: state.message,
            icon: Symbols.manage_accounts,
            action: AppButton(
              label: 'Retry',
              onPressed: () =>
                  context.read<UsersBloc>().add(const UsersStarted()),
            ),
          );
        }
        if (state is UsersLoaded) {
          final editorRole =
              context.read<AuthBloc>().state.sessionOrNull?.user.role ??
              AppRoles.cashier;
          return _UsersLoadedView(
            state: state,
            onAdd: () => _openEditor(
              context,
              currentUserId: state.currentUserId,
              editorRole: editorRole,
            ),
            onEdit: (user) {
              if (!AppRoles.isOwner(editorRole) &&
                  AppRoles.isOwner(user.role)) {
                AppToast.show(
                  context,
                  'Only the owner can edit owner accounts.',
                );
                return;
              }
              _openEditor(
                context,
                existing: user,
                currentUserId: state.currentUserId,
                editorRole: editorRole,
              );
            },
            onResetPassword: (user) => _openPasswordReset(context, user),
            onDelete: (user) async {
              if (user.id == state.currentUserId) {
                AppToast.show(context, 'You cannot delete your own account');
                return;
              }
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Move to Recycle Bin?'),
                  content: Text(
                    'Move "${user.displayName}" (@${user.username}) to the '
                    'Recycle Bin?\nYou can restore the account later.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Move to Recycle Bin'),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                context.read<UsersBloc>().add(UserDeleted(user.id));
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _UsersLoadedView extends StatelessWidget {
  const _UsersLoadedView({
    required this.state,
    required this.onAdd,
    required this.onEdit,
    required this.onResetPassword,
    required this.onDelete,
  });

  final UsersLoaded state;
  final VoidCallback onAdd;
  final ValueChanged<StaffUserItem> onEdit;
  final ValueChanged<StaffUserItem> onResetPassword;
  final ValueChanged<StaffUserItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppSearchField(
                  width: double.infinity,
                  hintText: 'Search username or name…',
                  onChanged: (value) =>
                      context.read<UsersBloc>().add(UsersSearchChanged(value)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Add staff',
                icon: Symbols.person_add,
                onPressed: onAdd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SummaryChip(
                label: 'Total staff',
                value: '${state.users.length}',
                icon: Symbols.group,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Active',
                value: '${state.activeCount}',
                icon: Symbols.check_circle,
              ),
              const SizedBox(width: AppSpacing.sm),
              _SummaryChip(
                label: 'Inactive',
                value: '${state.inactiveCount}',
                icon: Symbols.block,
                highlight: state.inactiveCount > 0,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<UsersTab>(
            segments: const [
              ButtonSegment(
                value: UsersTab.all,
                label: Text('All'),
                icon: Icon(Symbols.group, size: 18),
              ),
              ButtonSegment(
                value: UsersTab.active,
                label: Text('Active'),
                icon: Icon(Symbols.check_circle, size: 18),
              ),
              ButtonSegment(
                value: UsersTab.inactive,
                label: Text('Inactive'),
                icon: Icon(Symbols.block, size: 18),
              ),
            ],
            selected: {state.tab},
            onSelectionChanged: (value) {
              context.read<UsersBloc>().add(UsersTabChanged(value.first));
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _UsersList(
                    users: state.visibleUsers,
                    selectedUserId: state.selectedUserId,
                    currentUserId: state.currentUserId,
                    onSelect: (user) =>
                        context.read<UsersBloc>().add(UserSelected(user.id)),
                    onEdit: onEdit,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: _UserDetailPanel(
                    user: state.selectedUser,
                    isSelf: state.selectedUser?.id == state.currentUserId,
                    onEdit: onEdit,
                    onResetPassword: onResetPassword,
                    onDelete: onDelete,
                    onToggleActive: (user, isActive) {
                      context.read<UsersBloc>().add(
                        UserActiveToggled(userId: user.id, isActive: isActive),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({
    required this.users,
    required this.selectedUserId,
    required this.currentUserId,
    required this.onSelect,
    required this.onEdit,
  });

  final List<StaffUserItem> users;
  final int? selectedUserId;
  final int currentUserId;
  final ValueChanged<StaffUserItem> onSelect;
  final ValueChanged<StaffUserItem> onEdit;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const EmptyState(
        title: 'No staff accounts',
        message: 'Add team members and assign roles to control access.',
        icon: Symbols.manage_accounts,
      );
    }

    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final user = users[index];
        final selected = user.id == selectedUserId;
        final isSelf = user.id == currentUserId;

        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          onTap: () => onSelect(user),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: selected
                    ? AppColors.accent.withValues(alpha: 0.18)
                    : Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12),
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected
                        ? AppColors.accent
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        if (isSelf)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'You',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.accent),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      '@${user.username}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: 4,
                      children: [
                        _RoleChip(label: user.roleLabel),
                        if (!user.isActive)
                          const _RoleChip(label: 'Inactive', muted: true),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit',
                onPressed: () => onEdit(user),
                icon: const Icon(Symbols.edit, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserDetailPanel extends StatelessWidget {
  const _UserDetailPanel({
    required this.user,
    required this.isSelf,
    required this.onEdit,
    required this.onResetPassword,
    required this.onDelete,
    required this.onToggleActive,
  });

  final StaffUserItem? user;
  final bool isSelf;
  final ValueChanged<StaffUserItem> onEdit;
  final ValueChanged<StaffUserItem> onResetPassword;
  final ValueChanged<StaffUserItem> onDelete;
  final void Function(StaffUserItem user, bool isActive) onToggleActive;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const EmptyState(
        title: 'Select a staff member',
        message: 'View role permissions and account actions here.',
        icon: Symbols.badge,
      );
    }

    final dateFormat = DateFormat('d MMM yyyy');

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '@${user!.username} · ${user!.roleLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: user!.isActive,
                onChanged: isSelf
                    ? null
                    : (value) => onToggleActive(user!, value),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Joined ${dateFormat.format(user!.createdAt)} · '
            '${user!.permissionCount} permissions',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: 'Module access',
            subtitle: AppRoles.isOwner(user!.role)
                ? 'Owner — full access to all modules'
                : 'Enabled modules for this account',
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView(
              children: [
                if (!AppRoles.isOwner(user!.role)) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      'Staff modules',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...AppPermission.lockedStaffModules.map(
                    (permission) => _PermissionRow(
                      permission: permission,
                      allowed: true,
                      locked: true,
                    ),
                  ),
                  ...AppPermission.configurableStaffModules.map(
                    (permission) => _PermissionRow(
                      permission: permission,
                      allowed: user!.permissions.contains(permission),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      'Admin modules',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...AppPermission.adminOnly.map(
                    (permission) => _PermissionRow(
                      permission: permission,
                      allowed: user!.permissions.contains(permission),
                    ),
                  ),
                ] else
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Symbols.verified_user,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    title: const Text('All modules enabled'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Edit account',
                  icon: Symbols.edit,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => onEdit(user!),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Reset password',
                  icon: Symbols.lock_reset,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => onResetPassword(user!),
                ),
              ),
            ],
          ),
          if (!isSelf) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Move to Recycle Bin',
              icon: Symbols.delete,
              variant: AppButtonVariant.danger,
              onPressed: () => onDelete(user!),
            ),
          ],
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.permission,
    required this.allowed,
    this.locked = false,
  });

  final String permission;
  final bool allowed;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final enabled = locked || allowed;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        enabled ? Symbols.check_circle : Symbols.block,
        size: 18,
        color: enabled
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).disabledColor,
      ),
      title: Text(
        UserRoleLabels.permissionLabel(permission),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: enabled ? null : Theme.of(context).disabledColor,
        ),
      ),
      trailing: locked
          ? Text(
              'Always on',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: highlight
                ? AppColors.warning
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.label, this.muted = false});

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: muted
            ? Theme.of(context).disabledColor.withValues(alpha: 0.12)
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: muted
              ? Theme.of(context).disabledColor
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
