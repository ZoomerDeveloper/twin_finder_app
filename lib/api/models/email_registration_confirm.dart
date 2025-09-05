// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_registration_confirm.g.dart';

/// Email registration confirmation schema (Step 2).
@JsonSerializable()
class EmailRegistrationConfirm {
  const EmailRegistrationConfirm({
    required this.email,
    required this.verificationCode,
  });
  
  factory EmailRegistrationConfirm.fromJson(Map<String, Object?> json) => _$EmailRegistrationConfirmFromJson(json);
  
  /// User email address
  final String email;

  /// Email verification code
  @JsonKey(name: 'verification_code')
  final String verificationCode;

  Map<String, Object?> toJson() => _$EmailRegistrationConfirmToJson(this);
}
