import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/utils/registration_step_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start animations
    _logoController.forward();
    _fadeController.forward();

    // Initialize language and check profile after animations start
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait for animations to complete and enjoy the splash screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Initialize language
      context.read<LanguageCubit>().loadLanguage();

      // Start profile completeness check
      context.read<AuthCubit>().appStarted();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            // Profile is complete, navigate to main page
            context.animatedRoute(AppRoutes.main);
          } else if (state is AuthNeedsProfileSetup ||
              state is AuthNeedsProfileSetupWithData) {
            // Profile is incomplete, check saved step or determine from profile
            final savedStep = await RegistrationStepService.getCurrentStep();

            if (!context.mounted) return;

            final profile = state is AuthNeedsProfileSetupWithData
                ? state.profile
                : null;

            // Determine which route to navigate to based on saved step
            String route;
            switch (savedStep) {
              case RegistrationStepService.stepBirthday:
                route = AppRoutes.birthday;
                break;
              case RegistrationStepService.stepGender:
                route = AppRoutes.gender;
                break;
              case RegistrationStepService.stepLocation:
                route = AppRoutes.location;
                break;
              case RegistrationStepService.stepPhoto:
                route = AppRoutes.faceCapturePage;
                break;
              case RegistrationStepService.stepName:
              default:
                route = AppRoutes.name;
                break;
            }

            // Navigate to the appropriate step with profile data if available
            if (profile != null) {
              context.animatedRoute(route, arguments: [profile]);
            } else {
              context.animatedRoute(route);
            }
          } else if (state is AuthUnauthenticated) {
            // No valid token, navigate to auth page
            context.animatedRoute(AppRoutes.auth);
          } else if (state is AuthMaintenance) {
            // Server is under maintenance, navigate to maintenance page
            context.animatedRoute(AppRoutes.maintenance);
          }
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF3F8E), Color(0xFFFF7A00)],
              stops: [0.0, 1.0],
            ),
          ),
          child: Column(
            children: [
              const Spacer(),

              // Logo with animation
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Image.asset(
                          AppImages.awesome,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // App name with fade animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      L.twinFinder(context),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Bricolage Grotesque',
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Tagline with fade animation
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      'Find Your Twin. Start a New Connection.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        fontFamily: 'Bricolage Grotesque',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),

              const Spacer(),

              // Loading indicator
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Bricolage Grotesque',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
