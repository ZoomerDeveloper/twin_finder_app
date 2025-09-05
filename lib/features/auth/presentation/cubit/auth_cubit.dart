// lib/features/auth/logic/auth_cubit.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:twin_finder/api/models/apple_login_request.dart';
import 'package:twin_finder/api/models/google_login_request.dart';
import 'package:twin_finder/api/models/user_profile_response.dart';
import 'package:twin_finder/api/models/photo_upload_response.dart';
import 'package:twin_finder/core/errors/api_error.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/features/auth/presentation/repository/auth_repository.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  AuthCubit(this.repo) : super(AuthInitial());

  // Flag to prevent multiple simultaneous profile checks
  bool _isCheckingProfile = false;

  // Cache for profile data to avoid repeated requests
  UserProfileResponse? _cachedProfile;

  Future<void> appStarted() async {
    debugPrint('appStarted: Starting app initialization...');
    emit(AuthLoading());
    try {
      // Check profile completeness instead of just loading profile
      debugPrint('appStarted: Calling checkProfileCompleteness...');
      await checkProfileCompleteness();
      debugPrint('appStarted: checkProfileCompleteness completed');
    } catch (e) {
      debugPrint('appStarted: Error during app startup: $e');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await repo.login(email, password);
      // Check profile completeness after successful login
      await checkProfileCompleteness();
    } catch (e) {
      debugPrint('Login error: $e');

      if (e is ApiError) {
        // Handle specific API errors
        if (e.isAuthenticationError) {
          emit(AuthFailure('Incorrect email or password'));
        } else if (e.isValidationError) {
          emit(AuthFailure(e.message));
        } else if (e.isServerError) {
          emit(AuthFailure('Server error - please try again later'));
        } else if (e.isNetworkError) {
          emit(AuthFailure('Network error - please check your connection'));
        } else {
          emit(AuthFailure(e.message));
        }
      } else {
        // Handle other types of errors
        emit(AuthFailure(e.toString()));
      }

      emit(AuthUnauthenticated());
    }
  }

  Future<void> register(String email) async {
    emit(AuthLoading());
    try {
      await repo.authEmail(email);
      // For successful email registration initiation, emit success state
      emit(AuthEmailCodeSent(email: email));
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
      // Don't emit AuthUnauthenticated here to avoid duplicate state changes
      // The UI will handle the error and stay on the same page
    }
  }

  Future<void> resendCode(String email) async {
    emit(AuthLoading());
    try {
      // For resending code, we don't need password since it was already sent
      await repo.authEmail(email);
      // For successful code resend, emit success state
      emit(AuthEmailCodeSent(email: email));
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
      // Don't emit AuthUnauthenticated here to avoid duplicate state changes
    }
  }

  Future<void> confirmEmail(String email, String code) async {
    emit(AuthLoading());
    try {
      await repo.confirmEmail(email, code);
      // Check profile completeness after successful email confirmation
      await checkProfileCompleteness();
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
      // Don't emit AuthUnauthenticated here to avoid duplicate state changes
    }
  }

  Future<void> verifyEmailCode(String email, String code) async {
    emit(AuthLoading());
    try {
      final response = await repo.verifyEmailCode(email, code);
      // For successful code verification, emit new state with verification token
      emit(
        AuthEmailVerified(
          email: email,
          verificationToken: response.verificationToken,
        ),
      );
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
    }
  }

  Future<void> setPasswordAfterVerification({
    required String verificationToken,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AuthLoading());
    try {
      await repo.setPasswordAfterVerification(
        verificationToken: verificationToken,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      // Check profile completeness after successful password setup
      await checkProfileCompleteness();
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
    }
  }

  Future<void> authGoogle(String? idToken) async {
    if (idToken == null) {
      emit(AuthFailure('Google login failed: no ID token'));
      // Don't emit AuthUnauthenticated here to avoid duplicate state changes
      return;
    }
    emit(AuthLoading());
    try {
      await repo.authGoogle(GoogleLoginRequest(idToken: idToken));

      // Add a small delay to ensure tokens are properly saved
      await Future.delayed(const Duration(milliseconds: 500));

      // Check profile completeness after successful authentication
      await checkProfileCompleteness();
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
      // Don't emit AuthUnauthenticated here to avoid duplicate state changes
    }
  }

  Future<void> authApple(AppleLoginRequest request) async {
    emit(AuthLoading());
    try {
      await repo.authApple(request);

      // Add a small delay to ensure tokens are properly saved
      await Future.delayed(const Duration(milliseconds: 500));

      // Check profile completeness after successful authentication
      await checkProfileCompleteness();
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
      // Don't emit AuthUnauthenticated here to avoid duplicate state changes
    }
  }

  Future<void> logout() async {
    // emit(AuthLoading());
    await repo.logout();
    // Clear cached profile data
    _cachedProfile = null;
    debugPrint('Profile cache cleared on logout');
    // emit(AuthUnauthenticated());
  }

  Future<void> updateProfile({
    String? name,
    DateTime? birthday,
    String? gender,
    String? country,
    String? city,
  }) async {
    debugPrint('updateProfile called with state: ${state.runtimeType}');

    // Allow retry if we're in AuthProfileUpdateFailed state
    if (state is AuthProfileUpdateFailed) {
      debugPrint('Allowing retry from AuthProfileUpdateFailed state');
      // Continue with the update
    }

    if (state is AuthAuthenticated ||
        state is AuthNeedsProfileSetup ||
        state is AuthNeedsProfileSetupWithData ||
        state is AuthProfileUpdateFailed) {
      debugPrint('Starting profile update...');
      emit(AuthLoading());
      try {
        final updatedProfile = await repo.updateProfile(
          name: name,
          birthday: birthday,
          gender: gender,
          country: country,
          city: city,
        );

        // Update cache with new profile data
        _cachedProfile = updatedProfile;
        debugPrint('Profile updated and cache refreshed');

        // Check profile completeness after update to determine next state
        debugPrint('Checking profile completeness after update...');
        await checkProfileCompleteness();
      } catch (e) {
        debugPrint('Profile update failed: $e');
        // Determine which field failed to update
        String? fieldName;
        if (name != null) {
          fieldName = 'name';
        } else if (birthday != null) {
          fieldName = 'birthday';
        } else if (gender != null) {
          fieldName = 'gender';
        } else if (country != null) {
          fieldName = 'country';
        } else if (city != null) {
          fieldName = 'city';
        }

        emit(AuthProfileUpdateFailed(e.toString(), fieldName: fieldName));
      }
    } else {
      debugPrint('Cannot update profile from state: ${state.runtimeType}');
    }
  }

  Future<void> loadProfile() async {
    if (state is AuthAuthenticated ||
        state is AuthNeedsProfileSetup ||
        state is AuthNeedsProfileSetupWithData) {
      emit(AuthLoading());
      try {
        // Use cached profile if available, otherwise load from API
        UserProfileResponse me;
        if (_cachedProfile != null) {
          debugPrint('Using cached profile for loadProfile');
          me = _cachedProfile!;
        } else {
          me = await repo.loadMe();
          _cachedProfile = me; // Cache the profile
          debugPrint('Profile loaded from API for loadProfile and cached');
        }
        emit(AuthAuthenticated(me));
      } catch (e) {
        emit(AuthFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    }
  }

  /// Check if user profile is complete and redirect accordingly
  Future<void> checkProfileCompleteness() async {
    // Prevent multiple simultaneous profile checks
    if (_isCheckingProfile) {
      debugPrint('Profile check already in progress, skipping...');
      return;
    }

    _isCheckingProfile = true;
    debugPrint('Starting profile completeness check...');

    try {
      // Use cached profile if available, otherwise load from API
      UserProfileResponse profile;
      if (_cachedProfile != null) {
        debugPrint('Using cached profile data');
        profile = _cachedProfile!;
      } else {
        profile = await repo.loadMe();
        _cachedProfile = profile; // Cache the profile
        debugPrint('Profile loaded from API and cached');
      }

      // Check if profile is complete using server-side flag
      final user = profile.data;
      final isComplete = user.profileCompleted;

      debugPrint(
        'Profile completeness check: profileCompleted=${user.profileCompleted}, name=${user.name.isNotEmpty}, birthday=${user.birthday != null}, gender=${user.gender != null}, country=${user.country != null}, city=${user.city != null}',
      );

      if (isComplete) {
        // Profile is complete, user can proceed to main app
        debugPrint('Profile is complete, emitting AuthAuthenticated');
        emit(AuthAuthenticated(profile));
      } else {
        // Profile is incomplete, redirect to profile setup with data
        debugPrint(
          'Profile is incomplete, emitting AuthNeedsProfileSetupWithData',
        );
        emit(AuthNeedsProfileSetupWithData(profile));
      }
    } catch (e) {
      debugPrint('Error during profile completeness check: $e');
      // Handle different types of errors
      if (e.toString().contains('No access token available') ||
          e.toString().contains('Authentication required')) {
        // No valid token - user needs to authenticate
        debugPrint('No valid token, emitting AuthUnauthenticated');
        emit(AuthUnauthenticated());
      } else if (_isMaintenanceError(e)) {
        // Maintenance error - show maintenance page
        debugPrint('Maintenance error detected, emitting AuthMaintenance');
        emit(AuthMaintenance());
      } else if (e.toString().contains('500') ||
          e.toString().contains('Internal Server Error') ||
          e.toString().contains('Server error')) {
        // Server error - redirect to profile setup
        debugPrint('Server error, emitting AuthNeedsProfileSetup');
        emit(AuthNeedsProfileSetup());
      } else {
        // Other errors
        debugPrint('Other error, emitting AuthFailure');
        emit(AuthFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    } finally {
      _isCheckingProfile = false;
      debugPrint('Profile completeness check completed');
    }
  }

  // Method to mark profile setup as complete
  void markProfileSetupComplete() {
    if (state is AuthNeedsProfileSetup) {
      emit(AuthProfileSetupComplete());
    }
  }

  Future<void> uploadPhoto(File photoFile) async {
    emit(AuthLoading());
    try {
      final response = await repo.uploadPhoto(photoFile);
      // Photo uploaded successfully, emit success state
      emit(AuthPhotoUploaded(response));
    } catch (e) {
      emit(AuthFailure(e)); // Pass the actual error object, not toString()
    }
  }

  /// Check if error indicates maintenance and emit appropriate state
  bool _isMaintenanceError(dynamic error) {
    return ErrorHandler.isMaintenanceError(error);
  }
}
