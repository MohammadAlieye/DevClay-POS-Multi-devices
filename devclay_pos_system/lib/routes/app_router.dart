import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/go_router_refresh_stream.dart';
import '../core/auth/permissions.dart';
import '../core/di/injection.dart';
import '../core/store_profile/store_profile_service.dart';
import '../modules/auth/domain/entities/auth_entities.dart';
import '../modules/auth/presentation/bloc/auth_bloc.dart';
import '../modules/auth/presentation/pages/login_page.dart';
import '../modules/auth/presentation/pages/store_selection_page.dart';
import '../modules/license/presentation/bloc/license_bloc.dart';
import '../modules/license/presentation/pages/license_gate_page.dart';
import '../modules/dashboard/presentation/pages/dashboard_page.dart';
import '../modules/labels/presentation/pages/labels_page.dart';
import '../modules/settings/presentation/pages/settings_page.dart';
import '../modules/users/presentation/pages/users_page.dart';
import '../modules/reports/presentation/pages/reports_page.dart';
import '../modules/accounts/presentation/pages/accounts_page.dart';
import '../modules/finance/presentation/pages/finance_page.dart';
import '../modules/customers/presentation/pages/customers_page.dart';
import '../modules/sales/presentation/pages/sales_page.dart';
import '../modules/purchases/presentation/pages/purchases_page.dart';
import '../modules/inventory/presentation/pages/inventory_page.dart';
import '../modules/pos/presentation/pages/pos_page.dart';
import '../modules/products/presentation/pages/products_page.dart';
import '../modules/recycle_bin/presentation/pages/recycle_bin_page.dart';
import '../modules/setup/presentation/pages/store_profile_setup_page.dart';
import '../modules/shell/presentation/app_shell.dart';
import '../themes/app_durations.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

GoRouter createAppRouter() {
  final authBloc = sl<AuthBloc>();
  final licenseBloc = sl<LicenseBloc>();
  final storeProfile = sl<StoreProfileService>();

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.license,
    refreshListenable: GoRouterRefreshStream(
      [authBloc.stream, licenseBloc.stream],
      listenables: [storeProfile],
    ),
    redirect: (context, state) {
      final licenseState = licenseBloc.state;
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final onLicense = location == AppRoutes.license;
      final onLogin = location == AppRoutes.login;
      final onStoreSelect = location == AppRoutes.selectStore;
      final onSetupProfile = location == AppRoutes.setupStoreProfile;

      // Always return null when already on the target — returning the same
      // path with refreshListenable causes an infinite redirect/frame loop.

      if (licenseState is LicenseInitial ||
          licenseState is LicenseChecking ||
          licenseState is LicenseBlocked ||
          licenseState is LicenseActivating ||
          licenseState is LicenseActivationFailure ||
          licenseState is! LicenseAllowed) {
        return onLicense ? null : AppRoutes.license;
      }

      if (onLicense) {
        return AppRoutes.login;
      }

      if (authState is AuthInitial || authState is AuthLoading) {
        return onLogin ? null : AppRoutes.login;
      }

      if (authState is AuthUnauthenticated ||
          authState is AuthFailureState ||
          authState is AuthAuthenticating) {
        return onLogin ? null : AppRoutes.login;
      }

      if (authState is AuthNeedsStore || authState is AuthSelectingStore) {
        return onStoreSelect ? null : AppRoutes.selectStore;
      }

      if (authState is AuthAuthenticated) {
        final canConfigureProfile =
            AppRoles.isOwner(authState.session.user.role) ||
                authState.session.user.role == AppRoles.manager ||
                authState.session.user.hasPermission(
                  AppPermission.settingsManage,
                );
        final profileReady = storeProfile.isConfiguredCached;

        if (!profileReady && canConfigureProfile) {
          return onSetupProfile ? null : AppRoutes.setupStoreProfile;
        }

        if (onSetupProfile) {
          return profileReady
              ? _homeRouteFor(authState.session.user)
              : (canConfigureProfile ? null : _homeRouteFor(authState.session.user));
        }

        if (onLogin || onStoreSelect) {
          if (!profileReady && canConfigureProfile) {
            return AppRoutes.setupStoreProfile;
          }
          return _homeRouteFor(authState.session.user);
        }

        final required = _permissionForRoute(location);
        if (required != null &&
            !authState.session.user.hasPermission(required) &&
            location != _homeRouteFor(authState.session.user)) {
          return _homeRouteFor(authState.session.user);
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.license,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const LicenseGatePage()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _fadeSlide(state, const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.selectStore,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const StoreSelectionPage()),
      ),
      GoRoute(
        path: AppRoutes.setupStoreProfile,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const StoreProfileSetupPage()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const DashboardPage()),
          ),
          GoRoute(
            path: AppRoutes.pos,
            pageBuilder: (context, state) => _fadeSlide(state, const PosPage()),
          ),
          GoRoute(
            path: AppRoutes.products,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const ProductsPage()),
          ),
          GoRoute(
            path: AppRoutes.inventory,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const InventoryPage()),
          ),
          GoRoute(
            path: AppRoutes.purchases,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const PurchasesPage()),
          ),
          GoRoute(
            path: AppRoutes.sales,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const SalesPage()),
          ),
          GoRoute(
            path: AppRoutes.customers,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const CustomersPage()),
          ),
          GoRoute(
            path: AppRoutes.accounts,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const AccountsPage()),
          ),
          GoRoute(
            path: AppRoutes.finance,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const FinancePage()),
          ),
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const ReportsPage()),
            routes: [
              GoRoute(
                path: ':reportId',
                pageBuilder: (context, state) =>
                    _fadeSlide(state, const ReportsPage()),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.users,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const UsersPage()),
          ),
          GoRoute(
            path: AppRoutes.labels,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const LabelsPage()),
          ),
          GoRoute(
            path: AppRoutes.recycleBin,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const RecycleBinPage()),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) =>
                _fadeSlide(state, const SettingsPage()),
          ),
        ],
      ),
    ],
  );
}

