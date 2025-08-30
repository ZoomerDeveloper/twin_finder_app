// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'o_auth_provider_info.g.dart';

/// OAuth provider information schema.
@JsonSerializable()
class OAuthProviderInfo {
  const OAuthProviderInfo({
    required this.provider,
    required this.clientId,
    required this.redirectUri,
    required this.scope,
    required this.authUrl,
    this.name,
  });
  
  factory OAuthProviderInfo.fromJson(Map<String, Object?> json) => _$OAuthProviderInfoFromJson(json);
  
  /// OAuth provider name (google, apple)
  final String provider;

  /// OAuth client ID
  @JsonKey(name: 'client_id')
  final String clientId;

  /// OAuth redirect URI
  @JsonKey(name: 'redirect_uri')
  final String redirectUri;

  /// OAuth scope
  final String scope;

  /// OAuth authorization URL
  @JsonKey(name: 'auth_url')
  final String authUrl;

  /// Human-friendly provider name
  final String? name;

  Map<String, Object?> toJson() => _$OAuthProviderInfoToJson(this);
}
