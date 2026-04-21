import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              label: Text(config.flavour.name.toUpperCase()),
              backgroundColor: _flavourColour(config.flavour),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome', style: TextStyle(fontSize: 24)),
      ),
    );
  }

  Color _flavourColour(Flavour f) => switch (f) {
        Flavour.dev => Colors.orange,
        Flavour.staging => Colors.blue,
        Flavour.prod => Colors.green,
      };
}
