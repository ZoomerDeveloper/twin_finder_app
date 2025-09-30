// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';

import 'fallback/fallback_client.dart';
import 'authentication/authentication_client.dart';
import 'users/users_client.dart';
import 'photos/photos_client.dart';
import 'matches/matches_client.dart';
import 'referral/referral_client.dart';
import 'locations/locations_client.dart';
import 'system/system_client.dart';
import 'admin/admin_client.dart';

/// TwinFinder API `v1.0.0`.
///
/// Production-grade REST API powering TwinFinder.
///
/// - Authentication: Email + Social (Google/Apple via Firebase).
/// - Users & Profiles: creation, updates, verification.
/// - Photos & Matches: uploads, matching, statistics.
/// - Operational: health, metrics, rate limits.
///
class ApiClient {
  ApiClient(
    Dio dio, {
    String? baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  FallbackClient? _fallback;
  AuthenticationClient? _authentication;
  UsersClient? _users;
  PhotosClient? _photos;
  MatchesClient? _matches;
  ReferralClient? _referral;
  LocationsClient? _locations;
  SystemClient? _system;
  AdminClient? _admin;

  FallbackClient get fallback => _fallback ??= FallbackClient(_dio, baseUrl: _baseUrl);

  AuthenticationClient get authentication => _authentication ??= AuthenticationClient(_dio, baseUrl: _baseUrl);

  UsersClient get users => _users ??= UsersClient(_dio, baseUrl: _baseUrl);

  PhotosClient get photos => _photos ??= PhotosClient(_dio, baseUrl: _baseUrl);

  MatchesClient get matches => _matches ??= MatchesClient(_dio, baseUrl: _baseUrl);

  ReferralClient get referral => _referral ??= ReferralClient(_dio, baseUrl: _baseUrl);

  LocationsClient get locations => _locations ??= LocationsClient(_dio, baseUrl: _baseUrl);

  SystemClient get system => _system ??= SystemClient(_dio, baseUrl: _baseUrl);

  AdminClient get admin => _admin ??= AdminClient(_dio, baseUrl: _baseUrl);
}
