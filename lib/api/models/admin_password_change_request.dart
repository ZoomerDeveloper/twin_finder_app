// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_password_change_request.g.dart';

/// Request model for changing admin password.
@JsonSerializable()
class AdminPasswordChangeRequest {
  const AdminPasswordChangeRequest({
    required this.currentPassword,
    required this.newPassword,
  });
  
  factory AdminPasswordChangeRequest.fromJson(Map<String, Object?> json) => _$AdminPasswordChangeRequestFromJson(json);
  
  /// Current password
  @JsonKey(name: 'current_password')
  final String currentPassword;

  /// New password
  @JsonKey(name: 'new_password')
  final String newPassword;

  Map<String, Object?> toJson() => _$AdminPasswordChangeRequestToJson(this);
}
