// lib/features/auth/data/auth_repository.dart
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:twin_finder/api/api_client.dart';
import 'package:twin_finder/api/models/auth_response.dart';
import 'package:twin_finder/api/models/basic_message_response.dart';
import 'package:twin_finder/api/models/email_registration_confirm.dart';
import 'package:twin_finder/api/models/email_registration_request.dart';
import 'package:twin_finder/api/models/email_register_verify_request.dart';
import 'package:twin_finder/api/models/email_set_password_request.dart';
import 'package:twin_finder/api/models/verification_token_response.dart';
import 'package:twin_finder/api/models/google_login_request.dart';
import 'package:twin_finder/api/models/apple_login_request.dart';
import 'package:twin_finder/api/models/login_request.dart';
import 'package:twin_finder/api/models/logout_request.dart';
import 'package:twin_finder/api/models/social_login_response.dart';
import 'dart:io';
import 'package:twin_finder/api/models/user_profile_response.dart';
import 'package:twin_finder/api/models/user_update.dart';
import 'package:twin_finder/api/models/photo_upload_response.dart';
import 'package:twin_finder/core/errors/api_error.dart';
import 'package:twin_finder/api/models/refresh_token_request.dart';
import 'package:twin_finder/core/utils/token_secure.dart';
import 'dart:convert';

class AuthRepository {
  final ApiClient api;
  final TokenStore tokenStore;

  AuthRepository(GetIt sl)
    : api = sl<ApiClient>(),
      tokenStore = sl<TokenStore>();

