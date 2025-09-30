// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_code_validation_response.g.dart';

/// Response for referral code validation.
@JsonSerializable()
class ReferralCodeValidationResponse {
  const ReferralCodeValidationResponse({
    required this.isValid,
    required this.message,
  });

  factory ReferralCodeValidationResponse.fromJson(Map<String, Object?> json) => _$ReferralCodeValidationResponseFromJson(json);

  /// Whether the code is valid
  @JsonKey(name: 'is_valid')
  final bool isValid;

  /// Validation message
  final String message;

  Map<String, Object?> toJson() => _$ReferralCodeValidationResponseToJson(this);
}
