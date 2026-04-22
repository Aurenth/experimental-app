import 'package:flutter/material.dart';

/// Muhurtam brand colour palette.
///
/// All raw colour constants. Use [AppColorScheme.light] / [.dark] to get
/// a [ColorScheme] with full dark-mode support.
abstract final class MuhurtamColours {
  // ── Saffron (primary) ───────────────────────────────────────────────────
  static const saffron50 = Color(0xFFFFF7ED);
  static const saffron100 = Color(0xFFFFEDD5);
  static const saffron200 = Color(0xFFFED7AA);
  static const saffron300 = Color(0xFFFDB87D);
  static const saffron400 = Color(0xFFFB8C3B);
  static const saffron500 = Color(0xFFF5841F); // main brand saffron
  static const saffron600 = Color(0xFFE07010);
  static const saffron700 = Color(0xFFC05808);
  static const saffron800 = Color(0xFF9A440A);
  static const saffron900 = Color(0xFF7C380C);

  // ── Indigo (secondary) ──────────────────────────────────────────────────
  static const indigo50 = Color(0xFFF5F0FF);
  static const indigo100 = Color(0xFFEDE9FE);
  static const indigo200 = Color(0xFFDDD6FE);
  static const indigo300 = Color(0xFFC4B5FD);
  static const indigo400 = Color(0xFFA78BFA);
  static const indigo500 = Color(0xFF7C5CBF); // main indigo
  static const indigo600 = Color(0xFF5B3FA0);
  static const indigo700 = Color(0xFF4A3080);
  static const indigo800 = Color(0xFF3D1A6E); // deep royal indigo
  static const indigo900 = Color(0xFF2E1256);

  // ── Cream (background / surface) ────────────────────────────────────────
  static const cream50 = Color(0xFFFFFDF9);
  static const cream100 = Color(0xFFFFF8F0); // main background (light)
  static const cream200 = Color(0xFFFFF0DC);
  static const cream300 = Color(0xFFFFE4C4);
  static const cream400 = Color(0xFFFFD49A);

  // ── Neutral ─────────────────────────────────────────────────────────────
  static const neutral50 = Color(0xFFFAFAF9);
  static const neutral100 = Color(0xFFF5F5F0);
  static const neutral200 = Color(0xFFE5E5DC);
  static const neutral300 = Color(0xFFD1D1C7);
  static const neutral400 = Color(0xFFA3A396);
  static const neutral500 = Color(0xFF737366);
  static const neutral600 = Color(0xFF595952);
  static const neutral700 = Color(0xFF414140);
  static const neutral800 = Color(0xFF292928);
  static const neutral900 = Color(0xFF1A1A18);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);
  static const info = Color(0xFF2563EB);

  // ── Dark mode surfaces ───────────────────────────────────────────────────
  static const darkBackground = Color(0xFF1A1210);
  static const darkSurface = Color(0xFF2A1F1A);
  static const darkSurface2 = Color(0xFF3A2820);
}

/// Ready-to-use [ColorScheme] instances for light and dark modes.
abstract final class AppColorScheme {
  static const light = ColorScheme(
    brightness: Brightness.light,
    primary: MuhurtamColours.saffron500,
    onPrimary: Colors.white,
    primaryContainer: MuhurtamColours.saffron100,
    onPrimaryContainer: MuhurtamColours.saffron900,
    secondary: MuhurtamColours.indigo800,
    onSecondary: Colors.white,
    secondaryContainer: MuhurtamColours.indigo100,
    onSecondaryContainer: MuhurtamColours.indigo900,
    tertiary: MuhurtamColours.cream400,
    onTertiary: MuhurtamColours.neutral900,
    tertiaryContainer: MuhurtamColours.cream200,
    onTertiaryContainer: MuhurtamColours.neutral800,
    error: MuhurtamColours.error,
    onError: Colors.white,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: MuhurtamColours.cream100,
    onSurface: MuhurtamColours.neutral900,
    surfaceContainerLowest: MuhurtamColours.cream50,
    surfaceContainerLow: MuhurtamColours.cream100,
    surfaceContainer: MuhurtamColours.neutral100,
    surfaceContainerHigh: MuhurtamColours.neutral200,
    surfaceContainerHighest: MuhurtamColours.neutral300,
    onSurfaceVariant: MuhurtamColours.neutral600,
    outline: MuhurtamColours.neutral300,
    outlineVariant: MuhurtamColours.neutral200,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: MuhurtamColours.neutral900,
    onInverseSurface: MuhurtamColours.cream100,
    inversePrimary: MuhurtamColours.saffron300,
  );

  static const dark = ColorScheme(
    brightness: Brightness.dark,
    primary: MuhurtamColours.saffron400,
    onPrimary: MuhurtamColours.saffron900,
    primaryContainer: MuhurtamColours.saffron800,
    onPrimaryContainer: MuhurtamColours.saffron100,
    secondary: MuhurtamColours.indigo300,
    onSecondary: MuhurtamColours.indigo900,
    secondaryContainer: MuhurtamColours.indigo700,
    onSecondaryContainer: MuhurtamColours.indigo100,
    tertiary: MuhurtamColours.cream400,
    onTertiary: MuhurtamColours.neutral900,
    tertiaryContainer: MuhurtamColours.neutral800,
    onTertiaryContainer: MuhurtamColours.cream200,
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: Color(0xFFFEE2E2),
    surface: MuhurtamColours.darkBackground,
    onSurface: MuhurtamColours.cream100,
    surfaceContainerLowest: Color(0xFF100C0A),
    surfaceContainerLow: MuhurtamColours.darkBackground,
    surfaceContainer: MuhurtamColours.darkSurface,
    surfaceContainerHigh: MuhurtamColours.darkSurface2,
    surfaceContainerHighest: Color(0xFF4A3228),
    onSurfaceVariant: MuhurtamColours.neutral400,
    outline: MuhurtamColours.neutral600,
    outlineVariant: MuhurtamColours.neutral700,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: MuhurtamColours.cream100,
    onInverseSurface: MuhurtamColours.neutral900,
    inversePrimary: MuhurtamColours.saffron600,
  );
}
