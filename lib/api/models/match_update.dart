// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'match_update.g.dart';

/// Schema for updating a match.
@JsonSerializable()
class MatchUpdate {
  const MatchUpdate({
    this.similarityScore,
    this.isViewed,
  });
  
  factory MatchUpdate.fromJson(Map<String, Object?> json) => _$MatchUpdateFromJson(json);
  
  /// Updated similarity score
  @JsonKey(name: 'similarity_score')
  final dynamic similarityScore;

  /// Updated viewing status
  @JsonKey(name: 'is_viewed')
  final bool? isViewed;

  Map<String, Object?> toJson() => _$MatchUpdateToJson(this);
}
