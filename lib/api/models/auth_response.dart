// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'token.dart';

part 'auth_response.g.dart';

/// Authentication response schema.
///
/// Standard response format for all authentication endpoints. Provides consistent.
/// structure for success/failure status, user-friendly messages, and optional.
/// token data for successful operations.
///
/// **Response Structure:**.
/// - success: Boolean indicating if the operation succeeded.
/// - message: Human-readable message describing the result.
/// - data: Optional token data (only present for successful auth operations).
///
/// **Usage:**.
/// - All auth endpoints return this consistent format.
/// - Check success field to determine operation result.
/// - Use message for user feedback.
/// - Access token data when success is true.
@JsonSerializable()
class AuthResponse {
  const AuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, Object?> json) => _$AuthResponseFromJson(json);

  /// Boolean indicating if the authentication operation succeeded
  final bool success;

  /// Human-readable message describing the operation result
  final String message;

  /// Token data containing access and refresh tokens (only for successful auth operations)
  final Token? data;

  Map<String, Object?> toJson() => _$AuthResponseToJson(this);
}
