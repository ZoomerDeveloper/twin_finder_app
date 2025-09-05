// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'verification_token_response.g.dart';

/// Response carrying one-time verification token to set password.
@JsonSerializable()
class VerificationTokenResponse {
  const VerificationTokenResponse({
    required this.success,
    required this.verificationToken,
    required this.expiresIn,
  });
  
  factory VerificationTokenResponse.fromJson(Map<String, Object?> json) => _$VerificationTokenResponseFromJson(json);
  
  final bool success;

  /// One-time JWT for setting password
  @JsonKey(name: 'verification_token')
  final String verificationToken;

  /// Seconds until token expires
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  Map<String, Object?> toJson() => _$VerificationTokenResponseToJson(this);
}
