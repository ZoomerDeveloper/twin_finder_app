// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_click_response.g.dart';

/// Response for referral click tracking.
@JsonSerializable()
class ReferralClickResponse {
  const ReferralClickResponse({
    required this.success,
    required this.message,
    this.referralId,
    this.appStoreUrl,
    this.platform,
  });
  
  factory ReferralClickResponse.fromJson(Map<String, Object?> json) => _$ReferralClickResponseFromJson(json);
  
  /// Whether tracking was successful
  final bool success;

  /// ID of the created referral record
  @JsonKey(name: 'referral_id')
  final String? referralId;

  /// App store URL for device redirect
  @JsonKey(name: 'app_store_url')
  final String? appStoreUrl;

  /// Detected platform (ios, android, web)
  final String? platform;

  /// Response message
  final String message;

  Map<String, Object?> toJson() => _$ReferralClickResponseToJson(this);
}
