// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_match_update_request.g.dart';

/// Request model for updating match data by admin.
@JsonSerializable()
class AdminMatchUpdateRequest {
  const AdminMatchUpdateRequest({
    this.similarityScore,
    this.isViewed,
  });
  
  factory AdminMatchUpdateRequest.fromJson(Map<String, Object?> json) => _$AdminMatchUpdateRequestFromJson(json);
  
  /// Similarity score
  @JsonKey(name: 'similarity_score')
  final num? similarityScore;

  /// View status
  @JsonKey(name: 'is_viewed')
  final bool? isViewed;

  Map<String, Object?> toJson() => _$AdminMatchUpdateRequestToJson(this);
}
