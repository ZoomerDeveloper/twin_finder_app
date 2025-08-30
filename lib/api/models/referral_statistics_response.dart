// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_statistics_response.g.dart';

/// Response for referral statistics.
@JsonSerializable()
class ReferralStatisticsResponse {
  const ReferralStatisticsResponse({
    required this.totalReferrals,
    required this.convertedReferrals,
    required this.conversionRate,
    required this.recentReferrals,
    required this.referralCode,
    required this.sourceStats,
  });
  
  factory ReferralStatisticsResponse.fromJson(Map<String, Object?> json) => _$ReferralStatisticsResponseFromJson(json);
  
  /// Total number of referrals
  @JsonKey(name: 'total_referrals')
  final int totalReferrals;

  /// Number of converted referrals
  @JsonKey(name: 'converted_referrals')
  final int convertedReferrals;

  /// Conversion rate percentage
  @JsonKey(name: 'conversion_rate')
  final num conversionRate;

  /// Referrals in the last 30 days
  @JsonKey(name: 'recent_referrals')
  final int recentReferrals;

  /// User's referral code
  @JsonKey(name: 'referral_code')
  final String referralCode;

  /// Statistics by source
  @JsonKey(name: 'source_stats')
  final List<dynamic> sourceStats;

  Map<String, Object?> toJson() => _$ReferralStatisticsResponseToJson(this);
}
