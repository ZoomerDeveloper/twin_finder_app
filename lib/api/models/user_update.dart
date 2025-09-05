// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'user_update.g.dart';

/// Payload for updating user profile fields.
@JsonSerializable()
class UserUpdate {
  const UserUpdate({
    this.password,
    this.name,
    this.birthday,
    this.gender,
    this.country,
    this.city,
  });
  
  factory UserUpdate.fromJson(Map<String, Object?> json) => _$UserUpdateFromJson(json);
  
  /// User password
  final String? password;
  final String? name;
  final DateTime? birthday;

  /// male, female, other, prefer_not_to_say
  final String? gender;
  final String? country;
  final String? city;

  Map<String, Object?> toJson() => _$UserUpdateToJson(this);
}
