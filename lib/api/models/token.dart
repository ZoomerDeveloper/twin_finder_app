// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

/// JWT token response schema.
///
/// Contains the authentication tokens returned after successful login or token refresh.
/// The access token is used for API authentication, while the refresh token is used.
/// to obtain new access tokens without re-authentication.
///
/// **Token Usage:**.
/// - access_token: Include in Authorization header for API requests.
/// - refresh_token: Use to obtain new tokens when access token expires.
/// - token_type: Always "bearer" for JWT tokens.
/// - expires_in: Seconds until access token expires.
///
/// **Security Notes:**.
/// - Store tokens securely (HTTPS only, secure storage).
/// - Access tokens have short expiration (typically 1 hour).
/// - Refresh tokens have longer expiration (typically 7-30 days).
/// - Refresh tokens are single-use and invalidated after use.
@JsonSerializable()
class Token {
  const Token({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'bearer',
  });
  
  factory Token.fromJson(Map<String, Object?> json) => _$TokenFromJson(json);
  
  /// JWT access token for API authentication
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// JWT refresh token for obtaining new access tokens
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  /// Token type for Authorization header
  @JsonKey(name: 'token_type')
  final String tokenType;

  /// Access token expiration time in seconds
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  Map<String, Object?> toJson() => _$TokenToJson(this);
}
