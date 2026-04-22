import 'package:flutter/material.dart';

import 'colours.dart';

/// Box-shadow / elevation tokens for the Muhurtam design system.
///
/// Light-mode shadows use a warm brownish tint to complement the cream base.
/// Dark-mode shadows use pure black (surfaces handle depth via tone).
abstract final class AppShadows {
  static const _warmBlack = Color(0x1A1A0A0A);
  static const _warmBlackMd = Color(0x2A1A0A0A);

  static const none = <BoxShadow>[];

  static const xs = [
    BoxShadow(
      color: _warmBlack,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const sm = [
    BoxShadow(
      color: _warmBlack,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: _warmBlack,
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const md = [
    BoxShadow(
      color: _warmBlackMd,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: _warmBlack,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const lg = [
    BoxShadow(
      color: _warmBlackMd,
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: _warmBlack,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const xl = [
    BoxShadow(
      color: Color(0x3A1A0A0A),
      blurRadius: 48,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: _warmBlackMd,
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  // ── Saffron glow — use for CTAs / focused states ─────────────────────────
  static const saffronGlow = [
    BoxShadow(
      color: Color(0x40F5841F),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Returns the appropriate shadow list for a given elevation level (1–5).
  static List<BoxShadow> forElevation(int level) => switch (level) {
        1 => xs,
        2 => sm,
        3 => md,
        4 => lg,
        5 => xl,
        _ => none,
      };
}
