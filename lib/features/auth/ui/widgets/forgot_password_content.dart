import 'package:flutter/material.dart';

import 'forgot_password_email_form.dart';
import 'forgot_password_success_state.dart';
import 'reset_link_button.dart';

class ForgotPasswordContent extends StatelessWidget {
  final bool isLinkSent;
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? Function(String?) emailValidator;
  final VoidCallback onSendResetLink;
  final VoidCallback onResendPressed;

  const ForgotPasswordContent({
    super.key,
    required this.isLinkSent,
    required this.isLoading,
    required this.formKey,
    required this.emailController,
    required this.emailValidator,
    required this.onSendResetLink,
    required this.onResendPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLinkSent) {
      return Column(
        children: [
          ForgotPasswordEmailForm(
            formKey: formKey,
            emailController: emailController,
            validator: emailValidator,
          ),
          const SizedBox(height: 40),
          ResetLinkButton(isLoading: isLoading, onPressed: onSendResetLink),
        ],
      );
    } else {
      return ForgotPasswordSuccessState(onResendPressed: onResendPressed);
    }
  }
}
