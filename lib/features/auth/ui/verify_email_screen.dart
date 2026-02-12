import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/go_router.dart';
import '../../../core/widgets/toast.dart';
import '../data/model/resend_verification_request_body.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focusNodes = List.generate(6, (_) => FocusNode());
  bool isLoading = false;

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get otpCode => controllers.map((e) => e.text).join();
  bool get isOtpComplete => otpCode.length == 6;

  void onOtpChanged(String v, int i) {
    if (v.isNotEmpty && i < 5) {
      focusNodes[i + 1].requestFocus();
    } else if (v.isEmpty && i > 0) {
      focusNodes[i - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> onVerifyPressed() async {
    if (!isOtpComplete) {
      showErrorToast(
        context: context,
        message: "Please enter the complete 6-digit code",
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final cubit = context.read<AuthCubit>();
      final ok = await cubit.verifyEmail(widget.email, otpCode);
      if (ok && mounted) {
        showSuccessToast(
          context: context,
          message: "Email verified successfully!",
        );
      } else if (mounted) {
        showErrorToast(
          context: context,
          message: "Verification failed. Please try again.",
        );
      }
    } catch (_) {
      if (mounted) {
        showErrorToast(
          context: context,
          message: "Verification failed. Please try again.",
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> onResendPressed() async {
    try {
      final cubit = context.read<AuthCubit>();
      final ok = await cubit.resendVerificationCode(
        ResendVerificationRequestBody(email: widget.email),
      );
      if (ok && mounted) {
        showSuccessToast(
          context: context,
          message: "Verification code sent to ${widget.email}",
        );
      } else if (mounted) {
        showErrorToast(
          context: context,
          message: "Failed to resend code. Please try again.",
        );
      }
    } catch (_) {
      if (mounted) {
        showErrorToast(
          context: context,
          message: "Failed to resend code. Please try again.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final route = state.user.role == 'pharmacy'
                ? AppPath.pharmacyHome
                : AppPath.home;
            context.go(route);
          });
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor.withValues(alpha: 0.1),
                        theme.primaryColor.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.email_outlined, size: 40),
                ),
                const SizedBox(height: 32),
                Text(
                  "verify_email".tr(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "verification_code_sent".tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (i) {
                    return SizedBox(
                      width: 45,
                      height: 55,
                      child: TextFormField(
                        controller: controllers[i],
                        focusNode: focusNodes[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: theme.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: theme.cardColor,
                        ),
                        onChanged: (v) => onOtpChanged(v, i),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onVerifyPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            "verify".tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "didnt_receive_code".tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                    ),
                    TextButton(
                      onPressed: onResendPressed,
                      child: Text(
                        "resend".tr(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
