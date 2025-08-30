// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'app_schemas_referral_social_platform_info.g.dart';

/// Information about social platforms.
@JsonSerializable()
class AppSchemasReferralSocialPlatformInfo {
  const AppSchemasReferralSocialPlatformInfo({
    required this.platform,
    required this.name,
    this.shareUrlTemplate,
    this.iconUrl,
  });
  
  factory AppSchemasReferralSocialPlatformInfo.fromJson(Map<String, Object?> json) => _$AppSchemasReferralSocialPlatformInfoFromJson(json);
  
  /// Platform identifier
  final String platform;

  /// Platform display name
  final String name;

  /// Share URL template
  @JsonKey(name: 'share_url_template')
  final String? shareUrlTemplate;

  /// Platform icon URL
  @JsonKey(name: 'icon_url')
  final String? iconUrl;

  Map<String, Object?> toJson() => _$AppSchemasReferralSocialPlatformInfoToJson(this);
}
