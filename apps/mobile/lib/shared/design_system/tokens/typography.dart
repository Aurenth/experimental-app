import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Muhurtam typography system.
///
/// - **Poppins** — display, headline, title (brand voice, Indian aesthetic)
/// - **Noto Sans** — body, label (legibility-first, supports Devanagari)
abstract final class AppTypography {
  // ── Display ──────────────────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
      );

  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
      );

  // ── Headline ─────────────────────────────────────────────────────────────
  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.29,
      );

  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
      );

  // ── Title ────────────────────────────────────────────────────────────────
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.27,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ── Body (Noto Sans for legibility) ──────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.notoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  static TextStyle get bodySmall => GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // ── Label ────────────────────────────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.notoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  static TextStyle get labelMedium => GoogleFonts.notoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  static TextStyle get labelSmall => GoogleFonts.notoSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}
