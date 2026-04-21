import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/auth_token.dart';
import '../../features/auth/presentation/auth_notifier.dart';

/// Attaches the JWT access token to every request and handles transparent
/// token refresh on 401 responses. On refresh failure it signs the user out.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref, this._dio);

  final Ref _ref;
  final Dio _dio;

  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authTokenProvider);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer ${token.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _isRefreshing) {
      return handler.next(err);
    }

    _isRefreshing = true;
    try {
      final newToken =
          await _ref.read(authNotifierProvider.notifier).refreshToken();

      err.requestOptions.headers['Authorization'] =
          'Bearer ${newToken.accessToken}';

      final response = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      await _ref.read(authNotifierProvider.notifier).signOut();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
