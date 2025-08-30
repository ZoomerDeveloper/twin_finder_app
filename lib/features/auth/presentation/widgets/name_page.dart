import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

class NamePage extends StatefulWidget {
  final UserProfileResponse? profileData;

  const NamePage({super.key, this.profileData});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  FocusNode focusNode = FocusNode();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pre-fill name if available from profile data
    if (widget.profileData != null &&
        widget.profileData!.data.name.isNotEmpty) {
      nameController.text = widget.profileData!.data.name;
    }

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // Handle focus gained
      } else {
        // Handle focus lost
      }
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
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
                  // Use animated route for back navigation to auth page
                  context.onlyAnimatedRoute(AppRoutes.auth);
                },
              ),
            ),
            // Title
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                L.whatIsYourName(context),
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

            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        focusNode: focusNode,
                        controller: nameController,
                        cursorHeight: 16,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: AppColors.backgroundTop,
                        decoration: InputDecoration(
                          hintText: '',
                          // filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 0,
                          ),

                          // labelText: 'Your Name',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            fontFamily: 'Bricolage Grotesque',
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                  ),

                  IgnorePointer(
                    child: AnimatedAlign(
                      alignment:
                          (focusNode.hasFocus || nameController.text.isNotEmpty)
                          ? Alignment.topLeft
                          : Alignment.centerLeft,
                      duration: Duration(milliseconds: 200),
                      child: AnimatedPadding(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.only(
                          left: 16,
                          top:
                              (focusNode.hasFocus ||
                                  nameController.text.isNotEmpty)
                              ? 8
                              : 0,
                        ),
                        child: AnimatedDefaultTextStyle(
                          style: TextStyle(
                            fontSize:
                                (focusNode.hasFocus ||
                                    nameController.text.isNotEmpty)
                                ? 12
                                : 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Bricolage Grotesque',
                          ),
                          duration: Duration(milliseconds: 200),
                          child: Text('Your Name'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                L.thisWillAppearOnProfile(context),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontFamily: 'Bricolage Grotesque',
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
                        state.fieldName == 'name';

                    // Show error message if profile update failed
                    if (hasError && mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ErrorHandler.showError(
                          context,
                          '${L.error(context)}: ${state.message}',
                          title: L.error(context),
                        );
                      });
                    }

                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () async {
                              if (nameController.text.isNotEmpty) {
                                HapticFeedback.lightImpact();

                                // Update name in AuthCubit
                                final authCubit = context.read<AuthCubit>();
                                await authCubit.updateProfile(
                                  name: nameController.text.trim(),
                                );

                                // Check if update was successful and navigate
                                if (mounted) {
                                  final currentState = authCubit.state;
                                  debugPrint(
                                    'Current state after update: ${currentState.runtimeType}',
                                  );

                                  if (currentState is AuthAuthenticated) {
                                    debugPrint(
                                      'Profile updated successfully, navigating to birthday page',
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
                                      'About to navigate to birthday page with data: ${nextPageProfileData.data.name}',
                                    );
                                    context.onlyAnimatedRoute(
                                      AppRoutes.birthday,
                                      arguments: [nextPageProfileData],
                                    );
                                    debugPrint(
                                      'Navigation to birthday page initiated',
                                    );
                                  } else {
                                    debugPrint(
                                      'Unexpected state after update: ${currentState.runtimeType}',
                                    );
                                  }
                                }
                              }
                            },
                      child: Container(
                        height: 56,
                        width: 216,
                        decoration: BoxDecoration(
                          color: nameController.text.isNotEmpty
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
                                    color: nameController.text.isNotEmpty
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
