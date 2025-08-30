import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twin_finder/api/models/user_profile_response.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/core/utils/error_handler.dart';

class GenderPage extends StatefulWidget {
  final UserProfileResponse? profileData;

  const GenderPage({super.key, this.profileData});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();

    // Pre-fill gender if available from profile data
    if (widget.profileData != null && widget.profileData!.data.gender != null) {
      selectedGender = widget.profileData!.data.gender;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: SvgPicture.asset(
                  AppIcons.back,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Use animated route for back navigation
                  context.onlyAnimatedRoute(
                    AppRoutes.birthday,
                    arguments: [widget.profileData],
                  );
                },
              ),
            ),
            // Title
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                L.whatIsYourGender(context),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 48 * (-1 / 100),
                  height: 1,
                  fontFamily: 'Bricolage Grotesque',
                ),
              ),
            ),
            SizedBox(height: 32),

            // Male option
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedGender = 'male';
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    SvgPicture.asset(AppIcons.male),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        L.male(context),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedGender == 'male'
                            ? AppColors.backgroundBottom
                            : AppColors.unselected,
                        border: Border.all(
                          color: selectedGender == 'male'
                              ? AppColors.backgroundBottom
                              : AppColors.unselectedBorder,
                          width: 1,
                        ),
                      ),
                      child: selectedGender == 'male'
                          ? SvgPicture.asset(AppIcons.check)
                          : Container(),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),

            // Female option
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedGender = 'female';
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    SvgPicture.asset(AppIcons.female),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        L.female(context),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectedGender == 'female'
                            ? AppColors.backgroundBottom
                            : AppColors.unselected,
                        border: Border.all(
                          color: selectedGender == 'female'
                              ? AppColors.backgroundBottom
                              : AppColors.unselectedBorder,
                          width: 1,
                        ),
                      ),
                      child: selectedGender == 'female'
                          ? SvgPicture.asset(AppIcons.check)
                          : Container(),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),

            const Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Center(
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    final hasError =
                        state is AuthProfileUpdateFailed &&
                        state.fieldName == 'gender';

                    // Show error message if profile update failed
                    if (hasError && mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ErrorHandler.showError(
                          context,
                          'Failed to update gender: ${state.message}',
                          title: 'Gender Update Failed',
                        );
                      });
                    }

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () async {
                              if (selectedGender != null) {
                                HapticFeedback.lightImpact();

                                // Update gender in AuthCubit
                                final authCubit = context.read<AuthCubit>();
                                await authCubit.updateProfile(
                                  gender: selectedGender!,
                                );

                                // Check if update was successful and navigate
                                if (mounted) {
                                  final currentState = authCubit.state;
                                  if (currentState is AuthAuthenticated) {
                                    debugPrint(
                                      'Gender updated successfully, navigating to location page',
                                    );
                                    // Pass profile data to next page
                                    final nextPageProfileData =
                                        widget.profileData ??
                                        UserProfileResponse(
                                          success: true,
                                          message: 'Profile updated',
                                          data: currentState.me.data,
                                        );
                                    debugPrint(
                                      'About to navigate to location page with data: ${nextPageProfileData.data.name}',
                                    );
                                    context.onlyAnimatedRoute(
                                      AppRoutes.location,
                                      arguments: [nextPageProfileData],
                                    );
                                    debugPrint(
                                      'Navigation to location page initiated',
                                    );
                                  }
                                }
                              }
                            },
                      child: Container(
                        height: 56,
                        width: 216,
                        decoration: BoxDecoration(
                          color: selectedGender != null
                              ? AppColors.button
                              : AppColors.button.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  L.continue_(context),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: selectedGender != null
                                        ? AppColors.white
                                        : AppColors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                    fontFamily: 'Bricolage Grotesque',
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
