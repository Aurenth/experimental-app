import 'package:flutter/material.dart';

import '../tokens/colours.dart';

/// Branded pull-to-refresh wrapper.
///
/// Wraps [RefreshIndicator] with Muhurtam's saffron accent and a slightly
/// elevated stroke width for visual clarity on small screens.
///
/// ```dart
/// PullToRefresh(
///   onRefresh: () async {
///     ref.invalidate(someProvider);
///     await ref.read(someProvider.future);
///   },
///   child: ListView(...),
/// )
/// ```
class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.displacement = 56,
  });

  final RefreshCallback onRefresh;
  final Widget child;

  /// How far the indicator is pulled before it triggers — defaults to 56px.
  final double displacement;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: MuhurtamColours.saffron500,
      backgroundColor: Theme.of(context).colorScheme.surface,
      strokeWidth: 2.5,
      displacement: displacement,
      child: child,
    );
  }
}
