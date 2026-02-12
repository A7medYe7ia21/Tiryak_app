import 'package:flutter/material.dart';

import 'reset_password_form.dart';
import 'reset_password_success_state.dart';

class ResetPasswordContent extends StatelessWidget {
  final bool isPasswordReset;
  final bool isLoading;
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? Function(String?) passwordValidator;
  final String? Function(String?) confirmPasswordValidator;
  final VoidCallback onResetPassword;

  const ResetPasswordContent({
    super.key,
    required this.isPasswordReset,
    required this.isLoading,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordValidator,
    required this.confirmPasswordValidator,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    if (isPasswordReset) {
      return const ResetPasswordSuccessState();
    }

    return ResetPasswordForm(
      formKey: formKey,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      passwordValidator: passwordValidator,
      confirmPasswordValidator: confirmPasswordValidator,
      isLoading: isLoading,
      onResetPassword: onResetPassword,
    );
  }
}
