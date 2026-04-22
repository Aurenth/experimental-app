import 'package:flutter/material.dart';

import '../tokens/radii.dart';
import '../tokens/shadows.dart';
import '../tokens/spacing.dart';

/// Muhurtam branded card with warm shadow and optional tap action.
///
/// Use [AppCard.elevated] for floating surfaces (default).
/// Use [AppCard.flat] for inline sections within a page.
/// Use [AppCard.outlined] for bordered, non-elevated panels.
class AppCard extends StatelessWidget {
  const AppCard.elevated({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl2),
    this.onTap,
    this.borderRadius = AppRadii.lgAll,
    this.color,
    this.clipBehavior = Clip.antiAlias,
  }) : _variant = _CardVariant.elevated;

  const AppCard.flat({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl2),
    this.onTap,
    this.borderRadius = AppRadii.lgAll,
    this.color,
    this.clipBehavior = Clip.antiAlias,
  }) : _variant = _CardVariant.flat;

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl2),
    this.onTap,
    this.borderRadius = AppRadii.lgAll,
    this.color,
    this.clipBehavior = Clip.antiAlias,
  }) : _variant = _CardVariant.outlined;

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color? color;
  final Clip clipBehavior;
  final _CardVariant _variant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveColor = color ??
        switch (_variant) {
          _CardVariant.elevated ||
          _CardVariant.outlined =>
            scheme.surfaceContainerLow,
          _CardVariant.flat => scheme.surfaceContainerLowest,
        };

    final boxDecoration = BoxDecoration(
      color: effectiveColor,
      borderRadius: borderRadius,
      boxShadow: isDark
          ? AppShadows.none
          : switch (_variant) {
              _CardVariant.elevated => AppShadows.sm,
              _CardVariant.flat => AppShadows.none,
              _CardVariant.outlined => AppShadows.none,
            },
      border: _variant == _CardVariant.outlined
          ? Border.all(color: scheme.outline)
          : null,
    );

    Widget content = Container(
      decoration: boxDecoration,
      clipBehavior: clipBehavior,
      child: Padding(padding: padding, child: child),
    );

    if (onTap != null) {
      content = ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(onTap: onTap, child: content),
        ),
      );
    }

    return content;
  }
}

enum _CardVariant { elevated, flat, outlined }
