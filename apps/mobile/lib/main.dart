// Default entry — runs prod flavour.
// The prod flavour build uses this main; individual flavour mains are
// main_dev.dart, main_staging.dart, main_prod.dart.

import 'core/config/app_config.dart';
import 'core/utils/bootstrap.dart';

void main() => bootstrap(AppConfig.prod);
