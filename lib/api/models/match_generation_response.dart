// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'match_generation_response.g.dart';

/// Schema for match generation response.
@JsonSerializable()
class MatchGenerationResponse {
  const MatchGenerationResponse({
    required this.generatedCount,
    required this.totalMatches,
    required this.message,
  });
  
  factory MatchGenerationResponse.fromJson(Map<String, Object?> json) => _$MatchGenerationResponseFromJson(json);
  
  /// Number of matches generated
  @JsonKey(name: 'generated_count')
  final int generatedCount;

  /// Total matches for the user
  @JsonKey(name: 'total_matches')
  final int totalMatches;

  /// Generation status message
  final String message;

  Map<String, Object?> toJson() => _$MatchGenerationResponseToJson(this);
}
