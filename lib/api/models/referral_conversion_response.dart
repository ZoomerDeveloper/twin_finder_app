// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_conversion_response.g.dart';

/// Response for referral conversion.
@JsonSerializable()
class ReferralConversionResponse {
  const ReferralConversionResponse({
    required this.success,
    required this.message,
  });

  factory ReferralConversionResponse.fromJson(Map<String, Object?> json) => _$ReferralConversionResponseFromJson(json);

  /// Whether conversion was successful
  final bool success;

  /// Response message
  final String message;

  Map<String, Object?> toJson() => _$ReferralConversionResponseToJson(this);
}
