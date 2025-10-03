import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twin_finder/api/models/user_profile_response.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_formaters.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/core/utils/registration_step_service.dart';

class BirthPage extends StatefulWidget {
  final UserProfileResponse? profileData;

  const BirthPage({super.key, this.profileData});

  @override
  State<BirthPage> createState() => _BirthPageState();
}

class _BirthPageState extends State<BirthPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController birthController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    // Pre-fill birthday if available from profile data
    if (widget.profileData != null &&
        widget.profileData!.data.birthday != null) {
      selectedDate = widget.profileData!.data.birthday;
      birthController.text = formatDateToString(selectedDate!);
    }

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // Handle focus gained
      } else {
        // Handle focus lost
      }
      setState(() {});
    });
    birthController.addListener(() {
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
                  // Use animated route for back navigation
                  context.onlyAnimatedRoute(
                    AppRoutes.name,
                    arguments: [widget.profileData],
                  );
                },
              ),
            ),

            // Title
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                L.whenWereYouBorn(context),
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
                        onTap: () {
                          // Open CupertinoDateTimePicker
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return Material(
                                child: Container(
                                  height: 350,
                                  color: AppColors.white,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (selectedDate == null) {
                                            birthController.text =
                                                formatDateToString(
                                                  DateTime.now(),
                                                );
                                          } else {
                                            birthController.text =
                                                formatDateToString(
                                                  selectedDate!,
                                                );
                                          }
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 50,
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                            right: 30,
                                          ),
                                          child: Text(
                                            L.continue_(context),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.text,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Bricolage Grotesque',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 300,
                                        color: AppColors.white,
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.date,
                                          initialDateTime:
                                              birthController.text.isNotEmpty
                                              ? DateTime.tryParse(
                                                      birthController.text,
                                                    ) ??
                                                    DateTime.now()
                                              : DateTime.now(),
                                          maximumDate:
                                              DateTime.now(), // Нельзя выбрать дату в будущем
                                          onDateTimeChanged: (date) {
                                            selectedDate = date;
                                            // birthController.text =
                                            //     formatDateToString(date);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        readOnly: true,
                        controller: birthController,
                        cursorHeight: 16,
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
                          (focusNode.hasFocus ||
                              birthController.text.isNotEmpty)
                          ? Alignment.topLeft
                          : Alignment.centerLeft,
                      duration: Duration(milliseconds: 200),
                      child: AnimatedPadding(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.only(
                          left: 16,
                          top:
                              (focusNode.hasFocus ||
                                  birthController.text.isNotEmpty)
                              ? 8
                              : 0,
                        ),
                        child: AnimatedDefaultTextStyle(
                          style: TextStyle(
                            fontSize:
                                (focusNode.hasFocus ||
                                    birthController.text.isNotEmpty)
                                ? 12
                                : 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Bricolage Grotesque',
                          ),
                          duration: Duration(milliseconds: 200),
                          child: Text(L.birthday(context)),
                        ),
                      ),
                    ),
                  ),
                ],
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
                        state.fieldName == 'birthday';

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

                    // Проверяем, есть ли дата для продолжения
                    final hasDate =
                        birthController.text.isNotEmpty && selectedDate != null;

                    return GestureDetector(
                      onTap: isLoading || !hasDate
                          ? null
                          : () async {
                              if (birthController.text.isNotEmpty &&
                                  selectedDate != null) {
                                // Проверяем минимальный возраст (дополнительная проверка)
                                if (!isMinimumAgeReached(selectedDate!)) {
                                  ErrorHandler.showError(
                                    context,
                                    'You must be at least 18 years old to continue',
                                    title: 'Age Requirement',
                                  );
                                  return;
                                }
                                HapticFeedback.lightImpact();

                                // Update birthday in AuthCubit
                                final authCubit = context.read<AuthCubit>();
                                await authCubit.updateProfile(
                                  birthday: selectedDate!,
                                );

                                // Check if update was successful and navigate
                                if (mounted) {
                                  final currentState = authCubit.state;
                                  if (currentState is AuthAuthenticated ||
                                      currentState
                                          is AuthNeedsProfileSetupWithData) {
                                    debugPrint(
                                      'Birthday updated successfully, navigating to gender page',
                                    );

                                    // Save next step before navigating
                                    await RegistrationStepService.saveStep(
                                      RegistrationStepService.stepGender,
                                    );

                                    if (!mounted) return;

                                    // Pass profile data to next page
                                    final nextPageProfileData =
                                        currentState is AuthAuthenticated
                                        ? currentState.me
                                        : (currentState
                                                  as AuthNeedsProfileSetupWithData)
                                              .profile;
                                    debugPrint(
                                      'About to navigate to gender page with data: ${nextPageProfileData.data.name}',
                                    );
                                    context.onlyAnimatedRoute(
                                      AppRoutes.gender,
                                      arguments: [nextPageProfileData],
                                    );
                                    debugPrint(
                                      'Navigation to gender page initiated',
                                    );
                                  }
                                }
                              }
                            },
                      child: Container(
                        height: 56,
                        width: 216,
                        decoration: BoxDecoration(
                          color: hasDate
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
                                    color: hasDate
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
