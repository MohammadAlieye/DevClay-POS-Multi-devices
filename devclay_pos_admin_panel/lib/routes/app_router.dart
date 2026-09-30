import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/router_refresh.dart';
import '../modules/admins/presentation/pages/admins_page.dart';
import '../modules/audit/presentation/pages/audit_page.dart';
import '../modules/auth/presentation/bloc/admin_auth_bloc.dart';
import '../modules/auth/presentation/pages/admin_login_page.dart';
import '../modules/customers/presentation/pages/customers_page.dart';
import '../modules/dashboard/presentation/pages/admin_dashboard_page.dart';
import '../modules/licenses/presentation/pages/licenses_page.dart';
import '../modules/requests/presentation/pages/license_requests_page.dart';
import '../modules/search/presentation/pages/search_page.dart';
import '../modules/settings/presentation/pages/settings_page.dart';
import '../modules/shell/admin_shell.dart';
import 'app_routes.dart';

GoRouter createAdminRouter() {
  final authBloc = sl<AdminAuthBloc>();

  return GoRouter(
    initialLocation: AdminRoutes.login,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final auth = authBloc.state;
      final onLogin = state.matchedLocation == AdminRoutes.login;

      if (auth is AdminAuthInitial || auth is AdminAuthLoading) {
        return onLogin ? null : AdminRoutes.login;
      }
      if (auth is AdminAuthUnauthenticated ||
          auth is AdminAuthFailure ||
          auth is AdminAuthPasswordResetSent) {
        return onLogin ? null : AdminRoutes.login;
      }
      if (auth is AdminAuthAuthenticated) {
        if (onLogin) return AdminRoutes.dashboard;
        if (state.matchedLocation == AdminRoutes.admins &&
            !auth.user.isSuperAdmin) {
          return AdminRoutes.dashboard;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AdminRoutes.login,
        builder: (_, _) => const AdminLoginPage(),
      ),
      ShellRoute(
        builder: (_, _, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: AdminRoutes.dashboard,
            builder: (_, _) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: AdminRoutes.customers,
            builder: (_, _) => const CustomersPage(),
          ),
          GoRoute(
            path: AdminRoutes.licenses,
            builder: (_, _) => const LicensesPage(),
          ),
          GoRoute(
            path: AdminRoutes.requests,
            builder: (_, _) => const LicenseRequestsPage(),
          ),
          GoRoute(
            path: AdminRoutes.search,
            builder: (_, _) => const GlobalSearchPage(),
          ),
          GoRoute(
            path: AdminRoutes.settings,
            builder: (_, _) => const AdminSettingsPage(),
          ),
          GoRoute(
            path: AdminRoutes.audit,
            builder: (_, _) => const AuditPage(),
          ),
          GoRoute(
            path: AdminRoutes.admins,
            builder: (_, _) => const AdminsPage(),
          ),
        ],
      ),
    ],
  );
}
