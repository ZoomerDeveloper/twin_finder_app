// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'user_profile.dart';

part 'user_profile_response.g.dart';

/// Standard envelope for profile responses.
@JsonSerializable()
class UserProfileResponse {
  const UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });
  
  factory UserProfileResponse.fromJson(Map<String, Object?> json) => _$UserProfileResponseFromJson(json);
  
  /// Operation success status
  final bool success;

  /// Human readable message
  final String message;

  /// User profile data
  final UserProfile data;

  Map<String, Object?> toJson() => _$UserProfileResponseToJson(this);
}
