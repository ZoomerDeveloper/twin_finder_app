// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_user_response.g.dart';

/// Response model for admin user data.
@JsonSerializable()
class AdminUserResponse {
  const AdminUserResponse({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.lastLogin,
  });
  
  factory AdminUserResponse.fromJson(Map<String, Object?> json) => _$AdminUserResponseFromJson(json);
  
  /// Admin user ID
  final String id;

  /// Admin email address
  final String email;

  /// Admin role (admin or moderator)
  final String role;

  /// Whether admin is active
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Account creation timestamp
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last login timestamp
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;

  Map<String, Object?> toJson() => _$AdminUserResponseToJson(this);
}
