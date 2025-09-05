// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'apple_login_request.g.dart';

/// Apple Firebase Authentication login request schema.
@JsonSerializable()
class AppleLoginRequest {
  const AppleLoginRequest({
    required this.idToken,
    this.name,
    this.birthday,
    this.gender,
    this.country,
    this.city,
  });
  
  factory AppleLoginRequest.fromJson(Map<String, Object?> json) => _$AppleLoginRequestFromJson(json);
  
  /// Firebase ID token from Apple sign-in
  @JsonKey(name: 'id_token')
  final String idToken;

  /// User name
  final String? name;

  /// User birthday (YYYY-MM-DD)
  final DateTime? birthday;

  /// User gender
  final String? gender;

  /// User country
  final String? country;

  /// User city
  final String? city;

  Map<String, Object?> toJson() => _$AppleLoginRequestToJson(this);
}
