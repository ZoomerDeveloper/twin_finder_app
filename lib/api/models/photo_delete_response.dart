// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'photo_delete_response.g.dart';

@JsonSerializable()
class PhotoDeleteResponse {
  const PhotoDeleteResponse({
    required this.success,
    required this.message,
  });
  
  factory PhotoDeleteResponse.fromJson(Map<String, Object?> json) => _$PhotoDeleteResponseFromJson(json);
  
  final bool success;
  final String message;

  Map<String, Object?> toJson() => _$PhotoDeleteResponseToJson(this);
}
