// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_token.dart';
import 'admin_user_response.dart';

part 'admin_login_response.g.dart';

/// Response model for successful admin login.
@JsonSerializable()
class AdminLoginResponse {
  const AdminLoginResponse({
    required this.admin,
    required this.token,
  });
  
  factory AdminLoginResponse.fromJson(Map<String, Object?> json) => _$AdminLoginResponseFromJson(json);
  
  /// Admin user data
  final AdminUserResponse admin;

  /// Authentication tokens
  final AdminToken token;

  Map<String, Object?> toJson() => _$AdminLoginResponseToJson(this);
}
