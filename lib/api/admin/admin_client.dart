// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_create_request.dart';
import '../models/admin_list_response.dart';
import '../models/admin_login_request.dart';
import '../models/admin_login_response.dart';
import '../models/admin_logout_request.dart';
import '../models/admin_match_list_response.dart';
import '../models/admin_match_response.dart';
import '../models/admin_match_update_request.dart';
import '../models/admin_password_change_request.dart';
import '../models/admin_refresh_token_request.dart';
import '../models/admin_token.dart';
import '../models/admin_update_request.dart';
import '../models/admin_user_ban_request.dart';
import '../models/admin_user_list_response.dart';
import '../models/admin_user_profile.dart';
import '../models/admin_user_response.dart';
import '../models/admin_user_update_request.dart';
import '../models/content_moderation_action.dart';
import '../models/content_report.dart';
import '../models/content_report_list_response.dart';
import '../models/content_report_update_request.dart';
import '../models/platform_stats.dart';
import '../models/user_activity_stats.dart';

part 'admin_client.g.dart';

@RestApi()
abstract class AdminClient {
  factory AdminClient(Dio dio, {String? baseUrl}) = _AdminClient;

  /// Admin Login.
  ///
  /// Admin login endpoint.
  @POST('/api/v1/admin/login')
  Future<AdminLoginResponse> adminLoginApiV1AdminLoginPost({
    @Body() required AdminLoginRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Admin Refresh Token.
  ///
  /// Refresh admin access token.
  @POST('/api/v1/admin/refresh')
  Future<AdminToken> adminRefreshTokenApiV1AdminRefreshPost({
    @Body() required AdminRefreshTokenRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Admin Logout.
  ///
  /// Admin logout endpoint.
  @POST('/api/v1/admin/logout')
  Future<void> adminLogoutApiV1AdminLogoutPost({
    @Body() required AdminLogoutRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Current Admin Info.
  ///
  /// Get current admin information.
  @GET('/api/v1/admin/me')
  Future<AdminUserResponse> getCurrentAdminInfoApiV1AdminMeGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Change Admin Password.
  ///
  /// Change admin password.
  @POST('/api/v1/admin/change-password')
  Future<void> changeAdminPasswordApiV1AdminChangePasswordPost({
    @Body() required AdminPasswordChangeRequest body,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Create Admin.
  ///
  /// Create a new admin user.
  @POST('/api/v1/admin/admins')
  Future<AdminUserResponse> createAdminApiV1AdminAdminsPost({
    @Body() required AdminCreateRequest body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// List Admins.
  ///
  /// List all admin users.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Items per page.
  @GET('/api/v1/admin/admins')
  Future<AdminListResponse> listAdminsApiV1AdminAdminsGet({
    @Query('token') String? token,
    @Query('page') int? page = 1,
    @Query('per_page') int? perPage = 20,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Admin.
  ///
  /// Get admin by ID.
  @GET('/api/v1/admin/admins/{admin_id}')
  Future<AdminUserResponse> getAdminApiV1AdminAdminsAdminIdGet({
    @Path('admin_id') required String adminId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Update Admin.
  ///
  /// Update admin user.
  @PUT('/api/v1/admin/admins/{admin_id}')
  Future<AdminUserResponse> updateAdminApiV1AdminAdminsAdminIdPut({
    @Path('admin_id') required String adminId,
    @Body() required AdminUpdateRequest body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Delete Admin.
  ///
  /// Delete (deactivate) admin user.
  @DELETE('/api/v1/admin/admins/{admin_id}')
  Future<void> deleteAdminApiV1AdminAdminsAdminIdDelete({
    @Path('admin_id') required String adminId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Activate Admin.
  ///
  /// Activate admin user.
  @POST('/api/v1/admin/admins/{admin_id}/activate')
  Future<void> activateAdminApiV1AdminAdminsAdminIdActivatePost({
    @Path('admin_id') required String adminId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// List Users.
  ///
  /// List all users with optional filtering.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Items per page.
  ///
  /// [search] - Search by name, email, or city.
  ///
  /// [isActive] - Filter by active status.
  ///
  /// [isVerified] - Filter by verification status.
  ///
  /// [country] - Filter by country.
  @GET('/api/v1/admin/users')
  Future<AdminUserListResponse> listUsersApiV1AdminUsersGet({
    @Query('search') String? search,
    @Query('is_active') bool? isActive,
    @Query('is_verified') bool? isVerified,
    @Query('country') String? country,
    @Query('token') String? token,
    @Query('page') int? page = 1,
    @Query('per_page') int? perPage = 20,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get User.
  ///
  /// Get user by ID for admin view.
  @GET('/api/v1/admin/users/{user_id}')
  Future<AdminUserProfile> getUserApiV1AdminUsersUserIdGet({
    @Path('user_id') required String userId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Update User.
  ///
  /// Update user data by admin.
  @PUT('/api/v1/admin/users/{user_id}')
  Future<AdminUserProfile> updateUserApiV1AdminUsersUserIdPut({
    @Path('user_id') required String userId,
    @Body() required AdminUserUpdateRequest body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Ban User.
  ///
  /// Ban a user.
  @POST('/api/v1/admin/users/{user_id}/ban')
  Future<void> banUserApiV1AdminUsersUserIdBanPost({
    @Path('user_id') required String userId,
    @Body() required AdminUserBanRequest body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Unban User.
  ///
  /// Unban a user.
  @POST('/api/v1/admin/users/{user_id}/unban')
  Future<void> unbanUserApiV1AdminUsersUserIdUnbanPost({
    @Path('user_id') required String userId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Platform Stats.
  ///
  /// Get comprehensive platform statistics.
  @GET('/api/v1/admin/stats/platform')
  Future<PlatformStats> getPlatformStatsApiV1AdminStatsPlatformGet({
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get User Activity Stats.
  ///
  /// Get user activity statistics.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Items per page.
  @GET('/api/v1/admin/stats/user-activity')
  Future<List<UserActivityStats>> getUserActivityStatsApiV1AdminStatsUserActivityGet({
    @Query('token') String? token,
    @Query('page') int? page = 1,
    @Query('per_page') int? perPage = 50,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// List Matches.
  ///
  /// List all matches with optional filtering.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Items per page.
  ///
  /// [userId] - Filter by user ID.
  ///
  /// [minSimilarity] - Minimum similarity score.
  ///
  /// [maxSimilarity] - Maximum similarity score.
  ///
  /// [isViewed] - Filter by viewed status.
  @GET('/api/v1/admin/matches')
  Future<AdminMatchListResponse> listMatchesApiV1AdminMatchesGet({
    @Query('user_id') String? userId,
    @Query('min_similarity') num? minSimilarity,
    @Query('max_similarity') num? maxSimilarity,
    @Query('is_viewed') bool? isViewed,
    @Query('token') String? token,
    @Query('page') int? page = 1,
    @Query('per_page') int? perPage = 20,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Match.
  ///
  /// Get match by ID for admin view.
  @GET('/api/v1/admin/matches/{match_id}')
  Future<AdminMatchResponse> getMatchApiV1AdminMatchesMatchIdGet({
    @Path('match_id') required String matchId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Update Match.
  ///
  /// Update match data by admin.
  @PUT('/api/v1/admin/matches/{match_id}')
  Future<AdminMatchResponse> updateMatchApiV1AdminMatchesMatchIdPut({
    @Path('match_id') required String matchId,
    @Body() required AdminMatchUpdateRequest body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Delete Match.
  ///
  /// Delete a match by admin.
  @DELETE('/api/v1/admin/matches/{match_id}')
  Future<void> deleteMatchApiV1AdminMatchesMatchIdDelete({
    @Path('match_id') required String matchId,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// List Content Reports.
  ///
  /// List content reports for moderation.
  ///
  /// [page] - Page number.
  ///
  /// [perPage] - Items per page.
  ///
  /// [status] - Filter by report status.
  @GET('/api/v1/admin/moderation/reports')
  Future<ContentReportListResponse> listContentReportsApiV1AdminModerationReportsGet({
    @Query('status') String? status,
    @Query('token') String? token,
    @Query('page') int? page = 1,
    @Query('per_page') int? perPage = 20,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Update Content Report.
  ///
  /// Update content report status.
  @PUT('/api/v1/admin/moderation/reports/{report_id}')
  Future<ContentReport> updateContentReportApiV1AdminModerationReportsReportIdPut({
    @Path('report_id') required String reportId,
    @Body() required ContentReportUpdateRequest body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Take Moderation Action.
  ///
  /// Take moderation action against a user.
  @POST('/api/v1/admin/moderation/users/{user_id}/action')
  Future<void> takeModerationActionApiV1AdminModerationUsersUserIdActionPost({
    @Path('user_id') required String userId,
    @Body() required ContentModerationAction body,
    @Query('token') String? token,
    @Query('required_role') String? requiredRole = 'admin',
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
