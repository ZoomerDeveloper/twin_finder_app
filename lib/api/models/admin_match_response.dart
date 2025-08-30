// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_match_response.g.dart';

/// Admin view of match data.
@JsonSerializable()
class AdminMatchResponse {
  const AdminMatchResponse({
    required this.id,
    required this.userId,
    required this.userName,
    required this.matchedUserId,
    required this.matchedUserName,
    required this.isViewed,
    required this.createdAt,
    this.userEmail,
    this.matchedUserEmail,
    this.similarityScore,
  });
  
  factory AdminMatchResponse.fromJson(Map<String, Object?> json) => _$AdminMatchResponseFromJson(json);
  
  /// Match ID
  final String id;

  /// User ID
  @JsonKey(name: 'user_id')
  final String userId;

  /// User name
  @JsonKey(name: 'user_name')
  final String userName;

  /// User email
  @JsonKey(name: 'user_email')
  final String? userEmail;

  /// Matched user ID
  @JsonKey(name: 'matched_user_id')
  final String matchedUserId;

  /// Matched user name
  @JsonKey(name: 'matched_user_name')
  final String matchedUserName;

  /// Matched user email
  @JsonKey(name: 'matched_user_email')
  final String? matchedUserEmail;

  /// Similarity score
  @JsonKey(name: 'similarity_score')
  final num? similarityScore;

  /// Whether match has been viewed
  @JsonKey(name: 'is_viewed')
  final bool isViewed;

  /// Match creation timestamp
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$AdminMatchResponseToJson(this);
}
