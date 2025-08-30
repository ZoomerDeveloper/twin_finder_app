// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'match_with_user.dart';

part 'match_discovery_response.g.dart';

/// Schema for match discovery response with endless scroll support.
@JsonSerializable()
class MatchDiscoveryResponse {
  const MatchDiscoveryResponse({
    required this.matches,
    required this.totalCount,
    required this.offset,
    required this.limit,
    required this.hasMore,
  });
  
  factory MatchDiscoveryResponse.fromJson(Map<String, Object?> json) => _$MatchDiscoveryResponseFromJson(json);
  
  /// List of discovery matches
  final List<MatchWithUser> matches;

  /// Total number of available discovery matches
  @JsonKey(name: 'total_count')
  final int totalCount;

  /// Current offset for pagination
  final int offset;

  /// Number of matches returned in this batch
  final int limit;

  /// Whether there are more matches available
  @JsonKey(name: 'has_more')
  final bool hasMore;

  Map<String, Object?> toJson() => _$MatchDiscoveryResponseToJson(this);
}
