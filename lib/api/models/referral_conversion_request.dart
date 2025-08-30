// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_conversion_request.g.dart';

/// Request for converting a referral.
@JsonSerializable()
class ReferralConversionRequest {
  const ReferralConversionRequest({
    required this.referralId,
    required this.referredUserId,
  });
  
  factory ReferralConversionRequest.fromJson(Map<String, Object?> json) => _$ReferralConversionRequestFromJson(json);
  
  /// ID of the referral record to convert
  @JsonKey(name: 'referral_id')
  final String referralId;

  /// ID of the user who signed up
  @JsonKey(name: 'referred_user_id')
  final String referredUserId;

  Map<String, Object?> toJson() => _$ReferralConversionRequestToJson(this);
}
