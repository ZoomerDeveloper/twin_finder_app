// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_logout_request.g.dart';

/// Request model for admin logout.
@JsonSerializable()
class AdminLogoutRequest {
  const AdminLogoutRequest({
    required this.refreshToken,
  });
  
  factory AdminLogoutRequest.fromJson(Map<String, Object?> json) => _$AdminLogoutRequestFromJson(json);
  
  /// Refresh token to blacklist
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, Object?> toJson() => _$AdminLogoutRequestToJson(this);
}
