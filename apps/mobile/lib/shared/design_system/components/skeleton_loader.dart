import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../tokens/colours.dart';
import '../tokens/radii.dart';

/// Shimmer skeleton placeholder for content that is loading.
///
/// Wrap individual items with [SkeletonBox] for precise sizing,
/// or use [SkeletonLoader.list] / [SkeletonLoader.card] for pre-built layouts.
///
/// ```dart
/// SkeletonBox(width: double.infinity, height: 20, borderRadius: AppRadii.smAll)
/// ```
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = AppRadii.xsAll,
    this.enabled = true,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? MuhurtamColours.darkSurface2
          : MuhurtamColours.neutral200,
      highlightColor: isDark
          ? MuhurtamColours.neutral700
          : MuhurtamColours.neutral100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark
              ? MuhurtamColours.darkSurface2
              : MuhurtamColours.neutral200,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Pre-built skeleton for a list tile (avatar + two lines of text).
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SkeletonBox(
            width: 48,
            height: 48,
            borderRadius: AppRadii.fullAll,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 14, borderRadius: AppRadii.xsAll),
                const SizedBox(height: 8),
                SkeletonBox(
                  width: 120,
                  height: 12,
                  borderRadius: AppRadii.xsAll,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pre-built skeleton for a card with image + text lines.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            width: double.infinity,
            height: 160,
            borderRadius: AppRadii.mdAll,
          ),
          const SizedBox(height: 12),
          SkeletonBox(
            width: double.infinity,
            height: 18,
            borderRadius: AppRadii.xsAll,
          ),
          const SizedBox(height: 8),
          SkeletonBox(
            width: 200,
            height: 14,
            borderRadius: AppRadii.xsAll,
          ),
        ],
      ),
    );
  }
}

/// Repeats [child] [count] times inside a [Column] while loading.
///
/// Automatically removes itself (renders [child] normally) once [isLoading]
/// is false — so you can use this as a thin wrapper around your real list.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    required this.isLoading,
    required this.skeleton,
    required this.child,
    this.count = 5,
  });

  final bool isLoading;
  final Widget skeleton;
  final Widget child;
  final int count;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    return Column(
      children: List.generate(count, (_) => skeleton),
    );
  }
}
