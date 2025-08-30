import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/core/utils/app_images.dart';

class EmailCodePage extends StatefulWidget {
  const EmailCodePage({
    super.key,
    required this.email,
    this.onVerified,
    this.codeLength = 6,
    this.resendSeconds = 60,
  });

  final String email;
  final void Function()? onVerified;
  final int codeLength;
  final int resendSeconds;

  @override
  State<EmailCodePage> createState() => _EmailCodePageState();
}

class _EmailCodePageState extends State<EmailCodePage> {
  final FocusNode _focus = FocusNode();
  final TextEditingController _codeController = TextEditingController();
  late int _secondsLeft;
  Timer? _timer;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.resendSeconds;
    _codeController.addListener(() => setState(() {}));
    _focus.addListener(() => setState(() {}));
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  bool get _ready => _codeController.text.trim().length >= widget.codeLength;

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final txt = data?.text?.replaceAll(RegExp(r'[^A-Za-z0-9]'), '') ?? '';
    if (txt.isEmpty) return;
    final cut = txt.substring(0, txt.length.clamp(0, widget.codeLength));
    _codeController.text = cut;
    _codeController.selection = TextSelection.fromPosition(
      TextPosition(offset: _codeController.text.length),
    );
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_ready || _loading) return;
    HapticFeedback.lightImpact();
    setState(() {
      _loading = true;
      _error = null;
    });
    final code = _codeController.text.trim();

    try {
      // Call AuthCubit.confirmEmail() to complete registration
      context.read<AuthCubit>().confirmEmail(widget.email, code);

      // Success will be handled by BlocListener
      HapticFeedback.mediumImpact();
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      // Show error toast
      ErrorHandler.showError(
        context,
        _error ?? 'Failed to verify code',
        title: 'Verification Failed',
      );
    }
  }

  Future<void> _resend() async {
    if (_loading) return;
    HapticFeedback.lightImpact();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Call AuthCubit.resendCode() to resend verification code
      context.read<AuthCubit>().resendCode(widget.email);
      // Success will be handled by BlocListener
      HapticFeedback.mediumImpact();
    } catch (e) {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      // Show error toast
      ErrorHandler.showError(context, e.toString(), title: 'Resend Failed');
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
            title: 'Verification Failed',
          );
        } else if (state is AuthEmailCodeSent) {
          // Successfully resent code
          setState(() {
            _loading = false;
            _error = null;
          });
          // Start timer for resend
          _startTimer();
          // Show success toast
          ErrorHandler.showSuccess(
            context,
            'Verification code resent to your email!',
          );
        } else if (state is AuthAuthenticated ||
            state is AuthNeedsProfileSetupWithData) {
          // Registration successful, navigate to profile setup
          if (mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.name, (route) => false);
          }
        }
      },
      child: Scaffold(
        body: BackgroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Enter the\nverification code',
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'We sent it to ${widget.email}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Code input with pinput
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Pinput(
                  controller: _codeController,
                  length: widget.codeLength,
                  focusNode: _focus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onCompleted: (pin) {
                    // Auto-submit when code is complete
                    _submit();
                  },
                  defaultPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width / 6 - 10,
                    height: 70,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Bricolage Grotesque',
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width / 6 - 10,
                    height: 70,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Bricolage Grotesque',
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.button.withOpacity(0.25),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: MediaQuery.of(context).size.width / 6 - 10,
                    height: 70,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: 'Bricolage Grotesque',
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontFamily: 'Bricolage Grotesque',
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      _secondsLeft > 0
                          ? 'Resend in 0:${_secondsLeft.toString().padLeft(2, '0')}'
                          : 'Didn\'t get the email?',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Bricolage Grotesque',
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _secondsLeft == 0 ? _resend : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _secondsLeft == 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                    // const SizedBox(width: 16),
                    // GestureDetector(
                    //   onTap: _pasteFromClipboard,
                    //   child: const Text(
                    //     'Paste',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w700,
                    //       color: Colors.white,
                    //       decoration: TextDecoration.underline,
                    //       fontFamily: 'Bricolage Grotesque',
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: _ready && !_loading ? _submit : null,
                    child: Container(
                      height: 56,
                      width: 216,
                      decoration: BoxDecoration(
                        color: (_ready && !_loading)
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
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: (_ready && !_loading)
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
