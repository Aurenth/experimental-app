import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Manages Hive initialisation and typed box access.
///
/// Initialise once at startup via [HiveService.init] before any box is opened.
class HiveService {
  static const _authBoxKey = 'auth';
  static const _settingsBoxKey = 'settings';
  static const _cacheBoxKey = 'cache';

  late Box<dynamic> _authBox;
  late Box<dynamic> _settingsBox;
  late Box<dynamic> _cacheBox;

  Future<void> init() async {
    final appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);

    _authBox = await Hive.openBox<dynamic>(_authBoxKey);
    _settingsBox = await Hive.openBox<dynamic>(_settingsBoxKey);
    _cacheBox = await Hive.openBox<dynamic>(_cacheBoxKey);
  }

  Box<dynamic> get authBox => _authBox;
  Box<dynamic> get settingsBox => _settingsBox;
  Box<dynamic> get cacheBox => _cacheBox;

  Future<void> clearAuth() => _authBox.clear();

  Future<void> dispose() async {
    await Hive.close();
  }
}
