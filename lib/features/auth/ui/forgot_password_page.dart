import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/app_regex.dart';
import '../../../core/router/go_router.dart';
import '../../../core/widgets/toast.dart';
import '../data/model/forget_password_request_body.dart';
import '../logic/auth_cubit.dart';
import 'widgets/forgot_password_content.dart';
import 'widgets/forgot_password_header.dart';
import 'widgets/forgot_password_icon.dart';
import 'widgets/forgot_password_title.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLinkSent = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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
    _emailController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "please_enter_email".tr();
    }
    if (!AppRegex.isEmailValid(value)) {
      return "please_enter_valid_email".tr();
    }
    return null;
  }

  /// Extract email and token from the reset password URL
  Map<String, String>? _parseResetPasswordUrl(String message) {
    try {
      log('Parsing reset URL from message: $message');

      // Look for various URL formats
      final deepLinkPattern = RegExp(r'tryiak://[^\s]*');
      final httpsLinkPattern =
          RegExp(r'https://tryiak[^\s]*reset-password[^\s]*');
      final httpLinkPattern = RegExp(r'http://[^\s]*reset-password[^\s]*');

      String? url;

      // Check for deep link format first
      var match = deepLinkPattern.firstMatch(message);
      if (match != null) {
        url = match.group(0)!;
        log('Found deep link URL: $url');
      } else {
        // Check for HTTPS format
        match = httpsLinkPattern.firstMatch(message);
        if (match != null) {
          url = match.group(0)!;
          log('Found HTTPS URL: $url');
        } else {
          // Fallback to HTTP format
          match = httpLinkPattern.firstMatch(message);
          if (match != null) {
            url = match.group(0)!;
            log('Found HTTP URL: $url');
          }
        }
      }

      if (url != null) {
        // Handle nested URL structure by finding the last occurrence of token and email
        // Split by 'token=' and get the last occurrence for the actual token
        final tokenParts = url.split('token=');
        if (tokenParts.length >= 2) {
          // Get the last part after 'token='
          final lastTokenPart = tokenParts.last;

          // Find where the token ends (either at '&' or end of string)
          final ampersandIndex = lastTokenPart.indexOf('&');
          final actualToken = ampersandIndex != -1
              ? lastTokenPart.substring(0, ampersandIndex)
              : lastTokenPart;

          // Find email parameter
          final emailPattern = RegExp(r'email=([^&\s]+)');
          final emailMatch = emailPattern.firstMatch(url);

          if (emailMatch != null && actualToken.isNotEmpty) {
            final email = emailMatch.group(1)!;

            log('Extracted token: $actualToken');
            log('Extracted email: $email');

            return {
              'token': actualToken,
              'email': Uri.decodeComponent(email),
            };
          }
        }
      }
      return null;
    } catch (e) {
      log('Error parsing reset password URL: $e');
      return null;
    }
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authCubit = context.read<AuthCubit>();
      final ForgetPasswordRequestBody requestBody = ForgetPasswordRequestBody(
        email: _emailController.text.trim(),
      );
      final message = await authCubit.forgotPassword(requestBody);
      log("Attempting to send reset email to: ${_emailController.text.trim()}");
      log("Full response message: $message");
      log("Message type: ${message.runtimeType}");
      log("Message length: ${message.length}");

      // Check if the message indicates success (no error keywords)
      if (message.toLowerCase().contains('success') ||
          message.toLowerCase().contains('sent') &&
              !message.toLowerCase().contains('error') &&
              !message.toLowerCase().contains('failed') &&
              !message.toLowerCase().contains('not found')) {
        // Try to parse reset password URL from the message
        final resetData = _parseResetPasswordUrl(message);

        if (resetData != null && mounted) {
          // Navigate directly to reset password screen with extracted data
          showSuccessToast(
              context: context, message: "reset_link_sent_successfully".tr());

          await Future.delayed(const Duration(seconds: 1));

          if (mounted) {
            context.push(
              '${AppPath.resetPassword}?email=${Uri.encodeComponent(resetData['email']!)}&token=${resetData['token']}',
            );
          }
        } else {
          // If URL parsing fails, show a message with manual navigation option
          log('URL parsing failed, showing manual option');

          // Show success message - in production, user would check email
          if (mounted) {
            showSuccessToast(
                context: context, message: "reset_link_sent_successfully".tr());

            // In production, users will click the link in their email
            // For development/testing purposes, we can show a message
            // Remove this navigation and let users use the email link

            // Show info that user needs to check their email
            await Future.delayed(const Duration(seconds: 2));

            if (mounted) {
              showSuccessToast(
                  context: context,
                  message:
                      "Please check your email and click the reset password link to continue.");

              // Clear the form and go back to login after showing the message
              _emailController.clear();
              await Future.delayed(const Duration(seconds: 3));

              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          }
        }
      } else {
        // Show the friendly error message from the API
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
                    ForgotPasswordHeader(
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
                              // Lock icon with gradient background
                              const ForgotPasswordIcon(),

                              const SizedBox(height: 40),

                              // Title and subtitle
                              const ForgotPasswordTitle(),

                              const SizedBox(height: 50),

                              // Content based on state
                              ForgotPasswordContent(
                                isLinkSent: _isLinkSent,
                                isLoading: _isLoading,
                                formKey: _formKey,
                                emailController: _emailController,
                                emailValidator: _validateEmail,
                                onSendResetLink: _sendResetLink,
                                onResendPressed: () {
                                  setState(() {
                                    _isLinkSent = false;
                                    _emailController.clear();
                                  });
                                },
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
