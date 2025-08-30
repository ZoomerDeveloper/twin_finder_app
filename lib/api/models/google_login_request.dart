// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'google_login_request.g.dart';

/// Google OAuth login request schema.
@JsonSerializable()
class GoogleLoginRequest {
  const GoogleLoginRequest({
    required this.idToken,
    this.accessToken,
  });
  
  factory GoogleLoginRequest.fromJson(Map<String, Object?> json) => _$GoogleLoginRequestFromJson(json);
  
  /// Google ID token
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Google access token
  @JsonKey(name: 'access_token')
  final String? accessToken;

  Map<String, Object?> toJson() => _$GoogleLoginRequestToJson(this);
}
