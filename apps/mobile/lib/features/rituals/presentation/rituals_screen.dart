import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/design_system/design_system.dart';
import '../domain/ritual.dart';
import 'rituals_notifier.dart';

class RitualsScreen extends ConsumerStatefulWidget {
  const RitualsScreen({super.key});

  @override
  ConsumerState<RitualsScreen> createState() => _RitualsScreenState();
}

class _RitualsScreenState extends ConsumerState<RitualsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  Timer? _debounce;

  static const _categories = RitualCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    ref
        .read(ritualsNotifierProvider.notifier)
        .setCategory(_categories[_tabController.index]);
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(ritualsNotifierProvider.notifier).setSearchQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(
          'Rituals',
          style: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(104),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: AppTextField(
                  controller: _searchController,
                  hint: 'Search rituals…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (_, value, __) => value.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(ritualsNotifierProvider.notifier)
                                  .setSearchQuery('');
                            },
                          ),
                  ),
                  onChanged: _onSearchChanged,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                ),
              ),
              _CategoryTabs(controller: _tabController),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _TraditionFilters(),
          Expanded(child: _RitualGrid()),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category tabs
// ---------------------------------------------------------------------------

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorColor: scheme.primary,
      dividerColor: scheme.outlineVariant,
      tabs: RitualCategory.values
          .map((c) => Tab(text: c.displayName))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Tradition filter chips
// ---------------------------------------------------------------------------

class _TraditionFilters extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(ritualsNotifierProvider.select((s) => s.selectedTradition));
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 48,
      color: scheme.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        children: [
          _TraditionChip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => ref
                .read(ritualsNotifierProvider.notifier)
                .setTradition(null),
          ),
          ...RitualTradition.values.map(
            (t) => _TraditionChip(
              label: t.displayName,
              isSelected: selected == t,
              onTap: () => ref
                  .read(ritualsNotifierProvider.notifier)
                  .setTradition(t),
            ),
          ),
        ],
      ),
    );
  }
}

class _TraditionChip extends StatelessWidget {
  const _TraditionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: scheme.primaryContainer,
        checkmarkColor: scheme.primary,
        labelStyle: AppTypography.labelSmall.copyWith(
          color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
        ),
        side: BorderSide(
          color: isSelected ? scheme.primary : scheme.outline,
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ritual grid
// ---------------------------------------------------------------------------

class _RitualGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ritualsNotifierProvider);

    if (state.error != null) {
      return ErrorState(
        error: state.error,
        onRetry: () => ref.read(ritualsNotifierProvider.notifier).refresh(),
      );
    }

    return PullToRefresh(
      onRefresh: () =>
          ref.read(ritualsNotifierProvider.notifier).refresh(),
      child: state.isLoading
          ? _SkeletonGrid()
          : state.rituals.isEmpty
              ? _EmptyRituals(query: state.searchQuery)
              : _RitualsContent(rituals: state.rituals),
    );
  }
}

class _SkeletonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const _SkeletonRitualCard(),
    );
  }
}

class _SkeletonRitualCard extends StatelessWidget {
  const _SkeletonRitualCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: AppRadii.lgAll,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(
              width: double.infinity,
              height: 100,
              borderRadius: AppRadii.mdAll,
            ),
            const SizedBox(height: AppSpacing.md),
            SkeletonBox(
              width: double.infinity,
              height: 16,
              borderRadius: AppRadii.xsAll,
            ),
            const SizedBox(height: AppSpacing.sm),
            SkeletonBox(
              width: 80,
              height: 12,
              borderRadius: AppRadii.xsAll,
            ),
          ],
        ),
      ),
    );
  }
}

class _RitualsContent extends StatelessWidget {
  const _RitualsContent({required this.rituals});

  final List<Ritual> rituals;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemCount: rituals.length,
      itemBuilder: (context, index) => _RitualCard(ritual: rituals[index]),
    );
  }
}

class _EmptyRituals extends StatelessWidget {
  const _EmptyRituals({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.isNotEmpty;

    return ListView(
      children: [
        EmptyState(
          illustration: Icon(
            hasQuery ? Icons.search_off_rounded : Icons.auto_stories_outlined,
            size: 72,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          illustrationSize: 72,
          title: hasQuery ? 'No rituals found' : 'No rituals here yet',
          subtitle: hasQuery
              ? 'Try different keywords or remove filters.'
              : 'Check back soon for more rituals.',
          action: hasQuery
              ? null
              : AppButton.outlined(
                  label: 'Explore all traditions',
                  onPressed: () {},
                ),
          padding: const EdgeInsets.all(AppSpacing.xl3),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Ritual card
// ---------------------------------------------------------------------------

class _RitualCard extends StatelessWidget {
  const _RitualCard({required this.ritual});

  final Ritual ritual;

  String _displayName(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'hi' && ritual.nameHi != null) {
      return ritual.nameHi!;
    }
    return ritual.name;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final name = _displayName(context);

    return AppCard.elevated(
      padding: EdgeInsets.zero,
      onTap: ritual.isLocked ? null : () {},
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image / placeholder
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadii.lg),
                    ),
                    color: ritual.isLocked
                        ? scheme.surfaceContainerHigh
                        : scheme.primaryContainer,
                  ),
                  child: ritual.imageUrl != null
                      ? Image.network(
                          ritual.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                            ritual.category == RitualCategory.festival
                                ? '🪔'
                                : ritual.category == RitualCategory.lifecycle
                                    ? '🌸'
                                    : ritual.category ==
                                            RitualCategory.monthly
                                        ? '🌙'
                                        : '🌿',
                            style: const TextStyle(fontSize: 36),
                          ),
                        ),
                ),
              ),
              // Info panel
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.labelLarge?.copyWith(
                        color: scheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _Badge(
                          label: ritual.tradition.displayName,
                          color: scheme.secondaryContainer,
                          textColor: scheme.onSecondaryContainer,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Locked overlay
          if (ritual.isLocked)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: AppRadii.lgAll,
                child: Container(
                  color: scheme.surface.withOpacity(0.72),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        color: scheme.onSurface,
                        size: 28,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton.filled(
                        label: 'Unlock',
                        onPressed: () {},
                        size: AppButtonSize.small,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadii.xsAll,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: textColor),
      ),
    );
  }
}
