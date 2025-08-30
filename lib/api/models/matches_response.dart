import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matches_response.g.dart';

@JsonSerializable()
class MatchesResponse {
  final List<Match> matches;
  final int total;
  final int page;
  final int perPage;
  final bool hasNext;
  final bool hasPrev;

  MatchesResponse({
    required this.matches,
    required this.total,
    required this.page,
    required this.perPage,
    required this.hasNext,
    required this.hasPrev,
  });

  factory MatchesResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchesResponseToJson(this);
}

@JsonSerializable()
class Match {
  final String similarityScore;
  final bool isViewed;
  final String id;
  final String userId;
  final String matchedUserId;
  final DateTime createdAt;
  final String matchedUserName;
  final String? matchedUserProfilePhotoUrl;
  final int similarityPercentage;
  final bool isHighSimilarity;
  final bool isMediumSimilarity;
  final bool isLowSimilarity;

  Match({
    required this.similarityScore,
    required this.isViewed,
    required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.createdAt,
    required this.matchedUserName,
    this.matchedUserProfilePhotoUrl,
    required this.similarityPercentage,
    required this.isHighSimilarity,
    required this.isMediumSimilarity,
    required this.isLowSimilarity,
  });

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);

  // Helper method to get similarity level color
  Color get similarityColor {
    if (isHighSimilarity) return const Color(0xFFFF3F8E); // Pink
    if (isMediumSimilarity) return const Color(0xFFFF7A00); // Orange
    return const Color(0xFF059669); // Green
  }

  // Helper method to get similarity level text
  String get similarityLevel {
    if (isHighSimilarity) return 'High';
    if (isMediumSimilarity) return 'Medium';
    return 'Low';
  }
}
