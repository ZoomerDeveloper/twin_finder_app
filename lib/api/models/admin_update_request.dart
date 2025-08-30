// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_update_request.g.dart';

/// Request model for updating admin user data.
@JsonSerializable()
class AdminUpdateRequest {
  const AdminUpdateRequest({
    this.email,
    this.password,
    this.role,
    this.isActive,
  });
  
  factory AdminUpdateRequest.fromJson(Map<String, Object?> json) => _$AdminUpdateRequestFromJson(json);
  
  /// Admin email address
  final String? email;

  /// Admin password
  final String? password;

  /// Admin role
  final String? role;

  /// Whether admin is active
  @JsonKey(name: 'is_active')
  final bool? isActive;

  Map<String, Object?> toJson() => _$AdminUpdateRequestToJson(this);
}
