// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'apple_login_request.g.dart';

/// Apple OAuth login request schema.
@JsonSerializable()
class AppleLoginRequest {
  const AppleLoginRequest({
    required this.idToken,
    this.authorizationCode,
    this.user,
  });
  
  factory AppleLoginRequest.fromJson(Map<String, Object?> json) => _$AppleLoginRequestFromJson(json);
  
  /// Apple ID token
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Apple authorization code
  @JsonKey(name: 'authorization_code')
  final String? authorizationCode;

  /// Apple user data
  final dynamic user;

  Map<String, Object?> toJson() => _$AppleLoginRequestToJson(this);
}
