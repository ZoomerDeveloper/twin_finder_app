// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_user_profile.g.dart';

/// Admin view of user profile with additional admin fields.
@JsonSerializable()
class AdminUserProfile {
  const AdminUserProfile({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isVerified,
    required this.gdprConsent,
    required this.referralCount,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.birthday,
    this.gender,
    this.country,
    this.city,
    this.profilePhotoUrl,
    this.lastPhotoUpdate,
  });
  
  factory AdminUserProfile.fromJson(Map<String, Object?> json) => _$AdminUserProfileFromJson(json);
  
  /// User ID
  final String id;

  /// User email
  final String? email;

  /// User name
  final String name;

  /// User birthday
  final DateTime? birthday;

  /// User gender
  final String? gender;

  /// User country
  final String? country;

  /// User city
  final String? city;

  /// Profile photo URL
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;

  /// Account active status
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Email verification status
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  /// GDPR consent status
  @JsonKey(name: 'gdpr_consent')
  final bool gdprConsent;

  /// Number of referrals
  @JsonKey(name: 'referral_count')
  final int referralCount;

  /// Account creation timestamp
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last update timestamp
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Last photo update
  @JsonKey(name: 'last_photo_update')
  final DateTime? lastPhotoUpdate;

  Map<String, Object?> toJson() => _$AdminUserProfileToJson(this);
}
