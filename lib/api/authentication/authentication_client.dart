// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/apple_login_request.dart';
import '../models/auth_login_oauth2.dart';
import '../models/auth_response.dart';
import '../models/email_registration_confirm.dart';
import '../models/email_registration_request.dart';
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

  /// Login Oauth2.
  ///
  /// OAuth2 compatible token endpoint.
  ///
  /// This endpoint provides OAuth2-compatible authentication for third-party.
  /// applications and OAuth2 clients. It accepts form-encoded data instead of JSON.
  ///
  /// **OAuth2 Compatibility:**.
  /// - Accepts standard OAuth2 password grant flow.
  /// - Uses form-encoded data (application/x-www-form-urlencoded).
  /// - Returns standard OAuth2 token response format.
  /// - Compatible with OAuth2 libraries and tools.
  ///
  /// **Use Cases:**.
  /// - Third-party application integration.
  /// - OAuth2 client libraries.
  /// - API testing tools that expect OAuth2 format.
  ///
  /// Args:.
  ///     form_data: OAuth2PasswordRequestForm containing:.
  ///         - username: User's email address.
  ///         - password: User's password.
  ///         - grant_type: Should be "password" for this endpoint.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Authentication response with JWT tokens.
  ///    
  /// Raises:.
  ///     HTTPException (401): If username or password is incorrect.
  ///     HTTPException (422): If form data validation fails.
  ///    
  /// Example Request (form-encoded):.
  ///     ```.
  ///     username=user@example.com&password=securepassword123&grant_type=password.
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
  @FormUrlEncoded()
  @POST('/api/v1/auth/login/oauth2')
  Future<AuthResponse> loginOauth2ApiV1AuthLoginOauth2Post({
    @Body() required AuthLoginOauth2 body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Initiate Registration.
  ///
  /// Initiate email registration process (Step 1 of 2).
  ///
  /// This endpoint starts the two-step email registration process by sending.
  /// a verification code to the provided email address.
  ///
  /// **Registration Flow:**.
  /// 1. User provides email address.
  /// 2. System validates email format and availability.
  /// 3. Verification code is generated and sent via email.
  /// 4. User receives code and proceeds to step 2.
  ///
  /// **Security Features:**.
  /// - Email validation and availability check.
  /// - Rate limiting on email sending.
  /// - Verification codes expire after 15 minutes.
  /// - Prevents duplicate registrations.
  ///
  /// Args:.
  ///     registration_data: EmailRegistrationRequest containing:.
  ///         - email: Valid email address for registration.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Response indicating verification code was sent.
  ///    
  /// Raises:.
  ///     HTTPException (400): If email already exists.
  ///     HTTPException (400): If registration already pending.
  ///     HTTPException (422): If email format is invalid.
  ///    
  /// Example Request:.
  ///     ```json.
  ///     {.
  ///         "email": "newuser@example.com".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Verification code sent to your email. Please check your inbox and enter the code to complete registration.",.
  ///         "data": null.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/register/initiate')
  Future<AuthResponse> initiateRegistrationApiV1AuthRegisterInitiatePost({
    @Body() required EmailRegistrationRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Confirm Registration.
  ///
  /// Confirm email registration and create user account (Step 2 of 2).
  ///
  /// This endpoint completes the registration process by verifying the email.
  /// verification code and creating the user account with the provided details.
  ///
  /// **Registration Completion:**.
  /// 1. User provides email, verification code, password, and name.
  /// 2. System validates verification code and expiration.
  /// 3. User account is created with hashed password.
  /// 4. JWT tokens are generated and returned.
  /// 5. User is automatically logged in.
  ///
  /// **Security Features:**.
  /// - Verification code validation and expiration check.
  /// - Password hashing using bcrypt.
  /// - Automatic account activation.
  /// - GDPR consent tracking.
  ///
  /// Args:.
  ///     confirmation_data: EmailRegistrationConfirm containing:.
  ///         - email: Email address used in step 1.
  ///         - verification_code: 6-digit code sent via email.
  ///         - password: User's chosen password (min 8 characters).
  ///         - name: User's display name.
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
  ///         "verification_code": "123456",.
  ///         "password": "securepassword123",.
  ///         "name": "John Doe".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Registration completed successfully! Welcome to TwinFinder.",.
  ///         "data": {.
  ///             "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "token_type": "bearer",.
  ///             "expires_in": 3600.
  ///         }.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/register/confirm')
  Future<AuthResponse> confirmRegistrationApiV1AuthRegisterConfirmPost({
    @Body() required EmailRegistrationConfirm body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Register.
  ///
  /// Register a new user account (Legacy endpoint - deprecated).
  ///
  /// **⚠️ DEPRECATED: Use /register/initiate and /register/confirm instead**.
  ///
  /// This legacy endpoint creates a user account directly without email verification.
  /// It's maintained for backward compatibility but should not be used in new applications.
  ///
  /// **Security Considerations:**.
  /// - No email verification required.
  /// - Account is created immediately.
  /// - Less secure than the two-step registration process.
  /// - Email verification token is generated but not required for login.
  ///
  /// **Migration Path:**.
  /// - New applications should use /register/initiate and /register/confirm.
  /// - This endpoint will be removed in a future version.
  ///
  /// Args:.
  ///     email: User's email address (must be unique).
  ///     password: User's password (minimum 8 characters).
  ///     name: User's display name.
  ///     auth_service: Authentication service dependency.
  ///    
  /// Returns:.
  ///     AuthResponse: Authentication response with JWT tokens.
  ///    
  /// Raises:.
  ///     HTTPException (400): If email already exists.
  ///     HTTPException (422): If request data validation fails.
  ///    
  /// Example Request:.
  ///     ```json.
  ///     {.
  ///         "email": "user@example.com",.
  ///         "password": "securepassword123",.
  ///         "name": "John Doe".
  ///     }.
  ///     ```.
  ///    
  /// Example Response:.
  ///     ```json.
  ///     {.
  ///         "success": true,.
  ///         "message": "Registration successful. Please verify your email.",.
  ///         "data": {.
  ///             "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",.
  ///             "token_type": "bearer",.
  ///             "expires_in": 3600.
  ///         }.
  ///     }.
  ///     ```.
  @POST('/api/v1/auth/register')
  Future<AuthResponse> registerApiV1AuthRegisterPost({
    @Query('email') required String email,
    @Query('password') required String password,
    @Query('name') required String name,
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
  Future<UserAuthInfo> getCurrentUserInfoApiV1AuthMeGet({
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
  Future<AuthResponse> forgotPasswordApiV1AuthForgotPasswordPost({
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
  Future<AuthResponse> resetPasswordApiV1AuthResetPasswordPost({
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
  Future<AuthResponse> verifyEmailApiV1AuthVerifyEmailPost({
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
  Future<AuthResponse> changePasswordApiV1AuthChangePasswordPost({
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
  Future<TokenBlacklistResponse> blacklistTokenApiV1AuthBlacklistTokenPost({
    @Body() required TokenBlacklistRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Login Google.
  ///
  /// Authenticate user with Google OAuth (Mobile Flow).
  ///
  /// This endpoint is designed for mobile applications that use Google Sign-In SDK.
  /// and receive ID tokens directly from the mobile app.
  ///
  /// Args:.
  ///     login_data: Google login request data with ID token.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Social login response with tokens and user info.
  ///
  /// Raises:.
  ///     HTTPException: If Google authentication fails.
  @POST('/api/v1/auth/login/google')
  Future<SocialLoginResponse> loginGoogleApiV1AuthLoginGooglePost({
    @Body() required GoogleLoginRequest body,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Login Google Web.
  ///
  /// Authenticate user with Google OAuth (Web Flow).
  ///
  /// This endpoint is designed for web applications that use OAuth2 authorization code flow.
  /// The frontend redirects users to Google OAuth, gets an authorization code, and sends it here.
  ///
  /// Args:.
  ///     code: Authorization code from Google OAuth.
  ///     state: Optional state parameter for CSRF protection.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Social login response with tokens and user info.
  ///
  /// Raises:.
  ///     HTTPException: If Google authentication fails.
  @GET('/api/v1/auth/login/google/web')
  Future<SocialLoginResponse> loginGoogleWebApiV1AuthLoginGoogleWebGet({
    @Query('code') required String code,
    @Query('state') String? state,
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });

  /// Login Apple.
  ///
  /// Authenticate user with Apple OAuth.
  ///
  /// Args:.
  ///     login_data: Apple login request data.
  ///     auth_service: Authentication service.
  ///
  /// Returns:.
  ///     Social login response with tokens and user info.
  ///
  /// Raises:.
  ///     HTTPException: If Apple authentication fails.
  @POST('/api/v1/auth/login/apple')
  Future<SocialLoginResponse> loginAppleApiV1AuthLoginApplePost({
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
  Future<dynamic> getOauthUrlApiV1AuthOauthProviderUrlGet({
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
  Future<dynamic> getPlatformOauthUrlApiV1AuthOauthProviderUrlPlatformGet({
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
  Future<OAuthProviderInfo> getOauthProviderInfoApiV1AuthOauthProviderInfoGet({
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
  Future<dynamic> oauthCallbackApiV1AuthOauthProviderCallbackPost({
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
  Future<dynamic> googleOauthCallbackApiV1AuthOauthGoogleCallbackGet({
    @Query('code') required String code,
    @Query('state') String? state,
    @Query('error') String? error,
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
  Future<dynamic> authHealthApiV1AuthHealthGet({
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
  Future<dynamic> getGoogleOauthDetailedInfoApiV1AuthOauthGoogleDetailedInfoGet({
    @Extras() Map<String, dynamic>? extras,
    @DioOptions() RequestOptions? options,
  });
}
