// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_link_response.g.dart';

/// Response for referral link generation.
@JsonSerializable()
class ReferralLinkResponse {
  const ReferralLinkResponse({
    required this.referralCode,
    required this.referralUrl,
    required this.deviceInfo,
    required this.socialPlatforms,
  });
  
  factory ReferralLinkResponse.fromJson(Map<String, Object?> json) => _$ReferralLinkResponseFromJson(json);
  
  /// User's referral code
  @JsonKey(name: 'referral_code')
  final String referralCode;

  /// Complete referral URL with tracking parameters
  @JsonKey(name: 'referral_url')
  final String referralUrl;

  /// Device-specific app store URLs
  @JsonKey(name: 'device_info')
  final dynamic deviceInfo;

  /// Available social platforms
  @JsonKey(name: 'social_platforms')
  final Map<String, String> socialPlatforms;

  Map<String, Object?> toJson() => _$ReferralLinkResponseToJson(this);
}
