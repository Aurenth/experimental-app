import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tokens/durations.dart';
import '../tokens/radii.dart';
import '../tokens/spacing.dart';

enum _ButtonVariant { filled, outlined, ghost }

/// Muhurtam-branded button component.
///
/// Three variants:
/// - [AppButton.filled] — primary CTA, saffron-filled background.
/// - [AppButton.outlined] — secondary action, indigo border.
/// - [AppButton.ghost] — tertiary / inline, no border or background.
///
/// All variants support:
/// - [isLoading] — replaces label with a spinner, disables tap.
/// - [icon] — optional leading icon.
/// - [width] — expands to full-width when set to `double.infinity`.
class AppButton extends StatelessWidget {
  const AppButton.filled({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.size = AppButtonSize.medium,
  }) : _variant = _ButtonVariant.filled;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.size = AppButtonSize.medium,
  }) : _variant = _ButtonVariant.outlined;

  const AppButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.size = AppButtonSize.medium,
  }) : _variant = _ButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final AppButtonSize size;
  final _ButtonVariant _variant;

  void _handleTap() {
    if (isLoading || onPressed == null) return;
    HapticFeedback.lightImpact();
    onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final content = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loader'),
              height: size._iconSize,
              width: size._iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _variant == _ButtonVariant.filled
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            )
          : _ButtonContent(
              key: const ValueKey('label'),
              label: label,
              icon: icon,
              size: size,
            ),
    );

    final effectiveOnPressed = isLoading ? null : _handleTap;

    final child = width != null
        ? SizedBox(width: width, child: content)
        : content;

    return switch (_variant) {
      _ButtonVariant.filled => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            padding: size._padding,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
            minimumSize: Size(0, size._height),
          ),
          child: child,
        ),
      _ButtonVariant.outlined => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            padding: size._padding,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
            minimumSize: Size(0, size._height),
          ),
          child: child,
        ),
      _ButtonVariant.ghost => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            padding: size._padding,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.smAll),
            minimumSize: Size(0, size._height),
          ),
          child: child,
        ),
    };
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    super.key,
    required this.label,
    required this.icon,
    required this.size,
  });

  final String label;
  final Widget? icon;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    if (icon == null) return Text(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconTheme(
          data: IconThemeData(size: size._iconSize),
          child: icon!,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );
  }
}

enum AppButtonSize {
  small,
  medium,
  large;

  EdgeInsets get _padding => switch (this) {
        small => const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        medium => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl2,
            vertical: AppSpacing.md,
          ),
        large => const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl3,
            vertical: AppSpacing.lg,
          ),
      };

  double get _height => switch (this) {
        small => 36,
        medium => 44,
        large => 52,
      };

  double get _iconSize => switch (this) {
        small => 16,
        medium => 18,
        large => 20,
      };
}
