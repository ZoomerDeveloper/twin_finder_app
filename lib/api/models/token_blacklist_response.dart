// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'token_blacklist_response.g.dart';

/// Token blacklist response schema.
@JsonSerializable()
class TokenBlacklistResponse {
  const TokenBlacklistResponse({
    required this.success,
    required this.message,
    this.blacklistedAt,
  });
  
  factory TokenBlacklistResponse.fromJson(Map<String, Object?> json) => _$TokenBlacklistResponseFromJson(json);
  
  /// Operation success status
  final bool success;

  /// Response message
  final String message;

  /// Blacklist timestamp
  @JsonKey(name: 'blacklisted_at')
  final DateTime? blacklistedAt;

  Map<String, Object?> toJson() => _$TokenBlacklistResponseToJson(this);
}
