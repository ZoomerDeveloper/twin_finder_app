// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/apple_login_request.dart';
import '../models/auth_response.dart';
import '../models/basic_message_response.dart';
import '../models/email_register_verify_request.dart';
import '../models/email_registration_confirm.dart';
import '../models/email_registration_request.dart';
import '../models/email_set_password_request.dart';
import '../models/email_verification_request.dart';
import '../models/google_login_request.dart';
import '../models/login_request.dart';
import '../models/logout_request.dart';
import '../models/o_auth_callback_request.dart';
import '../models/o_auth_provider_info.dart';
import '../models/password_reset_confirm.dart';
import '../models/password_reset_request.dart';
import '../models/refresh_token_request.dart';
import '../models/social_login_response.dart';
import '../models/token_blacklist_request.dart';
import '../models/token_blacklist_response.dart';
import '../models/user_auth_info.dart';
import '../models/verification_token_response.dart';

part 'authentication_client.g.dart';

@RestApi()
abstract class AuthenticationClient {
  factory AuthenticationClient(Dio dio, {String? baseUrl}) = _AuthenticationClient;

  /// Login.
  ///
  /// Authenticate user and return JWT tokens.
  ///
  /// This endpoint authenticates a user with their email and password, returning.
  /// JWT access and refresh tokens upon successful authentication.
  ///
  /// **Authentication Flow:**.
  /// 1. User provides email and password.
  /// 2. System validates credentials against database.
  /// 3. If valid, generates JWT tokens.
  /// 4. Returns tokens for subsequent API calls.
  ///
  /// **Security Features:**.
  /// - Password is hashed and compared securely.
  /// - JWT tokens have configurable expiration times.
  /// - Refresh tokens allow for token renewal without re-authentication.
  ///
  /// Args:.
  ///     login_data: Login credentials containing email and password.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Authentication response containing:.
  ///         - success: Boolean indicating operation success.
  ///         - message: Human-readable response message.
  ///         - data: Token object with access_token, refresh_token, and metadata.
  ///        
  /// Raises:.
  ///     HTTPException (401): If email or password is incorrect.
  ///     HTTPException (422): If request data validation fails.
  ///    
  /// Example Request:.
  ///     ```json.
  ///     {.
  ///         "email": "user@example.com",.
  ///         "password": "securepassword123".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Login successful",.
  ///         "data": {.
  ///             "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "token_type": "bearer",.
  ///             "expires_in": 3600.
  ///         }.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/login')
  Future<AuthResponse> login({
    @Body() required LoginRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Initiate Registration
  @POST('/api/v1/auth/register/email/initiate')
  Future<BasicMessageResponse> initiateRegistration({
    @Body() required EmailRegistrationRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Confirm Registration.
  ///
  /// Confirm email registration and create user account (Step 2 of 2).
  ///
  /// This endpoint completes the registration process by verifying the email.
  /// verification code and creating a basic user account. The user will need.
  /// to complete their profile with additional information before accessing.
  /// application features.
  ///
  /// **Registration Completion:**.
  /// 1. User provides email and verification code.
  /// 2. System validates verification code and expiration.
  /// 3. Basic user account is created (email verified).
  /// 4. JWT tokens are generated and returned.
  /// 5. User is automatically logged in but profile is incomplete.
  ///
  /// **Next Steps:**.
  /// - User must complete profile via PUT /api/v1/users/me.
  /// - Required fields: password, name, city, country, birth date, gender.
  /// - Profile completion is required before accessing app features.
  ///
  /// **Security Features:**.
  /// - Verification code validation and expiration check.
  /// - Automatic account activation.
  /// - GDPR consent tracking.
  /// - Profile completion tracking.
  ///
  /// Args:.
  ///     confirmation_data: EmailRegistrationConfirm containing:.
  ///         - email: Email address used in step 1.
  ///         - verification_code: 6-digit code sent via email.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Authentication response with JWT tokens.
  ///    
  /// Raises:.
  ///     HTTPException (400): If verification code is invalid.
  ///     HTTPException (400): If verification code has expired.
  ///     HTTPException (400): If email not found in pending registrations.
  ///     HTTPException (422): If request data validation fails.
  ///    
  /// Example Request:.
  ///     ```json.
  ///     {.
  ///         "email": "newuser@example.com",.
  ///         "verification_code": "123456".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Registration completed successfully! Please complete your profile.",.
  ///         "data": {.
  ///             "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "token_type": "bearer",.
  ///             "expires_in": 3600.
  ///         }.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/register/confirm')
  Future<AuthResponse> confirmRegistration({
    @Body() required EmailRegistrationConfirm body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Refresh Tokens.
  ///
  /// Refresh access token using refresh token.
  ///
  /// This endpoint allows users to obtain a new access token using their refresh token,.
  /// without requiring re-authentication. This is useful for maintaining user sessions.
  /// and providing seamless user experience.
  ///
  /// **Token Refresh Flow:**.
  /// 1. User provides their refresh token.
  /// 2. System validates the refresh token.
  /// 3. If valid, new access and refresh tokens are generated.
  /// 4. Old refresh token is invalidated (one-time use).
  ///
  /// **Security Features:**.
  /// - Refresh tokens are single-use (invalidated after use).
  /// - Automatic token rotation for enhanced security.
  /// - Refresh token expiration validation.
  /// - Blacklist checking for revoked tokens.
  ///
  /// **Use Cases:**.
  /// - Extending user sessions.
  /// - Automatic token renewal in mobile apps.
  /// - Maintaining user state across browser sessions.
  ///
  /// Args:.
  ///     refresh_data: RefreshTokenRequest containing:.
  ///         - refresh_token: Valid JWT refresh token.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Authentication response with new JWT tokens.
  ///    
  /// Raises:.
  ///     HTTPException (401): If refresh token is invalid or expired.
  ///     HTTPException (401): If refresh token is blacklisted.
  ///     HTTPException (422): If request data validation fails.
  ///    
  /// Example Request:.
  ///     ```json.
  ///     {.
  ///         "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Tokens refreshed successfully",.
  ///         "data": {.
  ///             "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "token_type": "bearer",.
  ///             "expires_in": 3600.
  ///         }.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/refresh')
  Future<AuthResponse> refreshTokens({
    @Body() required RefreshTokenRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Logout.
  ///
  /// Logout user by blacklisting refresh token.
  ///
  /// This endpoint securely logs out a user by blacklisting their refresh token,.
  /// preventing it from being used for future token refreshes. This ensures that.
  /// even if the refresh token is compromised, it cannot be used after logout.
  ///
  /// **Logout Flow:**.
  /// 1. User provides their refresh token.
  /// 2. System validates the refresh token.
  /// 3. Token is added to blacklist with logout reason.
  /// 4. User is effectively logged out from all sessions using this token.
  ///
  /// **Security Features:**.
  /// - Refresh token blacklisting for immediate invalidation.
  /// - Audit trail with logout reason.
  /// - Prevents token reuse after logout.
  /// - Maintains security even if tokens are compromised.
  ///
  /// **Best Practices:**.
  /// - Always call this endpoint when user logs out.
  /// - Clear local token storage on client side.
  /// - Implement automatic logout on token expiration.
  ///
  /// Args:.
  ///     logout_data: LogoutRequest containing:.
  ///         - refresh_token: JWT refresh token to blacklist.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Response confirming successful logout.
  ///    
  /// Raises:.
  ///     HTTPException (400): If refresh token is invalid.
  ///     HTTPException (422): If request data validation fails.
  ///    
  /// Example Request:.
  ///     ```json.
  ///     {.
  ///         "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Logout successful",.
  ///         "data": null.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/logout')
  Future<AuthResponse> logout({
    @Body() required LogoutRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Current User Info.
  ///
  /// Get current user information.
  ///
  /// Args:.
  ///     current_user: Current authenticated user.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     User authentication information.
  @GET('/api/v1/auth/me')
  Future<UserAuthInfo> getMyProfile({
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Forgot Password.
  ///
  /// Request password reset.
  ///
  /// Args:.
  ///     reset_data: Password reset request data.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Authentication response.
  @POST('/api/v1/auth/forgot-password')
  Future<AuthResponse> forgotPassword({
    @Body() required PasswordResetRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Reset Password.
  ///
  /// Reset password using reset token.
  ///
  /// Args:.
  ///     reset_data: Password reset confirmation data.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Authentication response.
  ///
  /// Raises:.
  ///     HTTPException: If token is invalid or expired.
  @POST('/api/v1/auth/reset-password')
  Future<AuthResponse> resetPassword({
    @Body() required PasswordResetConfirm body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Verify Email.
  ///
  /// Verify email using verification token.
  ///
  /// Args:.
  ///     verification_data: Email verification data.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Authentication response.
  ///
  /// Raises:.
  ///     HTTPException: If token is invalid or expired.
  @POST('/api/v1/auth/verify-email')
  Future<AuthResponse> verifyEmail({
    @Body() required EmailVerificationRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Change Password.
  ///
  /// Change user password.
  ///
  /// Args:.
  ///     current_password: Current password.
  ///     new_password: New password.
  ///     current_user: Current authenticated user.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Authentication response.
  ///
  /// Raises:.
  ///     HTTPException: If current password is incorrect.
  @POST('/api/v1/auth/change-password')
  Future<AuthResponse> changePassword({
    @Query('current_password') required String currentPassword,
    @Query('new_password') required String newPassword,
    @Query('token') String? token,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Blacklist Token.
  ///
  /// Blacklist a token (admin function).
  ///
  /// Args:.
  ///     blacklist_data: Token blacklist data.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Token blacklist response.
  @POST('/api/v1/auth/blacklist-token')
  Future<TokenBlacklistResponse> blacklistToken({
    @Body() required TokenBlacklistRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Login Google.
  ///
  /// Authenticate user with Firebase Google Authentication.
  ///
  /// This endpoint is designed for mobile applications that use Firebase Authentication.
  /// and receive Firebase ID tokens from Google sign-in.
  ///
  /// Args:.
  ///     login_data: Google login request data with Firebase ID token only.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Social login response with tokens and user info.
  ///
  /// Raises:.
  ///     HTTPException: If Google authentication fails.
  @POST('/api/v1/auth/login/google')
  Future<SocialLoginResponse> loginWithGoogle({
    @Body() required GoogleLoginRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Login Apple.
  ///
  /// Authenticate user with Firebase Apple Authentication.
  ///
  /// This endpoint is designed for mobile applications that use Firebase Authentication.
  /// and receive Firebase ID tokens from Apple sign-in.
  ///
  /// Args:.
  ///     login_data: Apple login request data with Firebase ID token only.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Social login response with tokens and user info.
  ///
  /// Raises:.
  ///     HTTPException: If Apple authentication fails.
  @POST('/api/v1/auth/login/apple')
  Future<SocialLoginResponse> loginWithApple({
    @Body() required AppleLoginRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Oauth Url.
  ///
  /// Get OAuth authorization URL for the specified provider.
  ///
  /// Args:.
  ///     provider: OAuth provider (google, apple).
  ///     redirect_uri: OAuth redirect URI.
  ///     state: Optional state parameter for CSRF protection.
  ///     platform: Optional platform specification ('ios', 'android', 'web').
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     OAuth authorization URL.
  ///
  /// Raises:.
  ///     HTTPException: If provider is not supported.
  @GET('/api/v1/auth/oauth/{provider}/url')
  Future<dynamic> getOAuthUrl({
    @Path('provider') required String provider,
    @Query('redirect_uri') required String redirectUri,
    @Query('state') String? state,
    @Query('platform') String? platform,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Platform Oauth Url.
  ///
  /// Get platform-specific OAuth authorization URL.
  ///
  /// Args:.
  ///     provider: OAuth provider (google, apple).
  ///     platform: Platform specification ('ios', 'android', 'web').
  ///     redirect_uri: OAuth redirect URI.
  ///     state: Optional state parameter for CSRF protection.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Platform-specific OAuth authorization URL.
  ///
  /// Raises:.
  ///     HTTPException: If provider or platform is not supported.
  @GET('/api/v1/auth/oauth/{provider}/url/{platform}')
  Future<dynamic> getOAuthUrlForPlatform({
    @Path('provider') required String provider,
    @Path('platform') required String platform,
    @Query('redirect_uri') required String redirectUri,
    @Query('state') String? state,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Oauth Provider Info.
  ///
  /// Get OAuth provider configuration information.
  ///
  /// Args:.
  ///     provider: OAuth provider name (google, apple).
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Provider configuration information.
  ///
  /// Raises:.
  ///     HTTPException: If provider is not supported.
  @GET('/api/v1/auth/oauth/{provider}/info')
  Future<OAuthProviderInfo> getOAuthProviderInfo({
    @Path('provider') required String provider,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Oauth Callback.
  ///
  /// Handle OAuth callback from provider.
  ///
  /// Args:.
  ///     provider: OAuth provider (google, apple).
  ///     callback_data: OAuth callback data.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     OAuth callback response.
  ///
  /// Raises:.
  ///     HTTPException: If callback handling fails.
  @POST('/api/v1/auth/oauth/{provider}/callback')
  Future<dynamic> handleOAuthCallback({
    @Path('provider') required String provider,
    @Body() required OAuthCallbackRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Google Oauth Callback.
  ///
  /// Handle Google OAuth callback for web applications.
  ///
  /// This endpoint is called by Google after the user authorizes the application.
  /// It receives the authorization code and exchanges it for user information.
  ///
  /// Args:.
  ///     code: Authorization code from Google.
  ///     state: Optional state parameter for CSRF protection.
  ///     error: Optional error parameter if authorization failed.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     OAuth callback response with user authentication result.
  ///
  /// Raises:.
  ///     HTTPException: If callback handling fails.
  @GET('/api/v1/auth/oauth/google/callback')
  Future<dynamic> handleGoogleOAuthCallback({
    @Query('code') required String code,
    @Query('state') String? state,
    @Query('error') String? error,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Verify Email Registration Code
  @POST('/api/v1/auth/register/email/verify')
  Future<VerificationTokenResponse> verifyEmailRegistrationCode({
    @Body() required EmailRegisterVerifyRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Set Password After Verification
  @POST('/api/v1/auth/register/email/set-password')
  Future<AuthResponse> setPasswordAfterVerification({
    @Body() required EmailSetPasswordRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Auth Health.
  ///
  /// Authentication service health check.
  ///
  /// Returns:.
  ///     Health status.
  @GET('/api/v1/auth/health')
  Future<dynamic> healthCheck({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Get Google Oauth Detailed Info.
  ///
  /// Get detailed Google OAuth configuration information for mobile platforms.
  ///
  /// Args:.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Detailed Google OAuth configuration information.
  ///
  /// Raises:.
  ///     HTTPException: If Google OAuth is not configured.
  @GET('/api/v1/auth/oauth/google/detailed-info')
  Future<dynamic> getGoogleOAuthDetailedInfo({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
