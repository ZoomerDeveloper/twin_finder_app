import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';

class EmailSignupPage extends StatefulWidget {
  const EmailSignupPage({super.key});

  @override
  State<EmailSignupPage> createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends State<EmailSignupPage> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _emailController.addListener(_onTextChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool get _validEmail {
    final v = _emailController.text.trim();
    if (v.isEmpty) return false;
    // Simple, robust email regex
    final re = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$");
    return re.hasMatch(v);
  }

  bool get _canSubmit {
    return _validEmail && !_loading;
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    HapticFeedback.lightImpact();
    setState(() {
      _loading = true;
    });
    final email = _emailController.text.trim().toLowerCase();

    try {
      // Call AuthCubit.register() to initiate email registration
      context.read<AuthCubit>().register(email);
      // Navigation will be handled by BlocListener when AuthEmailCodeSent is emitted
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _loading = false;
      });
      // Error will be shown by BlocListener, no need to show it here
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          setState(() {
            _loading = false;
          });
          // Show error toast
          ErrorHandler.showError(
            context,
            state.message,
            title: L.error(context),
          );
        } else if (state is AuthEmailCodeSent) {
          // Successfully sent code, navigate to code verification page
          setState(() {
            _loading = false;
          });
          // Show success toast
          ErrorHandler.showSuccess(context, L.codeSent(context));
          // Navigate to code verification page
          if (mounted) {
            context.onlyAnimatedRoute(
              AppRoutes.emailCode,
              arguments: state.email,
            );
          }
        }
      },
      child: Scaffold(
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
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.onlyAnimatedRoute(AppRoutes.auth);
                  },
                ),
              ),

              // Title
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  L.signUpWithEmail(context),
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
              const SizedBox(height: 32),

              // Email field with floating label
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                          focusNode: _emailFocus,
                          controller: _emailController,
                          cursorHeight: 16,
                          cursorColor: AppColors.backgroundTop,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          textAlignVertical: TextAlignVertical.center,
                          onSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                              fontFamily: 'Bricolage Grotesque',
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Bricolage Grotesque',
                          ),
                        ),
                      ),
                    ),
                    // Floating label
                    IgnorePointer(
                      child: AnimatedAlign(
                        alignment:
                            (_emailFocus.hasFocus ||
                                _emailController.text.isNotEmpty)
                            ? Alignment.topLeft
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.only(
                            left: 16,
                            top:
                                (_emailFocus.hasFocus ||
                                    _emailController.text.isNotEmpty)
                                ? 8
                                : 0,
                          ),
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize:
                                  (_emailFocus.hasFocus ||
                                      _emailController.text.isNotEmpty)
                                  ? 12
                                  : 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Text(L.enterEmail(context)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Info text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  L.enterVerificationCode(context),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
              ),

              const Expanded(child: SizedBox()),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _canSubmit ? _submit : null,
                    child: Container(
                      height: 56,
                      width: 216,
                      decoration: BoxDecoration(
                        color: _canSubmit
                            ? AppColors.button
                            : AppColors.button.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: _loading
                            ? const SizedBox(
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
                                  color: _canSubmit
                                      ? AppColors.white
                                      : AppColors.white.withOpacity(0.4),
                                  fontFamily: 'Bricolage Grotesque',
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),

              // Sign in link
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.onlyAnimatedRoute(AppRoutes.emailLogin);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                        children: [
                          TextSpan(
                            text: '${L.alreadyHaveAccount(context)} ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          TextSpan(
                            text: L.signIn(context),
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
