// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_registration_request.g.dart';

/// Email registration request schema (Step 1) with password.
@JsonSerializable()
class EmailRegistrationRequest {
  const EmailRegistrationRequest({required this.email, required this.password});

  factory EmailRegistrationRequest.fromJson(Map<String, Object?> json) =>
      _$EmailRegistrationRequestFromJson(json);

  /// User email address
  final String email;

  /// User password
  final String password;

  Map<String, Object?> toJson() => _$EmailRegistrationRequestToJson(this);
}
