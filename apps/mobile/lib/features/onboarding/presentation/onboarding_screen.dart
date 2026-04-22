import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import 'onboarding_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: AppDurations.normal,
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    ref.read(onboardingCompleteProvider.notifier).state = true;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isLastPage = _currentPage == _pageCount - 1;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: const [
                _HeroPage(),
                _RitualPreviewPage(),
                _TraditionLanguagePage(),
              ],
            ),
          ),
          _BottomBar(
            currentPage: _currentPage,
            pageCount: _pageCount,
            isLastPage: isLastPage,
            onNext: _next,
            onSkip: _complete,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page 1 — Hero
// ─────────────────────────────────────────────────────────────────────────────

class _HeroPage extends StatelessWidget {
  const _HeroPage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MuhurtamColours.indigo800,
            MuhurtamColours.saffron600,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl4),
              _OmSymbol(),
              const SizedBox(height: AppSpacing.xl4),
              Text(
                'Plan any puja\nin minutes',
                style: textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Step-by-step guidance for every ritual,\nin your tradition and language.',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl6),
            ],
          ),
        ),
      ),
    );
  }
}

class _OmSymbol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: Center(
        child: Text(
          'ॐ',
          style: TextStyle(
            fontSize: 64,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page 2 — Ritual Preview
// ─────────────────────────────────────────────────────────────────────────────

class _RitualPreviewPage extends StatelessWidget {
  const _RitualPreviewPage();

  static const _steps = [
    (icon: Icons.water_drop_outlined, label: 'Gather flowers, rice & diyas'),
    (icon: Icons.wb_sunny_outlined, label: 'Purify the space with incense'),
    (icon: Icons.favorite_border, label: 'Invoke the deity with mantras'),
    (icon: Icons.local_fire_department_outlined, label: 'Light the sacred flame'),
    (icon: Icons.volunteer_activism_outlined, label: 'Offer prasad with devotion'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl4),
            Text(
              'Every ritual,\nguided clearly',
              style: textTheme.headlineLarge?.copyWith(
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Sample: Lakshmi Puja — Diwali',
              style: textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xl3),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _steps.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) {
                  final step = _steps[i];
                  return _StepCard(
                    number: i + 1,
                    icon: step.icon,
                    label: step.label,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.label,
  });

  final int number;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadii.mdAll,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: textTheme.labelLarge?.copyWith(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(icon, color: scheme.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page 3 — Tradition + Language
// ─────────────────────────────────────────────────────────────────────────────

class _TraditionLanguagePage extends StatefulWidget {
  const _TraditionLanguagePage();

  @override
  State<_TraditionLanguagePage> createState() =>
      _TraditionLanguagePageState();
}

class _TraditionLanguagePageState extends State<_TraditionLanguagePage> {
  String _selectedTradition = 'Vaishnav';
  String _selectedLanguage = 'English';

  static const _traditions = [
    'Vaishnav',
    'Shaivite',
    'Shakta',
    'Smartha',
    'Tribal',
    'Other',
  ];

  static const _languages = [
    'English',
    'हिंदी',
    'తెలుగు',
    'தமிழ்',
    'ಕನ್ನಡ',
    'मराठी',
    'বাংলা',
    'ਪੰਜਾਬੀ',
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl4),
            Text(
              'Your tradition,\nyour language',
              style: textTheme.headlineLarge?.copyWith(
                color: scheme.secondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Personalise your experience',
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl3),
            Text(
              'TRADITION',
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _traditions.map((t) {
                final selected = t == _selectedTradition;
                return FilterChip(
                  label: Text(t),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedTradition = t),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl3),
            Text(
              'LANGUAGE',
              style: textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _languages.map((l) {
                final selected = l == _selectedLanguage;
                return FilterChip(
                  label: Text(l),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedLanguage = l),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl4),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom bar — dots + buttons
// ─────────────────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.currentPage,
    required this.pageCount,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  final int currentPage;
  final int pageCount;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl2,
        AppSpacing.lg,
        AppSpacing.xl2,
        AppSpacing.xl3,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pageCount, (i) {
              final active = i == currentPage;
              return AnimatedContainer(
                duration: AppDurations.fast,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? scheme.primary : scheme.outlineVariant,
                  borderRadius: AppRadii.fullAll,
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.xl2),
          AppButton.filled(
            label: isLastPage ? 'Get Started' : 'Next',
            onPressed: onNext,
            width: double.infinity,
            size: AppButtonSize.large,
          ),
          if (!isLastPage) ...[
            const SizedBox(height: AppSpacing.md),
            AppButton.ghost(
              label: 'Skip',
              onPressed: onSkip,
              width: double.infinity,
            ),
          ],
        ],
      ),
    );
  }
}
