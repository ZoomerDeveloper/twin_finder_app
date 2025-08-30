// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_auth_info.g.dart';

/// User authentication information.
@JsonSerializable()
class UserAuthInfo {
  const UserAuthInfo({
    required this.userId,
    required this.name,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    this.email,
  });
  
  factory UserAuthInfo.fromJson(Map<String, Object?> json) => _$UserAuthInfoFromJson(json);
  
  /// User ID
  @JsonKey(name: 'user_id')
  final String userId;

  /// User email
  final String? email;

  /// User name
  final String name;

  /// User active status
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// User verification status
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  /// Account creation time
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$UserAuthInfoToJson(this);
}
