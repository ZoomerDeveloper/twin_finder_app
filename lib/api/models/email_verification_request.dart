// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_verification_request.g.dart';

/// Email verification request schema.
@JsonSerializable()
class EmailVerificationRequest {
  const EmailVerificationRequest({
    required this.token,
  });
  
  factory EmailVerificationRequest.fromJson(Map<String, Object?> json) => _$EmailVerificationRequestFromJson(json);
  
  /// Email verification token
  final String token;

  Map<String, Object?> toJson() => _$EmailVerificationRequestToJson(this);
}
