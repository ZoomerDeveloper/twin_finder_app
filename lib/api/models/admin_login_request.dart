// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_login_request.g.dart';

/// Request model for admin login.
@JsonSerializable()
class AdminLoginRequest {
  const AdminLoginRequest({
    required this.email,
    required this.password,
  });
  
  factory AdminLoginRequest.fromJson(Map<String, Object?> json) => _$AdminLoginRequestFromJson(json);
  
  /// Admin email address
  final String email;

  /// Admin password
  final String password;

  Map<String, Object?> toJson() => _$AdminLoginRequestToJson(this);
}
