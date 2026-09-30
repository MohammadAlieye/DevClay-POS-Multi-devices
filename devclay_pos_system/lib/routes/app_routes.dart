/// Route path constants for DevClayPOS navigation.
abstract final class AppRoutes {
  static const String license = '/license';
  static const String login = '/login';
  static const String selectStore = '/select-store';
  static const String dashboard = '/dashboard';
  static const String pos = '/pos';
  static const String products = '/products';
  static const String inventory = '/inventory';
  static const String purchases = '/purchases';
  static const String sales = '/sales';
  static const String customers = '/customers';
  static const String accounts = '/accounts';
  static const String finance = '/finance';
  static const String reports = '/reports';
  static String reportDetail(String id) => '$reports/$id';
  static const String users = '/users';
  static const String settings = '/settings';
  static const String labels = '/labels';
  static const String recycleBin = '/recycle-bin';
}
