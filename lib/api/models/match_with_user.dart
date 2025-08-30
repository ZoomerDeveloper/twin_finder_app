// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'match_with_user.g.dart';

/// Schema for match with matched user information.
@JsonSerializable()
class MatchWithUser {
  const MatchWithUser({
    required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.createdAt,
    required this.matchedUserName,
    required this.similarityPercentage,
    required this.isHighSimilarity,
    required this.isMediumSimilarity,
    required this.isLowSimilarity,
    this.isViewed = false,
    this.similarityScore,
    this.matchedUserProfilePhotoUrl,
  });
  
  factory MatchWithUser.fromJson(Map<String, Object?> json) => _$MatchWithUserFromJson(json);
  
  /// Similarity score between 0.0000 and 1.0000
  @JsonKey(name: 'similarity_score')
  final String? similarityScore;

  /// Whether the match has been viewed by the user
  @JsonKey(name: 'is_viewed')
  final bool isViewed;

  /// Unique match identifier
  final String id;

  /// ID of the user who owns this match
  @JsonKey(name: 'user_id')
  final String userId;

  /// ID of the matched user
  @JsonKey(name: 'matched_user_id')
  final String matchedUserId;

  /// When the match was created
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Name of the matched user
  @JsonKey(name: 'matched_user_name')
  final String matchedUserName;

  /// Profile photo URL of the matched user
  @JsonKey(name: 'matched_user_profile_photo_url')
  final String? matchedUserProfilePhotoUrl;

  /// Calculate similarity percentage from score.
  @JsonKey(name: 'similarity_percentage')
  final num? similarityPercentage;

  /// Calculate if similarity is high.
  @JsonKey(name: 'is_high_similarity')
  final bool isHighSimilarity;

  /// Calculate if similarity is medium.
  @JsonKey(name: 'is_medium_similarity')
  final bool isMediumSimilarity;

  /// Calculate if similarity is low.
  @JsonKey(name: 'is_low_similarity')
  final bool isLowSimilarity;

  Map<String, Object?> toJson() => _$MatchWithUserToJson(this);
}
