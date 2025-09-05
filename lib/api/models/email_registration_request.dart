// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'email_registration_request.g.dart';

/// Email registration request schema (Step 1).
@JsonSerializable()
class EmailRegistrationRequest {
  const EmailRegistrationRequest({
    required this.email,
  });
  
  factory EmailRegistrationRequest.fromJson(Map<String, Object?> json) => _$EmailRegistrationRequestFromJson(json);
  
  /// User email address
  final String email;

  Map<String, Object?> toJson() => _$EmailRegistrationRequestToJson(this);
}
