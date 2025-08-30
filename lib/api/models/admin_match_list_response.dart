// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_match_response.dart';

part 'admin_match_list_response.g.dart';

/// Response model for admin match list.
@JsonSerializable()
class AdminMatchListResponse {
  const AdminMatchListResponse({
    required this.matches,
    required this.total,
    required this.page,
    required this.perPage,
  });
  
  factory AdminMatchListResponse.fromJson(Map<String, Object?> json) => _$AdminMatchListResponseFromJson(json);
  
  /// List of matches
  final List<AdminMatchResponse> matches;

  /// Total number of matches
  final int total;

  /// Current page number
  final int page;

  /// Number of items per page
  @JsonKey(name: 'per_page')
  final int perPage;

  Map<String, Object?> toJson() => _$AdminMatchListResponseToJson(this);
}
