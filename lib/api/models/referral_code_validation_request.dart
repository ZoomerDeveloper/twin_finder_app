// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_code_validation_request.g.dart';

/// Request for validating a referral code.
@JsonSerializable()
class ReferralCodeValidationRequest {
  const ReferralCodeValidationRequest({
    required this.code,
  });
  
  factory ReferralCodeValidationRequest.fromJson(Map<String, Object?> json) => _$ReferralCodeValidationRequestFromJson(json);
  
  /// Referral code to validate
  final String code;

  Map<String, Object?> toJson() => _$ReferralCodeValidationRequestToJson(this);
}
