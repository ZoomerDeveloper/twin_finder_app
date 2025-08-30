// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'referral_history_item.dart';

part 'referral_history_response.g.dart';

/// Response for referral history.
@JsonSerializable()
class ReferralHistoryResponse {
  const ReferralHistoryResponse({
    required this.referrals,
    required this.totalCount,
    required this.limit,
  });
  
  factory ReferralHistoryResponse.fromJson(Map<String, Object?> json) => _$ReferralHistoryResponseFromJson(json);
  
  /// List of referral records
  final List<ReferralHistoryItem> referrals;

  /// Total number of referrals
  @JsonKey(name: 'total_count')
  final int totalCount;

  /// Maximum number of records returned
  final int limit;

  Map<String, Object?> toJson() => _$ReferralHistoryResponseToJson(this);
}
