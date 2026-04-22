import 'package:flutter/material.dart';

import '../tokens/colours.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_button.dart';

/// Full-page (or inline) error state with a retry action.
///
/// ```dart
/// ErrorState(
///   error: e.toString(),
///   onRetry: ref.invalidate(myProvider),
/// )
/// ```
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.error,
    this.title = 'Something went wrong',
    this.subtitle,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.padding = const EdgeInsets.all(AppSpacing.xl2),
  });

  /// Optional raw error string (shown in a subtle caption below the message).
  final String? error;
  final String title;
  final String? subtitle;
  final VoidCallback? onRetry;
  final String retryLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: scheme.error,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: AppTypography.titleLarge
                .copyWith(color: scheme.onSurface),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: AppTypography.bodyMedium
                  .copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              error!,
              style: AppTypography.labelSmall.copyWith(
                color: scheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.xl3),
            AppButton.filled(
              label: retryLabel,
              icon: const Icon(Icons.refresh_rounded),
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
