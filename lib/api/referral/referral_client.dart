// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/device_info_response.dart';
import '../models/referral_click_request.dart';
import '../models/referral_click_response.dart';
import '../models/referral_code_validation_request.dart';
import '../models/referral_code_validation_response.dart';
import '../models/referral_conversion_request.dart';
import '../models/referral_conversion_response.dart';
import '../models/referral_dashboard_response.dart';
import '../models/referral_history_response.dart';
import '../models/referral_link_request.dart';
import '../models/referral_link_response.dart';
import '../models/referral_statistics_response.dart';

part 'referral_client.g.dart';

@RestApi()
abstract class ReferralClient {
  factory ReferralClient(Dio dio, {String? baseUrl}) = _ReferralClient;

  /// Generate Referral Link.
  ///
  /// Generate a referral link for the current user.
  ///
  /// Creates a referral link with tracking parameters and device-specific redirects.
  @POST('/api/v1/referral/referral-link')
  Future<ReferralLinkResponse> generateReferralLinkApiV1ReferralReferralLinkPost({
    @Body() required ReferralLinkRequest body,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Referral Link Endpoint.
  ///
  /// Get the current user's referral link.
  ///
  /// Returns the user's referral link with optional source parameter.
  @GET('/api/v1/referral/referral-link')
  Future<ReferralLinkResponse> getReferralLinkEndpointApiV1ReferralReferralLinkGet({
    @Query('source') String? source,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Track Referral Click.
  ///
  /// Track a referral link click.
  ///
  /// Records a referral click and returns device-specific app store URL.
  @POST('/api/v1/referral/track-click')
  Future<ReferralClickResponse> trackReferralClickApiV1ReferralTrackClickPost({
    @Body() required ReferralClickRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Handle Referral Redirect.
  ///
  /// Handle referral link redirects.
  ///
  /// Tracks the click and redirects to the appropriate app store based on device.
  @GET('/api/v1/referral/ref/{referral_code}')
  Future<void> handleReferralRedirectApiV1ReferralRefReferralCodeGet({
    @Path('referral_code') required String referralCode,
    @Query('source') String? source,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Referral Statistics Endpoint.
  ///
  /// Get referral statistics for the current user.
  ///
  /// Returns comprehensive statistics including conversion rates and source breakdown.
  @GET('/api/v1/referral/stats')
  Future<ReferralStatisticsResponse> getReferralStatisticsEndpointApiV1ReferralStatsGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Referral History Endpoint.
  ///
  /// Get referral history for the current user.
  ///
  /// Returns a list of referral records with conversion details.
  @GET('/api/v1/referral/history')
  Future<ReferralHistoryResponse> getReferralHistoryEndpointApiV1ReferralHistoryGet({
    @Query('token') String? token,
    @Query('limit') int? limit = 50,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Convert Referral Endpoint.
  ///
  /// Convert a referral click to a successful referral.
  ///
  /// This endpoint is typically called when a referred user signs up.
  @POST('/api/v1/referral/convert')
  Future<ReferralConversionResponse> convertReferralEndpointApiV1ReferralConvertPost({
    @Body() required ReferralConversionRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Validate Referral Code Endpoint.
  ///
  /// Validate a referral code.
  ///
  /// Checks if a referral code exists and is valid.
  @POST('/api/v1/referral/validate-code')
  Future<ReferralCodeValidationResponse> validateReferralCodeEndpointApiV1ReferralValidateCodePost({
    @Body() required ReferralCodeValidationRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Detect Device Endpoint.
  ///
  /// Detect device type from user agent string.
  ///
  /// Returns detailed device information and appropriate app store URL.
  @POST('/api/v1/referral/detect-device')
  Future<DeviceInfoResponse> detectDeviceEndpointApiV1ReferralDetectDevicePost({
    @Body() required dynamic body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Referral Dashboard.
  ///
  /// Get comprehensive referral dashboard data.
  ///
  /// Returns statistics, recent history, and platform information in one call.
  @GET('/api/v1/referral/dashboard')
  Future<ReferralDashboardResponse> getReferralDashboardApiV1ReferralDashboardGet({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Referral Health Check.
  ///
  /// Health check endpoint for referral system.
  ///
  /// Returns basic health information about the referral service.
  @GET('/api/v1/referral/health')
  Future<dynamic> referralHealthCheckApiV1ReferralHealthGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
