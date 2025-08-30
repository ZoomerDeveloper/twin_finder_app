// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'content_report.dart';

part 'content_report_list_response.g.dart';

/// Response model for content report list.
@JsonSerializable()
class ContentReportListResponse {
  const ContentReportListResponse({
    required this.reports,
    required this.total,
    required this.page,
    required this.perPage,
  });
  
  factory ContentReportListResponse.fromJson(Map<String, Object?> json) => _$ContentReportListResponseFromJson(json);
  
  /// List of reports
  final List<ContentReport> reports;

  /// Total number of reports
  final int total;

  /// Current page number
  final int page;

  /// Number of items per page
  @JsonKey(name: 'per_page')
  final int perPage;

  Map<String, Object?> toJson() => _$ContentReportListResponseToJson(this);
}
