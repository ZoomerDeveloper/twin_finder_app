// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_create_request.g.dart';

/// Request model for creating a new admin user.
@JsonSerializable()
class AdminCreateRequest {
  const AdminCreateRequest({
    required this.email,
    required this.password,
    required this.role,
  });
  
  factory AdminCreateRequest.fromJson(Map<String, Object?> json) => _$AdminCreateRequestFromJson(json);
  
  /// Admin email address
  final String email;

  /// Admin password
  final String password;

  /// Admin role
  final String role;

  Map<String, Object?> toJson() => _$AdminCreateRequestToJson(this);
}
