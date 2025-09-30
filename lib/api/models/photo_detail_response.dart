// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'error_detail.dart';
import 'photo_response.dart';
import 'response_meta.dart';

part 'photo_detail_response.g.dart';

@JsonSerializable()
class PhotoDetailResponse {
  const PhotoDetailResponse({
    required this.success,
    required this.data,
    this.message,
    this.errors,
    this.meta,
  });
  
  factory PhotoDetailResponse.fromJson(Map<String, Object?> json) => _$PhotoDetailResponseFromJson(json);
  
  /// Whether the request completed successfully.
  final bool success;

  /// Primary message suitable for end users.
  final String? message;

  /// Requested photo metadata.
  final PhotoResponse data;

  /// Detailed errors when the request fails.
  final List<ErrorDetail>? errors;

  /// Diagnostic metadata accompanying the response.
  final ResponseMeta? meta;

  Map<String, Object?> toJson() => _$PhotoDetailResponseToJson(this);
}
