// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'error_detail.g.dart';

/// Machine and human readable error information.
@JsonSerializable()
class ErrorDetail {
  const ErrorDetail({
    this.message,
    this.code,
    this.field,
    this.help,
  });
  
  factory ErrorDetail.fromJson(Map<String, Object?> json) => _$ErrorDetailFromJson(json);
  
  /// Human-friendly description of the problem.
  final String? message;

  /// Machine-friendly error code for programmatic handling.
  final String? code;

  /// Related request field when the error is field-specific.
  final String? field;

  /// Optional hint to help the client resolve the issue.
  final String? help;

  Map<String, Object?> toJson() => _$ErrorDetailToJson(this);
}
