// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'basic_message_response.g.dart';

/// Simple response schema without token data.
///
/// Use for endpoints like registration initiation that should not expose.
/// any authentication tokens in responses.
@JsonSerializable()
class BasicMessageResponse {
  const BasicMessageResponse({
    required this.success,
    required this.message,
  });

  factory BasicMessageResponse.fromJson(Map<String, Object?> json) => _$BasicMessageResponseFromJson(json);

  /// Whether the operation succeeded
  final bool success;

  /// Human-readable message
  final String message;

  Map<String, Object?> toJson() => _$BasicMessageResponseToJson(this);
}
