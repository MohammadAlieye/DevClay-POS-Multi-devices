import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/auth/permissions.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_search_field.dart';
import '../../domain/entities/user_entities.dart';
import '../../../../widgets/app_toast.dart';

Future<StaffUserDraft?> showUserEditorSheet({
  required BuildContext context,
  StaffUserItem? existing,
  bool isSelf = false,
  required String editorRole,
}) {
  return showDialog<StaffUserDraft>(
    context: context,
    builder: (context) => _UserEditorDialog(
      existing: existing,
      isSelf: isSelf,
      editorRole: editorRole,
    ),
  );
}

class _UserEditorDialog extends StatefulWidget {
  const _UserEditorDialog({
    this.existing,
    this.isSelf = false,
    required this.editorRole,
  });

  final StaffUserItem? existing;
  final bool isSelf;
  final String editorRole;

  @override
  State<_UserEditorDialog> createState() => _UserEditorDialogState();
}

class _UserEditorDialogState extends State<_UserEditorDialog> {
  late final TextEditingController _username;
  late final TextEditingController _displayName;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  late String _role;
  late bool _isActive;
  late Set<String> _permissions;
  String? _usernameError;
  String? _displayNameError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool get _editorIsOwner => AppRoles.isOwner(widget.editorRole);
  bool get _targetIsOwner => AppRoles.isOwner(_role);
  bool get _lockModuleToggles =>
      _targetIsOwner || (widget.isSelf && _editorIsOwner);

