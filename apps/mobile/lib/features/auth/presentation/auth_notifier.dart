import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/auth_token.dart';

part 'auth_notifier.freezed.dart';
part 'auth_notifier.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated({required AuthToken token}) =
      _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.error(String message) = _Error;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      // TODO(dev): Call auth repository
      throw UnimplementedError();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<AuthToken> refreshToken() async {
    // TODO(dev): Call auth repository to refresh the token
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    ref.read(authTokenProvider.notifier).state = null;
    state = const AuthState.unauthenticated();
  }
}
