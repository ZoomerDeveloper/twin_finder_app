// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'app_schemas_referral_social_platform_info.dart';
import 'referral_history_item.dart';
import 'referral_statistics_response.dart';

part 'referral_dashboard_response.g.dart';

/// Comprehensive referral dashboard response.
@JsonSerializable()
class ReferralDashboardResponse {
  const ReferralDashboardResponse({
    required this.statistics,
    required this.recentHistory,
    required this.availablePlatforms,
    required this.referralLink,
    required this.referralCode,
  });
  
  factory ReferralDashboardResponse.fromJson(Map<String, Object?> json) => _$ReferralDashboardResponseFromJson(json);
  
  /// Referral statistics
  final ReferralStatisticsResponse statistics;

  /// Recent referral history
  @JsonKey(name: 'recent_history')
  final List<ReferralHistoryItem> recentHistory;

  /// Available social platforms
  @JsonKey(name: 'available_platforms')
  final List<AppSchemasReferralSocialPlatformInfo> availablePlatforms;

  /// User's referral link
  @JsonKey(name: 'referral_link')
  final String referralLink;

  /// User's referral code
  @JsonKey(name: 'referral_code')
  final String referralCode;

  Map<String, Object?> toJson() => _$ReferralDashboardResponseToJson(this);
}
