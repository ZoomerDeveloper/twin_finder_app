// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'referral_link_request.g.dart';

/// Request for generating a referral link.
@JsonSerializable()
class ReferralLinkRequest {
  const ReferralLinkRequest({
    this.source,
    this.utmParams,
  });
  
  factory ReferralLinkRequest.fromJson(Map<String, Object?> json) => _$ReferralLinkRequestFromJson(json);
  
  /// Source platform (whatsapp, telegram, instagram, etc.)
  final String? source;

  /// Additional UTM parameters for tracking
  @JsonKey(name: 'utm_params')
  final Map<String, String>? utmParams;

  Map<String, Object?> toJson() => _$ReferralLinkRequestToJson(this);
}
