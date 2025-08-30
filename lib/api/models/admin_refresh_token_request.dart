// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_refresh_token_request.g.dart';

/// Request model for refreshing admin tokens.
@JsonSerializable()
class AdminRefreshTokenRequest {
  const AdminRefreshTokenRequest({
    required this.refreshToken,
  });
  
  factory AdminRefreshTokenRequest.fromJson(Map<String, Object?> json) => _$AdminRefreshTokenRequestFromJson(json);
  
  /// Refresh token
  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  Map<String, Object?> toJson() => _$AdminRefreshTokenRequestToJson(this);
}
