import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/app_config.dart';
import '../di/providers.dart';
import '../storage/hive_service.dart';
import '../../app/app.dart';

/// Single entry point shared by all flavour mains.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  final hive = HiveService();
  await hive.init();

  // RevenueCat
  if (config.revenueCatApiKey.isNotEmpty) {
    await Purchases.configure(PurchasesConfiguration(config.revenueCatApiKey));
    if (config.debugMode) {
      await Purchases.setLogLevel(LogLevel.debug);
    }
  }

  // PostHog
  if (config.postHogApiKey.isNotEmpty) {
    await Posthog().setup(config.postHogApiKey, host: config.postHogHost);
  }

  // Sentry — wraps the entire app widget tree
  if (config.sentryDsn.isNotEmpty) {
    await SentryFlutter.init(
      (options) {
        options.dsn = config.sentryDsn;
        options.tracesSampleRate = config.isProd ? 0.2 : 1.0;
        options.debug = config.debugMode;
        options.environment = config.flavour.name;
      },
      appRunner: () => _runApp(config, hive),
    );
  } else {
    _runApp(config, hive);
  }
}

void _runApp(AppConfig config, HiveService hive) {
  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        hiveServiceProvider.overrideWithValue(hive),
      ],
      child: const App(),
    ),
  );
}
