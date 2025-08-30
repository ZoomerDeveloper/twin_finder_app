// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

/// User login request schema.
///
/// Contains the credentials required for user authentication. The email must be.
/// a valid email format, and the password must meet minimum security requirements.
///
/// **Security Requirements:**.
/// - Email must be a valid email format.
/// - Password must be at least 8 characters long.
/// - Passwords are hashed and compared securely.
/// - Failed login attempts may be rate-limited.
///
/// **Authentication Flow:**.
/// 1. User provides email and password.
/// 2. System validates email format.
/// 3. Password is hashed and compared with stored hash.
/// 4. If valid, JWT tokens are generated and returned.
@JsonSerializable()
class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
  });
  
  factory LoginRequest.fromJson(Map<String, Object?> json) => _$LoginRequestFromJson(json);
  
  /// User's registered email address
  final String email;

  /// User's password (minimum 8 characters)
  final String password;

  Map<String, Object?> toJson() => _$LoginRequestToJson(this);
}
