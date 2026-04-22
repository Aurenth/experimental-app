/// 4-point spacing scale for the Muhurtam design system.
///
/// Usage: `SizedBox(height: AppSpacing.lg)` or
/// `EdgeInsets.all(AppSpacing.md)`.
abstract final class AppSpacing {
  static const double xs2 = 2;   // 2px  — hairlines, tight gaps
  static const double xs = 4;    // 4px  — base unit
  static const double sm = 8;    // 8px  — compact inner padding
  static const double md = 12;   // 12px — comfortable inner padding
  static const double lg = 16;   // 16px — standard section gap
  static const double xl = 20;   // 20px
  static const double xl2 = 24;  // 24px — card padding, screen insets
  static const double xl3 = 32;  // 32px — section separation
  static const double xl4 = 40;  // 40px — large section gap
  static const double xl5 = 48;  // 48px — hero spacing
  static const double xl6 = 64;  // 64px — page-level breathing room
}
