import '../../routes/app_routes.dart';

/// Routes blocked on Counter (client) devices — Manage on shop host.
const Set<String> kClientBlockedRoutes = {
  AppRoutes.products,
  AppRoutes.inventory,
  AppRoutes.purchases,
  AppRoutes.finance,
  AppRoutes.accounts,
  AppRoutes.users,
  AppRoutes.recycleBin,
};

bool isClientBlockedRoute(String path) {
  if (kClientBlockedRoutes.contains(path)) return true;
  // Nested report paths under blocked modules are not used today; products etc.
  // are exact matches. Keep helper for future nested routes.
  for (final blocked in kClientBlockedRoutes) {
    if (path.startsWith('$blocked/')) return true;
  }
  return false;
}
