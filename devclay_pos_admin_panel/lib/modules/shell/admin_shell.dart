import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../auth/presentation/bloc/admin_auth_bloc.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith(AdminRoutes.customers)) return 1;
    if (location.startsWith(AdminRoutes.licenses)) return 2;
    if (location.startsWith(AdminRoutes.requests)) return 3;
    if (location.startsWith(AdminRoutes.search)) return 4;
    if (location.startsWith(AdminRoutes.settings)) return 5;
    if (location.startsWith(AdminRoutes.audit)) return 6;
    if (location.startsWith(AdminRoutes.admins)) return 7;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = _indexForLocation(location);
    final auth = context.watch<AdminAuthBloc>().state;
    final isSuper = auth is AdminAuthAuthenticated && auth.user.isSuperAdmin;

    final destinations = <NavigationRailDestination>[
      const NavigationRailDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: Text('Dashboard'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.store_outlined),
        selectedIcon: Icon(Icons.store),
        label: Text('Customers'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.vpn_key_outlined),
        selectedIcon: Icon(Icons.vpn_key),
        label: Text('Licenses'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.inbox_outlined),
        selectedIcon: Icon(Icons.inbox),
        label: Text('Requests'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.search_outlined),
        selectedIcon: Icon(Icons.search),
        label: Text('Search'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.tune_outlined),
        selectedIcon: Icon(Icons.tune),
        label: Text('Settings'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: Text('Audit'),
      ),
      if (isSuper)
        const NavigationRailDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: Text('Admins'),
        ),
    ];

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index.clamp(0, destinations.length - 1),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'DevClayPOS',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IconButton(
                    tooltip: 'Sign out',
                    onPressed: () => context
                        .read<AdminAuthBloc>()
                        .add(const AdminAuthLogoutRequested()),
                    icon: const Icon(Icons.logout),
                  ),
                ),
              ),
            ),
            onDestinationSelected: (value) {
              switch (value) {
                case 0:
                  context.go(AdminRoutes.dashboard);
                case 1:
                  context.go(AdminRoutes.customers);
                case 2:
                  context.go(AdminRoutes.licenses);
                case 3:
                  context.go(AdminRoutes.requests);
                case 4:
                  context.go(AdminRoutes.search);
                case 5:
                  context.go(AdminRoutes.settings);
                case 6:
                  context.go(AdminRoutes.audit);
                case 7:
                  if (isSuper) context.go(AdminRoutes.admins);
              }
            },
            destinations: destinations,
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
