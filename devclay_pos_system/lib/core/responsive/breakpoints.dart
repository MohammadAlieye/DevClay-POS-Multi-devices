import 'package:flutter/widgets.dart';

/// Layout breakpoints for responsive shell behavior.
abstract final class AppBreakpoints {
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double wide = 1440;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
}
