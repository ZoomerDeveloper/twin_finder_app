// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'content_report.g.dart';

/// Content report for moderation.
@JsonSerializable()
class ContentReport {
  const ContentReport({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.reportedUserId,
    required this.reportedUserName,
    required this.reportType,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
  });
  
  factory ContentReport.fromJson(Map<String, Object?> json) => _$ContentReportFromJson(json);
  
  /// Report ID
  final String id;

  /// Reporter user ID
  @JsonKey(name: 'reporter_id')
  final String reporterId;

  /// Reporter name
  @JsonKey(name: 'reporter_name')
  final String reporterName;

  /// Reported user ID
  @JsonKey(name: 'reported_user_id')
  final String reportedUserId;

  /// Reported user name
  @JsonKey(name: 'reported_user_name')
  final String reportedUserName;

  /// Type of report
  @JsonKey(name: 'report_type')
  final String reportType;

  /// Report reason
  final String reason;

  /// Report status
  final String status;

  /// Report creation timestamp
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Resolution timestamp
  @JsonKey(name: 'resolved_at')
  final DateTime? resolvedAt;

  /// Admin who resolved the report
  @JsonKey(name: 'resolved_by')
  final String? resolvedBy;

  Map<String, Object?> toJson() => _$ContentReportToJson(this);
}
