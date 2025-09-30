// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'twin_finder_schemas_referral_social_platform_info.g.dart';

/// Information about social platforms.
@JsonSerializable()
class TwinFinderSchemasReferralSocialPlatformInfo {
  const TwinFinderSchemasReferralSocialPlatformInfo({
    required this.platform,
    required this.name,
    this.shareUrlTemplate,
    this.iconUrl,
  });
  
  factory TwinFinderSchemasReferralSocialPlatformInfo.fromJson(Map<String, Object?> json) => _$TwinFinderSchemasReferralSocialPlatformInfoFromJson(json);
  
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

  Map<String, Object?> toJson() => _$TwinFinderSchemasReferralSocialPlatformInfoToJson(this);
}
