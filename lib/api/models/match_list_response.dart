// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'match_with_user.dart';

part 'match_list_response.g.dart';

/// Schema for paginated match list response.
@JsonSerializable()
class MatchListResponse {
  const MatchListResponse({
    required this.matches,
    required this.total,
    required this.page,
    required this.perPage,
    required this.hasNext,
    required this.hasPrev,
  });
  
  factory MatchListResponse.fromJson(Map<String, Object?> json) => _$MatchListResponseFromJson(json);
  
  /// List of matches
  final List<MatchWithUser> matches;

  /// Total number of matches
  final int total;

  /// Current page number
  final int page;

  /// Number of matches per page
  @JsonKey(name: 'per_page')
  final int perPage;

  /// Whether there are more pages
  @JsonKey(name: 'has_next')
  final bool hasNext;

  /// Whether there are previous pages
  @JsonKey(name: 'has_prev')
  final bool hasPrev;

  Map<String, Object?> toJson() => _$MatchListResponseToJson(this);
}
