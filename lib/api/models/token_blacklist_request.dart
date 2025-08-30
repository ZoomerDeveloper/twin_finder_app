// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'token_blacklist_request.g.dart';

/// Token blacklist request schema.
@JsonSerializable()
class TokenBlacklistRequest {
  const TokenBlacklistRequest({
    required this.token,
    this.reason,
  });
  
  factory TokenBlacklistRequest.fromJson(Map<String, Object?> json) => _$TokenBlacklistRequestFromJson(json);
  
  /// Token to blacklist
  final String token;

  /// Reason for blacklisting
  final String? reason;

  Map<String, Object?> toJson() => _$TokenBlacklistRequestToJson(this);
}
