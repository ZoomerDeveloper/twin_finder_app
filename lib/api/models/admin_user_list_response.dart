// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_user_profile.dart';

part 'admin_user_list_response.g.dart';

/// Response model for admin user list.
@JsonSerializable()
class AdminUserListResponse {
  const AdminUserListResponse({
    required this.users,
    required this.total,
    required this.page,
    required this.perPage,
  });
  
  factory AdminUserListResponse.fromJson(Map<String, Object?> json) => _$AdminUserListResponseFromJson(json);
  
  /// List of users
  final List<AdminUserProfile> users;

  /// Total number of users
  final int total;

  /// Current page number
  final int page;

  /// Number of items per page
  @JsonKey(name: 'per_page')
  final int perPage;

  Map<String, Object?> toJson() => _$AdminUserListResponseToJson(this);
}
