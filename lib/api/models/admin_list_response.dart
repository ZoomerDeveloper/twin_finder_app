// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_user_response.dart';

part 'admin_list_response.g.dart';

/// Response model for admin user list.
@JsonSerializable()
class AdminListResponse {
  const AdminListResponse({
    required this.admins,
    required this.total,
    required this.page,
    required this.perPage,
  });
  
  factory AdminListResponse.fromJson(Map<String, Object?> json) => _$AdminListResponseFromJson(json);
  
  /// List of admin users
  final List<AdminUserResponse> admins;

  /// Total number of admin users
  final int total;

  /// Current page number
  final int page;

  /// Number of items per page
  @JsonKey(name: 'per_page')
  final int perPage;

  Map<String, Object?> toJson() => _$AdminListResponseToJson(this);
}
