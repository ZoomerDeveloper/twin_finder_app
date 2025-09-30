// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'token.dart';

part 'social_login_response.g.dart';

/// Social login response schema.
@JsonSerializable()
class SocialLoginResponse {
  const SocialLoginResponse({
    required this.success,
    required this.message,
    this.userCreated = false,
    this.data,
    this.userInfo,
  });

  factory SocialLoginResponse.fromJson(Map<String, Object?> json) => _$SocialLoginResponseFromJson(json);

  /// Operation success status
  final bool success;

  /// Response message
  final String message;

  /// Token data if successful
  final Token? data;

  /// Whether a new user was created
  @JsonKey(name: 'user_created')
  final bool userCreated;

  /// User information from social provider
  @JsonKey(name: 'user_info')
  final dynamic userInfo;

  Map<String, Object?> toJson() => _$SocialLoginResponseToJson(this);
}
