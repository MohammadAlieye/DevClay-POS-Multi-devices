import 'package:equatable/equatable.dart';

import '../../../../core/auth/permissions.dart';

class StaffUserItem extends Equatable {
  const StaffUserItem({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.permissions,
    required this.isActive,
    required this.createdAt,
  });

  final int id;
  final String username;
  final String displayName;
  final String role;
  final List<String> permissions;
  final bool isActive;
  final DateTime createdAt;

  String get roleLabel => UserRoleLabels.labelFor(role);

  int get permissionCount => permissions.length;

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    role,
    permissions,
    isActive,
    createdAt,
  ];
}

class StaffUserDraft extends Equatable {
  const StaffUserDraft({
    required this.username,
    required this.displayName,
    required this.role,
    required this.permissions,
    this.password,
    this.isActive = true,
  });

  final String username;
  final String displayName;
  final String role;
  final List<String> permissions;
  final String? password;
  final bool isActive;

  @override
  List<Object?> get props => [
    username,
    displayName,
    role,
    permissions,
    password,
    isActive,
  ];
}

/// Who is performing a staff save — used to enforce owner-only rules.
class StaffUserSaveContext {
  const StaffUserSaveContext({
    required this.editorUserId,
    required this.editorRole,
  });

  final int editorUserId;
  final String editorRole;

  bool get editorIsOwner => AppRoles.isOwner(editorRole);
}

abstract final class UserRoleLabels {
  static const List<String> assignableRoles = [
    AppRoles.owner,
    AppRoles.manager,
    AppRoles.cashier,
  ];

  static List<String> rolesForEditor(String editorRole) {
    if (AppRoles.isOwner(editorRole)) {
      return assignableRoles;
    }
    return const [AppRoles.manager, AppRoles.cashier];
  }

  static String labelFor(String role) {
    return switch (role) {
      AppRoles.owner => 'Owner',
      AppRoles.manager => 'Manager',
      AppRoles.cashier => 'Cashier',
      _ => role,
    };
  }

  static String permissionLabel(String permission) {
    return switch (permission) {
      AppPermission.dashboardView => 'Dashboard',
      AppPermission.posAccess => 'Quick Sale',
      AppPermission.productsManage => 'Products',
      AppPermission.inventoryManage => 'Inventory',
      AppPermission.purchasesManage => 'Purchases',
      AppPermission.salesView => 'Sales',
      AppPermission.customersManage => 'Customers',
      AppPermission.suppliersManage => 'Suppliers',
      AppPermission.accountsView => 'Accounts',
      AppPermission.reportsView => 'Reports',
      AppPermission.labelsPrint => 'Labels',
      AppPermission.usersManage => 'Users',
      AppPermission.settingsManage => 'Settings',
      _ => permission,
    };
  }
}
