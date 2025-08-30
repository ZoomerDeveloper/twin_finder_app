// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'photo_response.g.dart';

@JsonSerializable()
class PhotoResponse {
  const PhotoResponse({
    required this.id,
    required this.userId,
    required this.filePath,
    required this.fileSize,
    required this.mimeType,
    required this.createdAt,
    this.isPrimary = false,
    this.width,
    this.height,
  });
  
  factory PhotoResponse.fromJson(Map<String, Object?> json) => _$PhotoResponseFromJson(json);
  
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'file_path')
  final String filePath;
  @JsonKey(name: 'file_size')
  final int fileSize;
  @JsonKey(name: 'mime_type')
  final String mimeType;
  final int? width;
  final int? height;
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$PhotoResponseToJson(this);
}
