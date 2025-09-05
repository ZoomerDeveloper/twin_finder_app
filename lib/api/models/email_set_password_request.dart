// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_set_password_request.g.dart';

/// Set password after verification (account creation).
@JsonSerializable()
class EmailSetPasswordRequest {
  const EmailSetPasswordRequest({
    required this.verificationToken,
    required this.password,
    required this.passwordConfirm,
  });
  
  factory EmailSetPasswordRequest.fromJson(Map<String, Object?> json) => _$EmailSetPasswordRequestFromJson(json);
  
  /// One-time verification token
  @JsonKey(name: 'verification_token')
  final String verificationToken;

  /// Account password
  final String password;

  /// Confirmation password
  @JsonKey(name: 'password_confirm')
  final String passwordConfirm;

  Map<String, Object?> toJson() => _$EmailSetPasswordRequestToJson(this);
}