String? _permissionForRoute(String location) {
  if (location.startsWith('${AppRoutes.reports}/')) {
    return AppPermission.reportsView;
  }
  return switch (location) {
    AppRoutes.dashboard => AppPermission.dashboardView,
    AppRoutes.pos => AppPermission.posAccess,
    AppRoutes.products => AppPermission.productsManage,
    AppRoutes.inventory => AppPermission.inventoryManage,
    AppRoutes.purchases => AppPermission.purchasesManage,
    AppRoutes.sales => AppPermission.salesView,
    AppRoutes.customers => AppPermission.customersManage,
    AppRoutes.accounts => AppPermission.accountsView,
    AppRoutes.finance => AppPermission.accountsView,
    AppRoutes.reports => AppPermission.reportsView,
    AppRoutes.labels => AppPermission.labelsPrint,
    AppRoutes.users => AppPermission.usersManage,
    AppRoutes.settings => AppPermission.settingsManage,
    AppRoutes.recycleBin => AppPermission.settingsManage,
    _ => null,
  };
}

/// Default landing page after login — first module the user can access.
String _homeRouteFor(AuthUser user) {
  const candidates = <String, String>{
    AppRoutes.pos: AppPermission.posAccess,
    AppRoutes.dashboard: AppPermission.dashboardView,
    AppRoutes.sales: AppPermission.salesView,
    AppRoutes.customers: AppPermission.customersManage,
    AppRoutes.products: AppPermission.productsManage,
    AppRoutes.inventory: AppPermission.inventoryManage,
    AppRoutes.purchases: AppPermission.purchasesManage,
    AppRoutes.finance: AppPermission.accountsView,
    AppRoutes.reports: AppPermission.reportsView,
    AppRoutes.settings: AppPermission.settingsManage,
    AppRoutes.users: AppPermission.usersManage,
  };

  for (final entry in candidates.entries) {
    if (user.hasPermission(entry.value)) {
      return entry.key;
    }
  }
  return AppRoutes.dashboard;
}

CustomTransitionPage<void> _fadeSlide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    name: state.name ?? state.matchedLocation,
    child: child,
    // Let the previous page show through so the fade doesn't flash blank.
    opaque: false,
    transitionDuration: AppDurations.page,
    reverseTransitionDuration: AppDurations.pageReverse,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final enter = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final exit = CurvedAnimation(
        parent: secondaryAnimation,
        curve: Curves.easeOutCubic,
      );

      final enterFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.9, curve: Curves.easeOutCubic),
          reverseCurve: const Interval(0.0, 1.0, curve: Curves.easeInCubic),
        ),
      );
      final exitFade = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: secondaryAnimation,
          curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
        ),
      );

      return FadeTransition(
        opacity: exitFade,
        child: SlideTransition(
          // Outgoing page drifts slightly upward while fading out.
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, -0.03),
          ).animate(exit),
          child: FadeTransition(
            opacity: enterFade,
            child: SlideTransition(
              // Incoming page rises from below.
              position: Tween<Offset>(
                begin: const Offset(0, 0.045),
                end: Offset.zero,
              ).animate(enter),
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

/// Convenience for permission checks in widgets.
bool contextHasPermission(BuildContext context, String permission) {
  final session = context.read<AuthBloc>().state.sessionOrNull;
  return session?.user.hasPermission(permission) ?? false;
}
