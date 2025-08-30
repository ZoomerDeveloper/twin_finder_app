// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_history_item.g.dart';

/// Individual referral history item.
@JsonSerializable()
class ReferralHistoryItem {
  const ReferralHistoryItem({
    required this.id,
    required this.referralCode,
    required this.clickedAt,
    required this.isConverted,
    this.source,
    this.convertedAt,
    this.conversionTime,
    this.referredUser,
  });
  
  factory ReferralHistoryItem.fromJson(Map<String, Object?> json) => _$ReferralHistoryItemFromJson(json);
  
  /// Referral record ID
  final String id;

  /// Referral code used
  @JsonKey(name: 'referral_code')
  final String referralCode;

  /// Source platform
  final String? source;

  /// Click timestamp (ISO format)
  @JsonKey(name: 'clicked_at')
  final String clickedAt;

  /// Conversion timestamp (ISO format)
  @JsonKey(name: 'converted_at')
  final String? convertedAt;

  /// Whether referral was converted
  @JsonKey(name: 'is_converted')
  final bool isConverted;

  /// Time to conversion in seconds
  @JsonKey(name: 'conversion_time')
  final num? conversionTime;

  /// Referred user information
  @JsonKey(name: 'referred_user')
  final Map<String, String>? referredUser;

  Map<String, Object?> toJson() => _$ReferralHistoryItemToJson(this);
}
