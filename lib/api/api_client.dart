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
import 'admin/admin_client.dart';

/// Twin Finder Backend `v1.0.0`.
///
///
///         # TwinFinder Backend API.
///        
///         A comprehensive API for the TwinFinder social app that uses facial recognition technology .
///         to match users with their closest visual doppelgängers.
///        
///         ## 🔐 Authentication.
///        
///         The API uses JWT-based authentication with access and refresh tokens:.
///        
///         - **Access Tokens**: Short-lived tokens (1 hour) for API authentication.
///         - **Refresh Tokens**: Long-lived tokens (7-30 days) for token renewal.
///         - **Token Rotation**: Refresh tokens are single-use and invalidated after use.
///        
///         ## 📚 API Documentation.
///        
///         - **Swagger UI**: Interactive API documentation at `/docs`.
///         - **ReDoc**: Alternative documentation at `/redoc`.
///         - **OpenAPI Schema**: Raw OpenAPI specification at `/api/v1/openapi.json`.
///        
///         ## 🚀 Quick Start.
///        
///         1. **Register**: Use `/api/v1/auth/register/initiate` and `/api/v1/auth/register/confirm`.
///         2. **Login**: Use `/api/v1/auth/login` to get JWT tokens.
///         3. **Authenticate**: Include `Authorization: Bearer <access_token>` in requests.
///         4. **Refresh**: Use `/api/v1/auth/refresh` to get new tokens.
///         5. **Logout**: Use `/api/v1/auth/logout` to invalidate tokens.
///        
///         ## 🔒 Security Features.
///        
///         - JWT-based authentication with secure token handling.
///         - Rate limiting on API endpoints.
///         - CORS protection with configurable origins.
///         - Input validation with Pydantic schemas.
///         - Secure file upload handling.
///         - GDPR compliance features.
///        
///         ## 📊 Rate Limiting.
///        
///         API endpoints are rate-limited to prevent abuse:.
///        
///         - Authentication endpoints: 5 requests per minute.
///         - General endpoints: 100 requests per minute.
///         - File uploads: 10 requests per minute.
///        
///         ## 🛠️ Development.
///        
///         - **Environment**: Set `ENVIRONMENT=development` for detailed error messages.
///         - **Logging**: Structured logging with configurable levels.
///         - **Health Check**: Use `/health` to check API status.
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
  AdminClient? _admin;

  FallbackClient get fallback => _fallback ??= FallbackClient(_dio, baseUrl: _baseUrl);

  AuthenticationClient get authentication => _authentication ??= AuthenticationClient(_dio, baseUrl: _baseUrl);

  UsersClient get users => _users ??= UsersClient(_dio, baseUrl: _baseUrl);

  PhotosClient get photos => _photos ??= PhotosClient(_dio, baseUrl: _baseUrl);

  MatchesClient get matches => _matches ??= MatchesClient(_dio, baseUrl: _baseUrl);

  ReferralClient get referral => _referral ??= ReferralClient(_dio, baseUrl: _baseUrl);

  AdminClient get admin => _admin ??= AdminClient(_dio, baseUrl: _baseUrl);
}
