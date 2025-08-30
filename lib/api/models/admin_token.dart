// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_token.g.dart';

/// Response model for admin authentication tokens.
@JsonSerializable()
class AdminToken {
  const AdminToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    this.tokenType = 'bearer',
  });
  
  factory AdminToken.fromJson(Map<String, Object?> json) => _$AdminTokenFromJson(json);
  
  /// JWT access token
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// JWT refresh token
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  /// Token type
  @JsonKey(name: 'token_type')
  final String tokenType;

  /// Token expiration time in seconds
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  Map<String, Object?> toJson() => _$AdminTokenToJson(this);
}
