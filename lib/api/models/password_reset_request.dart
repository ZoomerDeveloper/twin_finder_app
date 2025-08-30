// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'password_reset_request.g.dart';

/// Password reset request schema.
@JsonSerializable()
class PasswordResetRequest {
  const PasswordResetRequest({
    required this.email,
  });
  
  factory PasswordResetRequest.fromJson(Map<String, Object?> json) => _$PasswordResetRequestFromJson(json);
  
  /// User email address
  final String email;

  Map<String, Object?> toJson() => _$PasswordResetRequestToJson(this);
}
