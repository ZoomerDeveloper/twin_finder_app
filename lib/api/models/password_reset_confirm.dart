// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'password_reset_confirm.g.dart';

/// Password reset confirmation schema.
@JsonSerializable()
class PasswordResetConfirm {
  const PasswordResetConfirm({
    required this.token,
    required this.newPassword,
  });
  
  factory PasswordResetConfirm.fromJson(Map<String, Object?> json) => _$PasswordResetConfirmFromJson(json);
  
  /// Password reset token
  final String token;

  /// New password
  @JsonKey(name: 'new_password')
  final String newPassword;

  Map<String, Object?> toJson() => _$PasswordResetConfirmToJson(this);
}
