// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'photo_response.dart';

part 'photo_upload_response.g.dart';

@JsonSerializable()
class PhotoUploadResponse {
  const PhotoUploadResponse({
    required this.success,
    required this.message,
    required this.data,
  });
  
  factory PhotoUploadResponse.fromJson(Map<String, Object?> json) => _$PhotoUploadResponseFromJson(json);
  
  final bool success;
  final String message;
  final PhotoResponse data;

  Map<String, Object?> toJson() => _$PhotoUploadResponseToJson(this);
}
