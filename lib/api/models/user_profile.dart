// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// Public user profile information returned by the API.
@JsonSerializable()
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isVerified,
    required this.profileCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.birthday,
    this.gender,
    this.country,
    this.city,
    this.profilePhotoUrl,
  });
  
  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);
  
  /// User ID (UUID)
  final String id;

  /// User email address
  final String? email;

  /// User full name
  final String name;

  /// User birthday (YYYY-MM-DD)
  final DateTime? birthday;

  /// Gender: male, female, other, prefer_not_to_say
  final String? gender;

  /// Country name
  final String? country;

  /// City name
  final String? city;

  /// URL to profile photo
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;

  /// Account active status
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Email verification status
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  /// Profile completion status
  @JsonKey(name: 'profile_completed')
  final bool profileCompleted;

  /// Account creation timestamp
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last update timestamp
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Map<String, Object?> toJson() => _$UserProfileToJson(this);
}
