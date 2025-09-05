import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twin_finder/api/models/apple_login_request.dart';
import 'package:twin_finder/api/models/google_login_request.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/core/utils/error_handler.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    String _generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
        length,
        (_) => charset[random.nextInt(charset.length)],
      ).join();
    }

    String _sha256OfString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    Future<void> signWithApple() async {
      HapticFeedback.mediumImpact();
      try {
        // Check Apple Sign-In availability
        bool isAvailable;
        try {
          isAvailable = await SignInWithApple.isAvailable();
        } catch (e) {
          print('Error checking Apple Sign-In availability: $e');
          isAvailable = false;
        }

        if (!isAvailable) {
          print('Apple Sign-In not available on this device');
          ErrorHandler.showInfo(
            context,
            'Apple Sign-In not available on this device',
            title: 'Apple Sign-In',
          );
          return;
        }

        final rawNonce = _generateNonce();
        final nonce = _sha256OfString(rawNonce);

        AuthorizationCredentialAppleID credential;
        try {
          credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );
        } catch (appleError) {
          final errorString = appleError.toString().toLowerCase();
          if (errorString.contains('canceled') ||
              errorString.contains('cancelled') ||
              errorString.contains('cancel') ||
              errorString.contains('user_canceled') ||
              errorString.contains('user_cancelled')) {
            print('User cancelled Apple Sign-In');
            return;
          }

          // Check for other specific Apple Sign-In errors
          if (errorString.contains('invalid_credential') ||
              errorString.contains('invalid_oauth_response')) {
            print('OAuth Apple Sign-In error: $appleError');
            ErrorHandler.showError(
              context,
              'Apple Sign-In authorization error. Please try again.',
              title: 'Apple Sign-In',
            );
            return;
          }

          print('Apple Sign-In error: $appleError');
          ErrorHandler.showError(
            context,
            'Apple Sign-In error: ${appleError.toString()}',
            title: 'Apple Sign-In',
          );
          return;
        }

        // Apple may not provide email/name on subsequent logins
        if (credential.email == null && credential.givenName == null) {
          print('Apple Sign-In: no email or name');
        }

        // Check that we have identityToken
        if (credential.identityToken == null ||
            credential.identityToken!.isEmpty) {
          print('Apple Sign-In failed: identityToken is null or empty');
          ErrorHandler.showError(
            context,
            'Apple Sign-In error: token not received',
            title: 'Apple Sign-In',
          );
          return;
        }

        // Create OAuth credential for Firebase
        final oauthCredential = OAuthProvider(
          'apple.com',
        ).credential(idToken: credential.identityToken, rawNonce: rawNonce);

        try {
          final userCred = await FirebaseAuth.instance.signInWithCredential(
            oauthCredential,
          );

          final firebaseIdToken = await userCred.user!.getIdToken(true);

          if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
            throw Exception('Failed to get Firebase ID token');
          }

          // Create Apple login request - only idToken is required
          final appleRequest = AppleLoginRequest(idToken: firebaseIdToken);

          // Call AuthCubit to handle Apple authentication
          context.read<AuthCubit>().authApple(appleRequest);
        } catch (firebaseError) {
          print('Firebase authentication error: $firebaseError');
          ErrorHandler.showError(
            context,
            'Authentication error: ${firebaseError.toString()}',
            title: 'Authentication',
          );
        }
      } catch (e) {
        print('Apple Sign-In error: $e');
        ErrorHandler.showError(
          context,
          'Apple Sign-In error: ${e.toString()}',
          title: 'Apple Sign-In',
        );
      }
    }

    Future<void> signInWithGoogle() async {
      HapticFeedback.mediumImpact();
      try {
        const List<String> scopes = <String>['email'];

        final GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCred = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        final firebaseIdToken = await userCred.user!.getIdToken(true);

        if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
          throw Exception('Failed to get Firebase ID token');
        }

        // Call AuthCubit to handle Google authentication
        context.read<AuthCubit>().authGoogle(firebaseIdToken);
      } catch (e) {
        print("Google Sign-In error: $e");
        // Show error to user
        ErrorHandler.showError(
          context,
          'Google Sign-In error: ${e.toString()}',
          title: 'Google Sign-In',
        );
      }
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle navigation for auth-related states
        if (state is AuthAuthenticated) {
          debugPrint(
            'BlocListener: User authenticated, navigating to MainPage',
          );
          // User is authenticated and profile is complete, navigate to MainPage
          context.animatedRoute(AppRoutes.main);
        } else if (state is AuthNeedsProfileSetup) {
          debugPrint('BlocListener: Navigating to name page (no data)');
          // Navigate to name page when profile is incomplete (no data available)
          context.onlyAnimatedRoute(AppRoutes.name);
        } else if (state is AuthNeedsProfileSetupWithData) {
          debugPrint(
            'BlocListener: Navigating to name page with profile data: ${state.profile.data.name}',
          );
          // Navigate to name page with profile data for pre-filling
          context.onlyAnimatedRoute(AppRoutes.name, arguments: [state.profile]);
        } else if (state is AuthMaintenance) {
          debugPrint(
            'BlocListener: Maintenance detected, navigating to maintenance page',
          );
          // Navigate to maintenance page
          context.onlyAnimatedRoute(AppRoutes.maintenance);
        }
      },
      child: Scaffold(
        body: BackgroundWidget(
          child: Column(
            children: [
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SvgPicture.asset(AppIcons.logo, height: 80),
              ),

              // Language selector
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  AppLocalizations.of(context).getString('find_your_twin'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 16 * (-3 / 100),
                    fontFamily: 'Bricolage Grotesque',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const LanguageSelector(),
              const Expanded(child: SizedBox()),
              SizedBox(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        signInWithGoogle();
                      },
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            SvgPicture.asset(
                              AppIcons.google,
                              width: 20,
                              height: 20,
                            ),
                            Expanded(child: SizedBox(width: 8)),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).getString('continue_with_google'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Bricolage Grotesque',
                              ),
                            ),
                            Expanded(child: SizedBox(width: 8)),
                            SizedBox(width: 20),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                    if (Platform.isIOS) ...[
                      FutureBuilder<bool>(
                        future: SignInWithApple.isAvailable(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              height: 48,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[600]!,
                                  ),
                                ),
                              ),
                            );
                          }

                          final isAvailable = snapshot.data ?? false;

                          return GestureDetector(
                            onTap: isAvailable
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    signWithApple();
                                  }
                                : null,
                            child: Container(
                              height: 48,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? Colors.white
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 16),
                                  SvgPicture.asset(
                                    AppIcons.apple,
                                    width: 20,
                                    height: 20,
                                    colorFilter: isAvailable
                                        ? null
                                        : ColorFilter.mode(
                                            Colors.grey[600]!,
                                            BlendMode.srcIn,
                                          ),
                                  ),
                                  Expanded(child: SizedBox(width: 8)),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).getString('connect_with_apple'),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isAvailable
                                          ? Colors.black
                                          : Colors.grey[600],
                                      fontFamily: 'Bricolage Grotesque',
                                    ),
                                  ),
                                  Expanded(child: SizedBox(width: 8)),
                                  SizedBox(width: 20),
                                  SizedBox(width: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        context.onlyAnimatedRoute(AppRoutes.emailSignup);
                      },
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            SvgPicture.asset(
                              AppIcons.sms,
                              width: 20,
                              height: 20,
                            ),
                            Expanded(child: SizedBox(width: 8)),
                            Text(
                              AppLocalizations.of(
                                context,
                              ).getString('sign_up_with_email'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: 'Bricolage Grotesque',
                              ),
                            ),
                            Expanded(child: SizedBox(width: 8)),
                            SizedBox(width: 20),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: AppLocalizations.of(
                            context,
                          ).getString('by_signing_up'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'Bricolage Grotesque',
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              ).getString('terms_of_service'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' ${AppLocalizations.of(context).getString('and_acknowledge')} ',
                            ),
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              ).getString('privacy_policy'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' ${AppLocalizations.of(context).getString('and')} ',
                            ),
                            TextSpan(
                              text: AppLocalizations.of(
                                context,
                              ).getString('cookie_policy'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
