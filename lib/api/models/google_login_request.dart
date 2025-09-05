// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'google_login_request.g.dart';

/// Google Firebase Authentication login request schema.
@JsonSerializable()
class GoogleLoginRequest {
  const GoogleLoginRequest({
    required this.idToken,
    this.name,
    this.birthday,
    this.gender,
    this.country,
    this.city,
  });
  
  factory GoogleLoginRequest.fromJson(Map<String, Object?> json) => _$GoogleLoginRequestFromJson(json);
  
  /// Firebase ID token from Google sign-in
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

  Map<String, Object?> toJson() => _$GoogleLoginRequestToJson(this);
}
