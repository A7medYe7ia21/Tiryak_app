import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/app_regex.dart';
import '../../../core/router/go_router.dart';
import '../../../core/widgets/toast.dart';
import '../data/model/reset_password_request_body.dart';
import '../logic/auth_cubit.dart';
import 'widgets/reset_password_content.dart';
import 'widgets/reset_password_header.dart';
import 'widgets/reset_password_icon.dart';
import 'widgets/reset_password_title.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with TickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordReset = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Log the received parameters for debugging
    log("Reset Password Screen initialized");
    log("Email: ${widget.email}");
    log("Token: ${widget.token}");

    // Validate that we have the required parameters
    if (widget.email.isEmpty || widget.token.isEmpty) {
      log("ERROR: Missing email or token parameters");
      // Show error and navigate back if parameters are missing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showErrorToast(
              context: context,
              message:
                  "Invalid reset link. Please request a new password reset.");
          Navigator.of(context).pop();
        }
      });
      return;
    }

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "please_enter_password".tr();
    }
    if (!AppRegex.isPasswordValid(value)) {
      return "password_must_contain".tr();
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "please_confirm_password".tr();
    }
    if (value != _passwordController.text) {
      return "passwords_do_not_match".tr();
    }
    return null;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authCubit = context.read<AuthCubit>();

      // Decode the email in case it came URL-encoded from deep link
      final decodedEmail = Uri.decodeComponent(widget.email);

      final ResetPasswordRequestBody requestBody = ResetPasswordRequestBody(
        email: decodedEmail,
        token: widget.token,
        newPassword: _passwordController.text.trim(),
      );

      log("Attempting to reset password for: $decodedEmail");
      log("Using token: ${widget.token}");

      final message = await authCubit.resetPassword(requestBody);

      // Check if the message indicates success
      if (message.toLowerCase().contains('success') ||
          (message.toLowerCase().contains('reset') &&
              !message.toLowerCase().contains('error') &&
              !message.toLowerCase().contains('failed') &&
              !message.toLowerCase().contains('invalid'))) {
        setState(() {
          _isPasswordReset = true;
        });

        // Show success message
        if (mounted) {
          showSuccessToast(
              context: context, message: "password_reset_successfully".tr());

          // Wait a moment then navigate to auth gate
          await Future.delayed(const Duration(seconds: 3));
          if (mounted) {
            context.pushReplacement(AppPath.authGate);
          }
        }
      } else {
        // Show the error message from the API
        if (mounted) {
          showErrorToast(context: context, message: message);
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
            context: context,
            message: "Something went wrong. Please try again later.");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  children: [
                    // Header with back button
                    ResetPasswordHeader(
                      onBackPressed: () => Navigator.of(context).pop(),
                    ),

                    // Main content
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Key icon with gradient background
                              const ResetPasswordIcon(),

                              const SizedBox(height: 40),

                              // Title and subtitle
                              ResetPasswordTitle(email: widget.email),

                              const SizedBox(height: 50),

                              // Content based on state
                              ResetPasswordContent(
                                isPasswordReset: _isPasswordReset,
                                isLoading: _isLoading,
                                formKey: _formKey,
                                passwordController: _passwordController,
                                confirmPasswordController:
                                    _confirmPasswordController,
                                passwordValidator: _validatePassword,
                                confirmPasswordValidator:
                                    _validateConfirmPassword,
                                onResetPassword: _resetPassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
