import 'package:flutter/material.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/features/auth/presentation/pages/auth_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/features/auth/presentation/widgets/birth_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/email_code_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/email_enter_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/email_login_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/email_signup_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/face_capture_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/gender_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/info_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/location_page.dart';
import 'package:twin_finder/features/auth/presentation/widgets/name_page.dart';
import 'package:twin_finder/features/main/presentation/pages/main_page.dart';
import 'package:twin_finder/features/splash/presentation/pages/splash_screen.dart';
import 'package:twin_finder/api/models/user_profile_response.dart';
import 'package:twin_finder/features/main/presentation/pages/change_profile_details_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(settings, const SplashScreen());
      case AppRoutes.auth:
        return _buildRoute(settings, const AuthPage());
      case AppRoutes.emailLogin:
        return _buildRoute(
          settings,
          EmailLoginPage(preFilledEmail: settings.arguments as String?),
        );
      case AppRoutes.emailSignup:
        return _buildRoute(settings, const EmailSignupPage());
      case AppRoutes.name:
        return _buildRoute(
          settings,
          NamePage(
            profileData:
                (settings.arguments as List?)?[0] as UserProfileResponse?,
          ),
        );
      case AppRoutes.birthday:
        return _buildRoute(
          settings,
          BirthPage(
            profileData:
                (settings.arguments as List?)?[0] as UserProfileResponse?,
          ),
        );
      case AppRoutes.gender:
        return _buildRoute(
          settings,
          GenderPage(
            profileData:
                (settings.arguments as List?)?[0] as UserProfileResponse?,
          ),
        );
      case AppRoutes.location:
        return _buildRoute(
          settings,
          LocationPage(
            profileData:
                (settings.arguments as List?)?[0] as UserProfileResponse?,
          ),
        );
      case AppRoutes.info:
        return _buildRoute(settings, const InfoPage());
      case AppRoutes.faceCapturePage:
        return _buildRoute(settings, const FaceCapturePage());
      case AppRoutes.emailVerification:
        return _buildRoute(settings, const EmailEnterPage());
      case AppRoutes.emailCode:
        return _buildRoute(
          settings,
          EmailCodePage(
            email: _extractEmailFromArguments(settings.arguments),
            onVerified: _extractCallbackFromArguments(settings.arguments),
            codeLength: _extractCodeLengthFromArguments(settings.arguments),
            resendSeconds: _extractResendSecondsFromArguments(
              settings.arguments,
            ),
          ),
        );
      case AppRoutes.home:
        return _buildRoute(
          settings,
          const BackgroundWidget(child: Center(child: Text('Home Page'))),
        );
      case AppRoutes.main:
        return _buildRoute(settings, const MainPage());
      case AppRoutes.changeProfileDetails:
        return _buildRoute(settings, const ChangeProfileDetailsPage());
      default:
        return _buildRoute(settings, const AuthPage());
    }
  }

  static Route<dynamic> _buildRoute(RouteSettings settings, Widget page) {
    return SlideAndFadeRoute(page: page, settings: settings);
  }

  static String _extractEmailFromArguments(dynamic arguments) {
    if (arguments is String) {
      return arguments;
    } else if (arguments is List) {
      return arguments[0] as String;
    }
    return '';
  }

  static void Function()? _extractCallbackFromArguments(dynamic arguments) {
    if (arguments is List) {
      return arguments[1] as void Function()?;
    }
    return null;
  }

  static int _extractCodeLengthFromArguments(dynamic arguments) {
    if (arguments is List) {
      return arguments[2] as int? ?? 6;
    }
    return 6;
  }

  static int _extractResendSecondsFromArguments(dynamic arguments) {
    if (arguments is List) {
      return arguments[3] as int? ?? 60;
    }
    return 60;
  }
}

class SlideAndFadeRoute extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;

  SlideAndFadeRoute({required this.page, required this.settings})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        settings: settings,
      );
}
