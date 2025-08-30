// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'match_generation_request.g.dart';

/// Schema for requesting match generation.
@JsonSerializable()
class MatchGenerationRequest {
  const MatchGenerationRequest({
    this.minSimilarity,
    this.maxSimilarity,
    this.count = 10,
  });
  
  factory MatchGenerationRequest.fromJson(Map<String, Object?> json) => _$MatchGenerationRequestFromJson(json);
  
  /// Number of matches to generate (1-50)
  final int count;

  /// Minimum similarity score for matches
  @JsonKey(name: 'min_similarity')
  final dynamic minSimilarity;

  /// Maximum similarity score for matches
  @JsonKey(name: 'max_similarity')
  final dynamic maxSimilarity;

  Map<String, Object?> toJson() => _$MatchGenerationRequestToJson(this);
}
