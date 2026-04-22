/// Animation duration tokens for the Muhurtam design system.
///
/// Aligned with Material 3 motion guidelines, tuned for 60/120fps mid-range
/// Android devices common in the Indian market.
abstract final class AppDurations {
  /// Instant feedback — state toggles, switches (no perceived animation).
  static const instant = Duration(milliseconds: 50);

  /// Micro-interactions — icon state changes, checkbox ticks.
  static const fast = Duration(milliseconds: 150);

  /// Standard UI transitions — button ripple completion, tab switches.
  static const normal = Duration(milliseconds: 250);

  /// Moderate transitions — bottom sheets sliding in, modal overlays.
  static const medium = Duration(milliseconds: 350);

  /// Complex layout changes — page transitions, hero animations.
  static const slow = Duration(milliseconds: 500);

  /// Skeleton-loader shimmer sweep cycle.
  static const shimmer = Duration(milliseconds: 1200);

  /// Pull-to-refresh spinner reveal.
  static const refresh = Duration(milliseconds: 300);
}
