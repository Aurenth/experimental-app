import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../storage/hive_service.dart';

part 'providers.g.dart';

/// Injected once at startup via ProviderScope overrides.
final appConfigProvider = Provider<AppConfig>(
  (_) => throw UnimplementedError('appConfigProvider must be overridden at root'),
);

@riverpod
DioClient dioClient(DioClientRef ref) {
  final config = ref.watch(appConfigProvider);
  return DioClient(config: config, ref: ref);
}

@riverpod
HiveService hiveService(HiveServiceRef ref) => HiveService();
