import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Muhurtam bottom navigation bar with haptic feedback on item selection.
///
/// Wraps [NavigationBar] (Material 3) and fires [HapticFeedback.selectionClick]
/// on every item tap — matching the "tactile" feel expected by Indian-market
/// users accustomed to system-level haptics.
///
/// ```dart
/// AppBottomNav(
///   currentIndex: _currentIndex,
///   onDestinationSelected: (i) => setState(() => _currentIndex = i),
///   destinations: const [
///     AppNavDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Home'),
///     AppNavDestination(icon: Icons.search_outlined, selectedIcon: Icons.search, label: 'Search'),
///   ],
/// )
/// ```
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
    this.backgroundColor,
    this.indicatorColor,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AppNavDestination> destinations;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final NavigationDestinationLabelBehavior labelBehavior;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        HapticFeedback.selectionClick();
        onDestinationSelected(index);
      },
      backgroundColor: backgroundColor,
      indicatorColor:
          indicatorColor ?? Theme.of(context).colorScheme.primaryContainer,
      labelBehavior: labelBehavior,
      destinations: destinations
          .map(
            (d) => NavigationDestination(
              icon: Icon(d.icon),
              selectedIcon: Icon(d.selectedIcon ?? d.icon),
              label: d.label,
              tooltip: d.tooltip ?? d.label,
            ),
          )
          .toList(),
    );
  }
}

class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.tooltip,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final String? tooltip;
}
