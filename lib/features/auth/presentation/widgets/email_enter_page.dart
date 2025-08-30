import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailEnterPage extends StatefulWidget {
  const EmailEnterPage({super.key, this.onSent, this.codePageRouteName});

  final void Function(String email)? onSent;
  final String? codePageRouteName;

  @override
  State<EmailEnterPage> createState() => _EmailEnterPageState();
}

class _EmailEnterPageState extends State<EmailEnterPage> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _loading = false;
  String? _error;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _confirmPasswordFocus.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _validEmail {
    final v = _emailController.text.trim();
    if (v.isEmpty) return false;
    final re = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$");
    return re.hasMatch(v);
  }

  bool get _validPassword {
    final v = _passwordController.text.trim();
    return v.length >= 8;
  }

  bool get _validConfirmPassword {
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();
    return confirm.isNotEmpty && password == confirm;
  }

  bool get _canSubmit {
    return _validEmail && _validPassword && _validConfirmPassword && !_loading;
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    HapticFeedback.lightImpact();
    setState(() {
      _loading = true;
      _error = null;
    });
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    try {
      // Call AuthCubit.register() to initiate email registration with password
      context.read<AuthCubit>().register(email, password);
      // Navigation will be handled by BlocListener when AuthEmailCodeSent is emitted
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = e.toString();
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
            _error = state.message;
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
            _error = null;
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
                  icon: SvgPicture.asset(AppIcons.back, color: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).maybePop();
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Title
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
                    Positioned(
                      top: 28, // Позиционируем по центру между label и низом
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: TextField(
                            focusNode: _emailFocus,
                            controller: _emailController,
                            cursorHeight: 16,
                            cursorColor: AppColors.backgroundTop,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            textAlignVertical: TextAlignVertical.center,
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
                            // Removed onSubmitted to prevent auto-submission on Enter
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

              // Password field with floating label
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
                          focusNode: _passwordFocus,
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          cursorHeight: 16,
                          cursorColor: AppColors.backgroundTop,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.newPassword],
                          textAlignVertical: TextAlignVertical.center,
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
                          // Removed onSubmitted to prevent auto-submission on Enter
                        ),
                      ),
                    ),
                    // Floating label
                    IgnorePointer(
                      child: AnimatedAlign(
                        alignment:
                            (_passwordFocus.hasFocus ||
                                _passwordController.text.isNotEmpty)
                            ? Alignment.topLeft
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.only(
                            left: 16,
                            top:
                                (_passwordFocus.hasFocus ||
                                    _passwordController.text.isNotEmpty)
                                ? 8
                                : 0,
                          ),
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize:
                                  (_passwordFocus.hasFocus ||
                                      _passwordController.text.isNotEmpty)
                                  ? 12
                                  : 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Text(L.enterPassword(context)),
                          ),
                        ),
                      ),
                    ),
                    // Show/hide password button
                    Positioned(
                      right: 16,
                      top: 20,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Password field with floating label
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
                          focusNode: _confirmPasswordFocus,
                          controller: _confirmPasswordController,
                          obscureText: !_showConfirmPassword,
                          cursorHeight: 16,
                          cursorColor: AppColors.backgroundTop,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          autofillHints: const [AutofillHints.newPassword],
                          textAlignVertical: TextAlignVertical.center,
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
                          // Removed onSubmitted to prevent auto-submission on Enter
                        ),
                      ),
                    ),
                    // Floating label
                    IgnorePointer(
                      child: AnimatedAlign(
                        alignment:
                            (_confirmPasswordFocus.hasFocus ||
                                _confirmPasswordController.text.isNotEmpty)
                            ? Alignment.topLeft
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.only(
                            left: 16,
                            top:
                                (_confirmPasswordFocus.hasFocus ||
                                    _confirmPasswordController.text.isNotEmpty)
                                ? 8
                                : 0,
                          ),
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize:
                                  (_confirmPasswordFocus.hasFocus ||
                                      _confirmPasswordController
                                          .text
                                          .isNotEmpty)
                                  ? 12
                                  : 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Text(L.confirmYourPassword(context)),
                          ),
                        ),
                      ),
                    ),
                    // Show/hide confirm password button
                    Positioned(
                      right: 16,
                      top: 20,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        child: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Error message removed - not visible under inputs
              const SizedBox(height: 8),
              // Description text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  L.enterVerificationCode(context),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
              ),

              const Spacer(),

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
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }
}
