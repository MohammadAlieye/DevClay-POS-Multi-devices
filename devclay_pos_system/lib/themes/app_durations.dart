/// Motion timing tokens for premium micro-interactions.
abstract final class AppDurations {
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration normal = Duration(milliseconds: 280);
  static const Duration page = Duration(milliseconds: 360);
  static const Duration pageReverse = Duration(milliseconds: 280);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration skeleton = Duration(milliseconds: 1200);
}
