// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_user_update_request.g.dart';

/// Request model for updating user data by admin.
@JsonSerializable()
class AdminUserUpdateRequest {
  const AdminUserUpdateRequest({
    this.isActive,
    this.isVerified,
    this.name,
    this.email,
  });
  
  factory AdminUserUpdateRequest.fromJson(Map<String, Object?> json) => _$AdminUserUpdateRequestFromJson(json);
  
  /// Account active status
  @JsonKey(name: 'is_active')
  final bool? isActive;

  /// Email verification status
  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  /// User name
  final String? name;

  /// User email
  final String? email;

  Map<String, Object?> toJson() => _$AdminUserUpdateRequestToJson(this);
}
