// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'match_stats.g.dart';

/// Schema for match statistics.
@JsonSerializable()
class MatchStats {
  const MatchStats({
    required this.totalMatches,
    required this.viewedMatches,
    required this.unviewedMatches,
    required this.highSimilarityCount,
    required this.mediumSimilarityCount,
    required this.lowSimilarityCount,
    this.averageSimilarity,
  });
  
  factory MatchStats.fromJson(Map<String, Object?> json) => _$MatchStatsFromJson(json);
  
  /// Total number of matches
  @JsonKey(name: 'total_matches')
  final int totalMatches;

  /// Number of viewed matches
  @JsonKey(name: 'viewed_matches')
  final int viewedMatches;

  /// Number of unviewed matches
  @JsonKey(name: 'unviewed_matches')
  final int unviewedMatches;

  /// Number of high similarity matches
  @JsonKey(name: 'high_similarity_count')
  final int highSimilarityCount;

  /// Number of medium similarity matches
  @JsonKey(name: 'medium_similarity_count')
  final int mediumSimilarityCount;

  /// Number of low similarity matches
  @JsonKey(name: 'low_similarity_count')
  final int lowSimilarityCount;

  /// Average similarity score
  @JsonKey(name: 'average_similarity')
  final num? averageSimilarity;

  Map<String, Object?> toJson() => _$MatchStatsToJson(this);
}
