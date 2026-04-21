import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

@freezed
class AuthToken with _$AuthToken {
  const factory AuthToken({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}

/// Readable from anywhere via [authTokenProvider].
final authTokenProvider = StateProvider<AuthToken?>((ref) => null);
