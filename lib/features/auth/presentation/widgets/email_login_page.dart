import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/core/utils/error_handler.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key, this.preFilledEmail});

  final String? preFilledEmail;

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));

    // Pre-fill email if provided
    if (widget.preFilledEmail != null) {
      _emailController.text = widget.preFilledEmail!;
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _validEmail {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;
    final re = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$");
    return re.hasMatch(email);
  }

  bool get _validPassword {
    return _passwordController.text.trim().length >= 8;
  }

  bool get _canSubmit => _validEmail && _validPassword && !_loading;

  Future<void> _submit() async {
    if (!_canSubmit) return;

    HapticFeedback.lightImpact();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text.trim();

      final authCubit = context.read<AuthCubit>();
      await authCubit.login(email, password);

      // Navigation will be handled by BlocListener in AuthPage
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = e.toString();
      });
      // Show error toast
      ErrorHandler.showError(
        context,
        _error ?? L.error(context),
        title: L.error(context),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                  context.onlyAnimatedRoute(AppRoutes.auth);
                },
              ),
            ),

            // Title
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                  L.signInWithEmail(context),
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

            // Email field
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
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        cursorHeight: 16,
                        cursorColor: AppColors.backgroundTop,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: '',
                          fillColor: Colors.white,
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

            // Password field
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
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        cursorHeight: 16,
                        cursorColor: AppColors.backgroundTop,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: '',
                          fillColor: Colors.white,
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
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
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

            // const SizedBox(height: 16),

            // // Error message
            // if (_error != null)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: Text(
            //       _error!,
            //       style: const TextStyle(
            //         color: Colors.red,
            //         fontSize: 14,
            //         fontFamily: 'Bricolage Grotesque',
            //       ),
            //     ),
            //   ),
            const SizedBox(height: 8),

            // Info text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                  L.enterEmailAndPassword(context),
                  style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                  fontFamily: 'Bricolage Grotesque',
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Continue button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                                    L.signIn(context),
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

            // Sign up link
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.onlyAnimatedRoute(AppRoutes.emailVerification);
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
                          text: '${L.dontHaveAccount(context)} ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        TextSpan(
                                                      text: L.signUp(context),
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
            );
          },
        ),
      ),
    );
  }
}
