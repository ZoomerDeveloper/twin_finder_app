// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_click_request.g.dart';

/// Request for tracking a referral click.
@JsonSerializable()
class ReferralClickRequest {
  const ReferralClickRequest({
    required this.referralCode,
    this.source,
    this.userAgent,
    this.ipAddress,
  });
  
  factory ReferralClickRequest.fromJson(Map<String, Object?> json) => _$ReferralClickRequestFromJson(json);
  
  /// The referral code that was clicked
  @JsonKey(name: 'referral_code')
  final String referralCode;

  /// Source platform (whatsapp, telegram, etc.)
  final String? source;

  /// User agent string for device detection
  @JsonKey(name: 'user_agent')
  final String? userAgent;

  /// IP address of the clicker
  @JsonKey(name: 'ip_address')
  final String? ipAddress;

  Map<String, Object?> toJson() => _$ReferralClickRequestToJson(this);
}
