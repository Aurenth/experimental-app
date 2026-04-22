import 'package:flutter/material.dart';

import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_button.dart';

/// Full-page (or inline) empty state with an optional illustration slot.
///
/// ```dart
/// EmptyState(
///   illustration: SvgPicture.asset('assets/icons/empty_search.svg'),
///   title: 'No results found',
///   subtitle: 'Try adjusting your search or filters.',
///   action: AppButton.filled(
///     label: 'Clear filters',
///     onPressed: _clearFilters,
///   ),
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.illustration,
    required this.title,
    this.subtitle,
    this.action,
    this.illustrationSize = 180,
    this.padding = const EdgeInsets.all(AppSpacing.xl2),
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  /// Optional slot for an SVG / image / Lottie illustration. Rendered above
  /// the title with [illustrationSize] as the bounding box.
  final Widget? illustration;
  final String title;
  final String? subtitle;

  /// Optional CTA widget — typically an [AppButton].
  final Widget? action;

  final double illustrationSize;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (illustration != null) ...[
            SizedBox(
              width: illustrationSize,
              height: illustrationSize,
              child: illustration,
            ),
            const SizedBox(height: AppSpacing.xl2),
          ],
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
          if (action != null) ...[
            const SizedBox(height: AppSpacing.xl3),
            action!,
          ],
        ],
      ),
    );
  }
}
