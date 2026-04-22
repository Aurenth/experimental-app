import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/tokens/colours.dart';
import '../design_system/tokens/radii.dart';
import '../design_system/tokens/spacing.dart';
import '../design_system/tokens/typography.dart';

/// Muhurtam [ThemeData] for light and dark modes.
///
/// Uses Material 3 with the [AppColorScheme] palette and [AppTypography]
/// text theme. All tokens are sourced from the design system so component
/// overrides here stay minimal.
abstract final class AppTheme {
  static ThemeData get light => _buildTheme(AppColorScheme.light);
  static ThemeData get dark => _buildTheme(AppColorScheme.dark);

  static ThemeData _buildTheme(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,

      // ── AppBar ─────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: scheme.onSurface,
        ),
        systemOverlayStyle: scheme.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              ),
      ),

      // ── Cards ──────────────────────────────────────────────────────────
      cardTheme: CardTheme(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
        margin: EdgeInsets.zero,
      ),

      // ── Input decoration ───────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: AppRadii.smAll,
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.smAll,
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.smAll,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: scheme.onSurfaceVariant.withOpacity(0.6),
        ),
      ),

      // ── Buttons ────────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: AppTypography.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
        ),
      ),

      // ── Navigation bar ─────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return AppTypography.labelSmall.copyWith(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
            size: 24,
          );
        }),
      ),

      // ── Chip ───────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        labelStyle: AppTypography.labelMedium,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.fullAll),
      ),

      // ── Divider ────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // ── Snack bar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
      ),
    );
  }
}
