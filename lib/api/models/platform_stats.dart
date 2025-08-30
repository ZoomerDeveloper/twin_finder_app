// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'platform_stats.g.dart';

/// Platform statistics for admin dashboard.
@JsonSerializable()
class PlatformStats {
  const PlatformStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.verifiedUsers,
    required this.totalMatches,
    required this.totalPhotos,
    required this.usersWithPhotos,
    required this.avgMatchesPerUser,
    required this.usersCreatedToday,
    required this.usersCreatedThisWeek,
    required this.usersCreatedThisMonth,
    required this.topCountries,
    required this.genderDistribution,
    this.avgSimilarityScore,
  });
  
  factory PlatformStats.fromJson(Map<String, Object?> json) => _$PlatformStatsFromJson(json);
  
  /// Total number of users
  @JsonKey(name: 'total_users')
  final int totalUsers;

  /// Number of active users
  @JsonKey(name: 'active_users')
  final int activeUsers;

  /// Number of verified users
  @JsonKey(name: 'verified_users')
  final int verifiedUsers;

  /// Total number of matches
  @JsonKey(name: 'total_matches')
  final int totalMatches;

  /// Total number of photos
  @JsonKey(name: 'total_photos')
  final int totalPhotos;

  /// Users with at least one photo
  @JsonKey(name: 'users_with_photos')
  final int usersWithPhotos;

  /// Average matches per user
  @JsonKey(name: 'avg_matches_per_user')
  final num avgMatchesPerUser;

  /// Average similarity score
  @JsonKey(name: 'avg_similarity_score')
  final num? avgSimilarityScore;

  /// Users created today
  @JsonKey(name: 'users_created_today')
  final int usersCreatedToday;

  /// Users created this week
  @JsonKey(name: 'users_created_this_week')
  final int usersCreatedThisWeek;

  /// Users created this month
  @JsonKey(name: 'users_created_this_month')
  final int usersCreatedThisMonth;

  /// Top countries by user count
  @JsonKey(name: 'top_countries')
  final List<dynamic> topCountries;

  /// Gender distribution
  @JsonKey(name: 'gender_distribution')
  final dynamic genderDistribution;

  Map<String, Object?> toJson() => _$PlatformStatsToJson(this);
}
