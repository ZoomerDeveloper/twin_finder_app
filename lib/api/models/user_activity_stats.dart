// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_activity_stats.g.dart';

/// User activity statistics.
@JsonSerializable()
class UserActivityStats {
  const UserActivityStats({
    required this.userId,
    required this.name,
    required this.matchCount,
    required this.photoCount,
    required this.isActive,
    this.email,
    this.lastActivity,
  });
  
  factory UserActivityStats.fromJson(Map<String, Object?> json) => _$UserActivityStatsFromJson(json);
  
  /// User ID
  @JsonKey(name: 'user_id')
  final String userId;

  /// User name
  final String name;

  /// User email
  final String? email;

  /// Number of matches
  @JsonKey(name: 'match_count')
  final int matchCount;

  /// Number of photos
  @JsonKey(name: 'photo_count')
  final int photoCount;

  /// Last activity timestamp
  @JsonKey(name: 'last_activity')
  final DateTime? lastActivity;

  /// Account active status
  @JsonKey(name: 'is_active')
  final bool isActive;

  Map<String, Object?> toJson() => _$UserActivityStatsToJson(this);
}
