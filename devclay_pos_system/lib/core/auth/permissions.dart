/// Permission keys used across DevClayPOS modules.
abstract final class AppPermission {
  static const String dashboardView = 'dashboard.view';
  static const String posAccess = 'pos.access';
  static const String productsManage = 'products.manage';
  static const String inventoryManage = 'inventory.manage';
  static const String purchasesManage = 'purchases.manage';
  static const String salesView = 'sales.view';
  static const String customersManage = 'customers.manage';
  static const String suppliersManage = 'suppliers.manage';
  static const String accountsView = 'accounts.view';
  static const String reportsView = 'reports.view';
  static const String usersManage = 'users.manage';
  static const String settingsManage = 'settings.manage';
  static const String labelsPrint = 'labels.print';
  static const String discountsApprove = 'pos.discounts.approve';
  static const String priceOverride = 'pos.price.override';
  static const String returnsProcess = 'sales.returns.process';
  static const String salesVoid = 'sales.void';
  static const String shiftsManage = 'shifts.manage';
  static const String restaurantManage = 'restaurant.manage';
  static const String kitchenView = 'kitchen.view';

  static const List<String> all = [
    dashboardView,
    posAccess,
    productsManage,
    inventoryManage,
    purchasesManage,
    salesView,
    customersManage,
    suppliersManage,
    accountsView,
    reportsView,
    usersManage,
    settingsManage,
    labelsPrint,
    discountsApprove,
    priceOverride,
    returnsProcess,
    salesVoid,
    shiftsManage,
    restaurantManage,
    kitchenView,
  ];

  /// Only the owner should grant or use these (Users, Settings, Recycle Bin).
  static const List<String> adminOnly = [usersManage, settingsManage];

  /// Quick Sale is always available to staff accounts.
  static const List<String> lockedStaffModules = [posAccess];

  /// Modules an owner can enable/disable per staff account.
  static const List<String> staffModules = [
    dashboardView,
    posAccess,
    productsManage,
    inventoryManage,
    purchasesManage,
    salesView,
    customersManage,
    suppliersManage,
    accountsView,
    reportsView,
    labelsPrint,
    discountsApprove,
    priceOverride,
    returnsProcess,
    salesVoid,
    shiftsManage,
    restaurantManage,
    kitchenView,
  ];

  /// Shown as editable checkboxes in the user editor.
  static List<String> get configurableStaffModules => staffModules
      .where((permission) => !lockedStaffModules.contains(permission))
      .toList(growable: false);

  /// Ensures locked modules are always present for staff.
  static List<String> syncStaffPermissions(Iterable<String> permissions) {
    final set = permissions.toSet();
    set.addAll(lockedStaffModules);
    return all.where(set.contains).toList(growable: false);
  }

  static bool isAdminPermission(String permission) =>
      adminOnly.contains(permission);

  static bool isLockedStaffModule(String permission) =>
      lockedStaffModules.contains(permission);

  static List<String> sanitizeForRole(
    String role,
    Iterable<String> permissions,
  ) {
    if (role == AppRoles.owner) return List<String>.from(all);
    final set = permissions.toSet()..add(posAccess);
    if (role == AppRoles.cashier) {
      set
        ..remove(productsManage)
        ..remove(inventoryManage)
        ..remove(purchasesManage)
        ..remove(accountsView)
        ..remove(reportsView)
        ..remove(usersManage)
        ..remove(settingsManage)
        ..remove(discountsApprove)
        ..remove(priceOverride)
        ..remove(returnsProcess)
        ..remove(salesVoid)
        ..remove(shiftsManage);
    }
    return all.where(set.contains).toList(growable: false);
  }
}

/// Built-in role templates with default permission sets.
abstract final class AppRoles {
  static const String owner = 'owner';
  static const String manager = 'manager';
  static const String cashier = 'cashier';

  static bool isOwner(String role) => role == owner;

  static List<String> permissionsFor(String role) {
    return switch (role) {
      owner => List<String>.from(AppPermission.all),
      manager => [
        AppPermission.dashboardView,
        AppPermission.posAccess,
        AppPermission.productsManage,
        AppPermission.inventoryManage,
        AppPermission.purchasesManage,
        AppPermission.salesView,
        AppPermission.customersManage,
        AppPermission.suppliersManage,
        AppPermission.accountsView,
        AppPermission.reportsView,
        AppPermission.labelsPrint,
        AppPermission.settingsManage,
        AppPermission.discountsApprove,
        AppPermission.priceOverride,
        AppPermission.returnsProcess,
        AppPermission.salesVoid,
        AppPermission.shiftsManage,
        AppPermission.restaurantManage,
        AppPermission.kitchenView,
      ],
      cashier => [
        AppPermission.dashboardView,
        AppPermission.posAccess,
        AppPermission.salesView,
        AppPermission.customersManage,
        AppPermission.kitchenView,
      ],
      _ => const [],
    };
  }
}