  // Ensure access token is fresh well before expiry
  Future<void> _refreshIfExpiringSoon({int thresholdSeconds = 120}) async {
    final access = await tokenStore.access;
    if (access == null || access.isEmpty) return;
    try {
      final parts = access.split('.');
      if (parts.length != 3) return;
      var payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final jsonMap = jsonDecode(utf8.decode(base64Decode(payload))) as Map<String, dynamic>;
      final exp = jsonMap['exp'];
      if (exp is int) {
        final expiresAt = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (expiresAt.difference(DateTime.now()).inSeconds <= thresholdSeconds) {
          final refresh = await tokenStore.refresh;
          if (refresh != null && refresh.isNotEmpty) {
            final refreshed = await api.authentication.refreshTokens(
              body: RefreshTokenRequest(refreshToken: refresh),
            );
            await tokenStore.save(
              access: refreshed.data?.accessToken,
              refresh: refreshed.data?.refreshToken,
            );
          }
        }
      }
    } catch (_) {
      // If parsing fails, do nothing; interceptor will handle 401
    }
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      final res = await api.authentication.login(
        body: LoginRequest(email: email, password: password),
      );
      await tokenStore.save(
        access: res.data?.accessToken,
        refresh: res.data?.refreshToken,
      );
      return res;
    } on DioException catch (e) {
      throw ApiError.fromDioException(e);
    }
  }

  Future<SocialLoginResponse> authGoogle(GoogleLoginRequest request) async {
    final res = await api.authentication.loginWithGoogle(body: request);
    await tokenStore.save(
      access: res.data?.accessToken,
      refresh: res.data?.refreshToken,
    );
    return res;
  }

  Future<SocialLoginResponse> authApple(AppleLoginRequest request) async {
    final res = await api.authentication.loginWithApple(body: request);
    await tokenStore.save(
      access: res.data?.accessToken,
      refresh: res.data?.refreshToken,
    );
    return res;
  }

  Future<BasicMessageResponse> authEmail(String email) async {
    final res = await api.authentication.initiateRegistration(
      body: EmailRegistrationRequest(email: email),
    );

    return res;
  }

  Future<AuthResponse> confirmEmail(String email, String code) async {
    final res = await api.authentication.confirmRegistration(
      body: EmailRegistrationConfirm(email: email, verificationCode: code),
    );

    await tokenStore.save(
      access: res.data?.accessToken,
      refresh: res.data?.refreshToken,
    );
    return res;
  }

  Future<VerificationTokenResponse> verifyEmailCode(
    String email,
    String code,
  ) async {
    final res = await api.authentication.verifyEmailRegistrationCode(
      body: EmailRegisterVerifyRequest(email: email, verificationCode: code),
    );
    return res;
  }

  Future<AuthResponse> setPasswordAfterVerification({
    required String verificationToken,
    required String password,
    required String passwordConfirm,
  }) async {
    final res = await api.authentication.setPasswordAfterVerification(
      body: EmailSetPasswordRequest(
        verificationToken: verificationToken,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
    );

    await tokenStore.save(
      access: res.data?.accessToken,
      refresh: res.data?.refreshToken,
    );
    return res;
  }

  Future<void> logout() async {
    final refresh = await tokenStore.refresh;
    if (refresh != null && refresh.isNotEmpty) {
      try {
        await api.authentication.logout(
          body: LogoutRequest(refreshToken: refresh),
        );
      } catch (e) {
        // Log error but continue with token cleanup
        debugPrint('Logout API call failed: $e');
      }
    }
    await tokenStore.clear();
  }

  /// Load user profile with error handling
  Future<UserProfileResponse> loadMe() async {
    try {
      await _refreshIfExpiringSoon();
      // Check if we have a valid access token before making the request
      final accessToken = await tokenStore.access;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('No access token available');
      }

      return await api.users.getMyProfileApiV1UsersMeGet();
    } catch (e) {
      // Check if it's a server error (500, 502, 503, etc.)
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          // Clear invalid tokens
          await tokenStore.clear();
          throw Exception('Authentication required - please login again');
        } else if (statusCode != null && statusCode >= 500) {
          throw Exception('Server error: $statusCode - please try again later');
        }
      }
      throw Exception('Failed to load profile: $e');
    }
  }

  /// Check if user has completed profile setup
  Future<bool> isProfileComplete() async {
    try {
      final profile = await loadMe();
      final user = profile.data;

      return user.name.isNotEmpty &&
          user.birthday != null &&
          user.gender != null &&
          user.country != null &&
          user.city != null;
    } catch (e) {
      // If we can't load profile, consider it incomplete
      return false;
    }
  }

  /// Get current user profile for setup (with fallback for server errors)
  Future<UserProfileResponse?> getProfileForSetup() async {
    try {
      return await loadMe();
    } catch (e) {
      // If we get a server error, return null to indicate profile needs setup
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode != null && statusCode >= 500) {
          return null;
        }
      }
      rethrow;
    }
  }

  /// Update user profile with validation
  Future<UserProfileResponse> updateProfile({
    String? name,
    DateTime? birthday,
    String? gender,
    String? country,
    String? city,
  }) async {
    // Validate input data
    if (name != null && name.trim().isEmpty) {
      throw Exception('Name cannot be empty');
    }

    if (gender != null &&
        !['male', 'female', 'other', 'prefer_not_to_say'].contains(gender)) {
      throw Exception('Invalid gender value');
    }

    final updateData = UserUpdate(
      name: name?.trim(),
      birthday: birthday,
      gender: gender,
      country: country?.trim(),
      city: city?.trim(),
    );

    try {
      await _refreshIfExpiringSoon();
      return await api.users.updateMyProfileApiV1UsersMePut(body: updateData);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          throw Exception('Invalid data provided: ${e.message}');
        } else if (statusCode == 401) {
          throw Exception('Authentication required');
        } else if (statusCode != null && statusCode >= 500) {
          throw Exception('Server error: $statusCode - ${e.message}');
        }
      }
      rethrow;
    }
  }

  /// Get current user profile or null if not available
  Future<UserProfileResponse?> getCurrentProfile() async {
    try {
      return await loadMe();
    } catch (e) {
      return null;
    }
  }

  /// Upload photo for the current user
  Future<PhotoUploadResponse> uploadPhoto(File photoFile) async {
    try {
      await _refreshIfExpiringSoon();
      // Check if we have a valid access token before making the request
      final accessToken = await tokenStore.access;
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('No access token available - please login first');
      }

      // Create MultipartFile from File
      final multipartFile = await MultipartFile.fromFile(
        photoFile.path,
        filename: 'photo.jpg',
      );

      debugPrint('Uploading photo with token: ${accessToken.substring(0, 20)}...');
      
      return await api.photos.uploadPhotoApiV1PhotosUploadPost(
        file: multipartFile,
      );
    } catch (e) {
      debugPrint('Photo upload error: $e');
      
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;
        
        debugPrint('Photo upload failed with status: $statusCode');
        debugPrint('Response data: $responseData');
        
        if (statusCode == 401) {
          // Clear invalid tokens
          await tokenStore.clear();
          throw Exception('Authentication required - please login again');
        } else if (statusCode == 400) {
          // Surface backend-provided reason to the UI (e.g., "Face too small")
          String detail = 'Invalid photo';
          final data = e.response?.data;
          if (data is Map<String, dynamic>) {
            final serverDetail = data['detail'];
            if (serverDetail is String && serverDetail.trim().isNotEmpty) {
              detail = serverDetail;
            }
          }
          throw Exception(detail);
        } else if (statusCode == 403) {
          // Profile incomplete or forbidden – surface backend reason
          final data = e.response?.data;
          final detail = data is Map<String, dynamic>
              ? (data['detail'] as String?)
              : null;
          throw Exception(detail ?? 'Profile not completed. Please finish your profile first.');
        } else if (statusCode == 429) {
          final responseData = e.response?.data;
          final detail = responseData is Map<String, dynamic>
              ? responseData['detail'] as String?
              : null;
          throw Exception(detail ?? 'Photo upload limit reached for today');
        } else if (statusCode == 413) {
          throw Exception('Photo file too large - please choose a smaller image');
        } else if (statusCode == 415) {
          throw Exception('Unsupported file format - please use JPG or PNG');
        } else if (statusCode != null && statusCode >= 500) {
          // Server error - provide more specific error message
          final errorMessage = responseData is Map<String, dynamic> 
              ? responseData['detail'] ?? 'Server error'
              : 'Server error: $statusCode - please try again later';
          throw Exception('Server error: $errorMessage');
        }
      }
      
      // Handle the specific "No access token available" case
      if (e.toString().contains('No access token available')) {
        throw Exception('Please complete the login process first');
      }
      
      throw Exception('Failed to upload photo: $e');
    }
  }
}


