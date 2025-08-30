// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_user_ban_request.g.dart';

/// Request model for banning/unbanning users.
@JsonSerializable()
class AdminUserBanRequest {
  const AdminUserBanRequest({
    this.reason,
    this.durationDays,
  });
  
  factory AdminUserBanRequest.fromJson(Map<String, Object?> json) => _$AdminUserBanRequestFromJson(json);
  
  /// Ban reason
  final String? reason;

  /// Ban duration in days
  @JsonKey(name: 'duration_days')
  final int? durationDays;

  Map<String, Object?> toJson() => _$AdminUserBanRequestToJson(this);
}
