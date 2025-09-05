// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/user_profile_response.dart';
import '../models/user_update.dart';

part 'users_client.g.dart';

@RestApi()
abstract class UsersClient {
  factory UsersClient(Dio dio, {String? baseUrl}) = _UsersClient;

  /// Get My Profile.
  ///
  /// Retrieve the current authenticated user's profile information.
  ///            
  ///             This endpoint returns the complete profile data for the currently.
  ///             authenticated user, including personal information, preferences,.
  ///             and account status.
  ///            
  ///             **Authentication Required**: Valid JWT access token in Authorization header.
  ///             **Rate Limiting**: 100 requests per minute.
  @GET('/api/v1/users/me')
  Future<UserProfileResponse> getMyProfileApiV1UsersMeGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Update My Profile.
  ///
  /// Update the current authenticated user's profile information.
  ///            
  ///             This endpoint allows users to modify their profile data including.
  ///             personal information, bio, and preferences. All fields are optional.
  ///             and only provided fields will be updated.
  ///            
  ///             **Authentication Required**: Valid JWT access token in Authorization header.
  ///             **Rate Limiting**: 10 requests per minute.
  @PUT('/api/v1/users/me')
  Future<UserProfileResponse> updateMyProfileApiV1UsersMePut({
    @Body() required UserUpdate body,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Delete My Account (GDPR).
  ///
  /// Permanently delete the current user's account and all associated data.
  ///               
  ///                This endpoint completely removes the user's account, profile, photos,.
  ///                matches, and all related data from the system. This action is.
  ///                irreversible and complies with GDPR right to erasure requirements.
  ///               
  ///                **⚠️ WARNING: This action is irreversible!**.
  ///               
  ///                **GDPR Compliance:**.
  ///                - Complete data deletion (right to erasure).
  ///                - Audit logging of deletion requests.
  ///                - Removal of all personal data.
  ///                - File system cleanup.
  ///               
  ///                **Authentication Required**: Valid JWT access token in Authorization header.
  ///                **Rate Limiting**: 1 request per hour.
  @DELETE('/api/v1/users/me')
  Future<dynamic> deleteMyAccountApiV1UsersMeDelete({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Export My Data (GDPR).
  ///
  /// Export all personal data for the current user in compliance with GDPR.
  ///            
  ///             This endpoint provides a complete export of all user data including.
  ///             profile information, photos, matches, and activity logs. The data.
  ///             is returned in a structured JSON format suitable for data portability.
  ///            
  ///             **GDPR Compliance:**.
  ///             - Complete data export for data portability.
  ///             - Audit logging of export requests.
  ///             - Structured data format.
  ///             - All personal data included.
  ///            
  ///             **Authentication Required**: Valid JWT access token in Authorization header.
  ///             **Rate Limiting**: 5 requests per hour.
  @GET('/api/v1/users/gdpr-data')
  Future<dynamic> exportMyDataApiV1UsersGdprDataGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
