/// Immutable per-flavour configuration injected at app startup.
class AppConfig {
  const AppConfig({
    required this.flavour,
    required this.apiBaseUrl,
    required this.sentryDsn,
    required this.revenueCatApiKey,
    required this.postHogApiKey,
    required this.postHogHost,
    this.debugMode = false,
  });

  final Flavour flavour;
  final String apiBaseUrl;
  final String sentryDsn;
  final String revenueCatApiKey;
  final String postHogApiKey;
  final String postHogHost;
  final bool debugMode;

  bool get isDev => flavour == Flavour.dev;
  bool get isStaging => flavour == Flavour.staging;
  bool get isProd => flavour == Flavour.prod;

  static const dev = AppConfig(
    flavour: Flavour.dev,
    apiBaseUrl: 'http://localhost:3000/api',
    sentryDsn: '',
    revenueCatApiKey: '',
    postHogApiKey: 'phc_dev_key',
    postHogHost: 'http://localhost:8000',
    debugMode: true,
  );

  static const staging = AppConfig(
    flavour: Flavour.staging,
    apiBaseUrl: 'https://api.staging.experimental-app.com/api',
    sentryDsn: '',
    revenueCatApiKey: '',
    postHogApiKey: 'phc_staging_key',
    postHogHost: 'https://posthog.staging.experimental-app.com',
    debugMode: true,
  );

  static const prod = AppConfig(
    flavour: Flavour.prod,
    apiBaseUrl: 'https://api.experimental-app.com/api',
    sentryDsn: '',
    revenueCatApiKey: '',
    postHogApiKey: 'phc_prod_key',
    postHogHost: 'https://posthog.experimental-app.com',
    debugMode: false,
  );
}

enum Flavour { dev, staging, prod }
