// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'content_report_update_request.g.dart';

/// Request model for updating content report status.
@JsonSerializable()
class ContentReportUpdateRequest {
  const ContentReportUpdateRequest({
    required this.status,
    this.resolutionNotes,
  });
  
  factory ContentReportUpdateRequest.fromJson(Map<String, Object?> json) => _$ContentReportUpdateRequestFromJson(json);
  
  /// Report status
  final String status;

  /// Resolution notes
  @JsonKey(name: 'resolution_notes')
  final String? resolutionNotes;

  Map<String, Object?> toJson() => _$ContentReportUpdateRequestToJson(this);
}