  @override
  void initState() {
    super.initState();
    final user = widget.existing;
    _username = TextEditingController(text: user?.username ?? '');
    _displayName = TextEditingController(text: user?.displayName ?? '');
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    _role = user?.role ?? AppRoles.cashier;
    _isActive = user?.isActive ?? true;
    _permissions = {
      ...(user?.permissions.isNotEmpty == true
          ? user!.permissions
          : AppRoles.permissionsFor(_role)),
    };
    if (_targetIsOwner) {
      _permissions = {...AppPermission.all};
    } else {
      _permissions = AppPermission.syncStaffPermissions(_permissions).toSet();
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _displayName.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _applyRoleDefaults(String role) {
    setState(() {
      _role = role;
      if (AppRoles.isOwner(role)) {
        _permissions = {...AppPermission.all};
      } else {
        _permissions = AppPermission.syncStaffPermissions(
          AppRoles.permissionsFor(role),
        ).toSet();
        if (!_editorIsOwner) {
          _permissions.removeWhere(AppPermission.isAdminPermission);
        }
      }
    });
  }

  void _togglePermission(String permission, bool enabled) {
    if (_lockModuleToggles) return;
    if (AppPermission.isLockedStaffModule(permission)) return;
    if (widget.isSelf && permission == AppPermission.usersManage && !enabled) {
      _showError('You cannot remove your own Users access.');
      return;
    }
    if (!_editorIsOwner && AppPermission.isAdminPermission(permission)) {
      _showError('Only the owner can grant admin module access.');
      return;
    }
    setState(() {
      if (enabled) {
        _permissions.add(permission);
      } else {
        _permissions.remove(permission);
      }
      if (!AppRoles.isOwner(_role)) {
        _permissions = AppPermission.syncStaffPermissions(_permissions).toSet();
      }
    });
  }

  void _submit() {
    final password = _password.text.trim();
    final confirm = _confirmPassword.text.trim();
    final isEdit = widget.existing != null;
    final username = _username.text.trim().toLowerCase();
    final displayName = _displayName.text.trim();

    setState(() {
      _usernameError = !isEdit && username.length < 3
          ? 'Username must be at least 3 characters'
          : null;
      _displayNameError = displayName.isEmpty
          ? 'Enter the staff display name'
          : null;
      _passwordError = !isEdit && password.isEmpty
          ? 'Enter a password'
          : password.isNotEmpty && password.length < 6
          ? 'Password must be at least 6 characters'
          : null;
      _confirmPasswordError = password.isNotEmpty && password != confirm
          ? 'Passwords do not match'
          : null;
    });
    if (_usernameError != null ||
        _displayNameError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    final permissions = _lockModuleToggles
        ? List<String>.from(AppPermission.all)
        : AppPermission.sanitizeForRole(_role, _permissions);

    if (permissions.isEmpty) {
      _showError('Select at least one module.');
      return;
    }

    Navigator.of(context).pop(
      StaffUserDraft(
        username: username,
        displayName: displayName,
        role: _role,
        permissions: permissions,
        password: password.isEmpty ? null : password,
        isActive: _isActive,
      ),
    );
  }

  void _showError(String message) {
    AppToast.show(context, message);
  }

  Widget _permissionTile(String permission, {required bool locked}) {
    final checked = locked || _permissions.contains(permission);
    final lockUsersSelf =
        widget.isSelf && permission == AppPermission.usersManage && checked;
    final isLocked = locked || _lockModuleToggles || lockUsersSelf;

    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: checked,
      title: Text(UserRoleLabels.permissionLabel(permission)),
      onChanged: isLocked
          ? null
          : (value) => _togglePermission(permission, value ?? false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final theme = Theme.of(context);
    final roleOptions = UserRoleLabels.rolesForEditor(widget.editorRole);

    return AlertDialog(
      title: Text(isEdit ? 'Edit staff account' : 'Add staff account'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isEdit)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Username', style: theme.textTheme.titleSmall),
                  subtitle: Text('@${_username.text}'),
                )
              else
                AppTextField(
                  controller: _username,
                  label: 'Username *',
                  hintText: 'login name',
                  errorText: _usernameError,
                  onChanged: (_) {
                    if (_usernameError != null) {
                      setState(() => _usernameError = null);
                    }
                  },
                ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _displayName,
                label: 'Display name *',
                hintText: 'Shown in POS and receipts',
                errorText: _displayNameError,
                onChanged: (_) {
                  if (_displayNameError != null) {
                    setState(() => _displayNameError = null);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: const OutlineInputBorder(),
                  helperText: _editorIsOwner
                      ? 'Owner gets full access automatically'
                      : 'Manager or Cashier — customize modules below',
                ),
                items: roleOptions
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(UserRoleLabels.labelFor(role)),
                      ),
                    )
                    .toList(),
                onChanged: widget.isSelf
                    ? null
                    : (value) {
                        if (value != null) _applyRoleDefaults(value);
                      },
              ),
              const SizedBox(height: AppSpacing.md),
              if (_lockModuleToggles) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Symbols.verified_user,
                        size: 20,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full access',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.isSelf
                                  ? 'Your owner account always has every module. '
                                        'No need to toggle permissions for yourself.'
                                  : 'Owner accounts always have every module.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text('Staff modules', style: theme.textTheme.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Quick Sale, Products, and Inventory are always on. '
                  'Choose other modules below.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                ...AppPermission.lockedStaffModules.map(
                  (permission) => _permissionTile(permission, locked: true),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...AppPermission.configurableStaffModules.map(
                  (permission) => _permissionTile(permission, locked: false),
                ),
                if (_editorIsOwner) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text('Admin modules', style: theme.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Users and Settings — only grant to trusted managers.',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...AppPermission.adminOnly.map(
                    (permission) => _permissionTile(permission, locked: false),
                  ),
                ],
              ],
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _password,
                label: isEdit ? 'New password (optional)' : 'Password',
                hintText: 'Minimum 6 characters',
                obscureText: true,
                errorText: _passwordError,
                onChanged: (_) {
                  if (_passwordError != null || _confirmPasswordError != null) {
                    setState(() {
                      _passwordError = null;
                      _confirmPasswordError = null;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _confirmPassword,
                label: 'Confirm password',
                obscureText: true,
                errorText: _confirmPasswordError,
                onChanged: (_) {
                  if (_confirmPasswordError != null) {
                    setState(() => _confirmPasswordError = null);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active account'),
                subtitle: widget.isSelf
                    ? const Text('You cannot deactivate your own account')
                    : const Text('Inactive users cannot sign in'),
                value: _isActive,
                onChanged: widget.isSelf
                    ? null
                    : (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: isEdit ? 'Save changes' : 'Create account',
          icon: isEdit ? Symbols.save : Symbols.person_add,
          onPressed: _submit,
        ),
      ],
    );
  }
}

Future<String?> showUserPasswordSheet({
  required BuildContext context,
  required String username,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _UserPasswordDialog(username: username),
  );
}

class _UserPasswordDialog extends StatefulWidget {
  const _UserPasswordDialog({required this.username});

  final String username;

  @override
  State<_UserPasswordDialog> createState() => _UserPasswordDialogState();
}

class _UserPasswordDialogState extends State<_UserPasswordDialog> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _password.text.trim();
    final confirm = _confirm.text.trim();
    setState(() {
      _passwordError = password.length < 6
          ? 'Password must be at least 6 characters'
          : null;
      _confirmError = password != confirm ? 'Passwords do not match' : null;
    });
    if (_passwordError != null || _confirmError != null) {
      return;
    }
    Navigator.of(context).pop(password);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset password'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set a new password for @${widget.username}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _password,
              label: 'New password',
              obscureText: true,
              errorText: _passwordError,
              onChanged: (_) {
                if (_passwordError != null || _confirmError != null) {
                  setState(() {
                    _passwordError = null;
                    _confirmError = null;
                  });
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _confirm,
              label: 'Confirm password',
              obscureText: true,
              errorText: _confirmError,
              onChanged: (_) {
                if (_confirmError != null) {
                  setState(() => _confirmError = null);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Update password',
          icon: Symbols.lock_reset,
          onPressed: _submit,
        ),
      ],
    );
  }
}
