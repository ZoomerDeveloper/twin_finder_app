// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_register_verify_request.g.dart';

/// Verify email registration code (no account creation).
@JsonSerializable()
class EmailRegisterVerifyRequest {
  const EmailRegisterVerifyRequest({
    required this.email,
    required this.verificationCode,
  });
  
  factory EmailRegisterVerifyRequest.fromJson(Map<String, Object?> json) => _$EmailRegisterVerifyRequestFromJson(json);
  
  /// User email address
  final String email;

  /// 6-digit verification code
  @JsonKey(name: 'verification_code')
  final String verificationCode;

  Map<String, Object?> toJson() => _$EmailRegisterVerifyRequestToJson(this);
}
