// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'response_meta.g.dart';

/// Metadata included with every API response.
@JsonSerializable()
class ResponseMeta {
  const ResponseMeta({
    this.timestamp,
    this.path,
    this.statusCode,
    this.requestId,
    this.extra,
  });
  
  factory ResponseMeta.fromJson(Map<String, Object?> json) => _$ResponseMetaFromJson(json);
  
  /// UTC timestamp when the response was generated.
  final DateTime? timestamp;

  /// Request path associated with the response.
  final String? path;

  /// HTTP status code returned for the response.
  @JsonKey(name: 'status_code')
  final int? statusCode;

  /// Correlation identifier for the request, if available.
  @JsonKey(name: 'request_id')
  final String? requestId;

  /// Additional metadata entries for debugging or auditing.
  final dynamic extra;

  Map<String, Object?> toJson() => _$ResponseMetaToJson(this);
}
