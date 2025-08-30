// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'o_auth_callback_request.g.dart';

/// OAuth callback request schema.
@JsonSerializable()
class OAuthCallbackRequest {
  const OAuthCallbackRequest({
    required this.code,
    this.state,
    this.error,
  });
  
  factory OAuthCallbackRequest.fromJson(Map<String, Object?> json) => _$OAuthCallbackRequestFromJson(json);
  
  /// Authorization code from OAuth provider
  final String code;

  /// State parameter for CSRF protection
  final String? state;

  /// Error from OAuth provider
  final String? error;

  Map<String, Object?> toJson() => _$OAuthCallbackRequestToJson(this);
}
