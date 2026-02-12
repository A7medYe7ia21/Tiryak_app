import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/app_regex.dart';
import 'my_textfield.dart';
import 'password_validations.dart';

class ResetPasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String? Function(String?) passwordValidator;
  final String? Function(String?) confirmPasswordValidator;
  final bool isLoading;
  final VoidCallback onResetPassword;

  const ResetPasswordForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordValidator,
    required this.confirmPasswordValidator,
    required this.isLoading,
    required this.onResetPassword,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    String password = widget.passwordController.text;

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Password field
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            validator: widget.passwordValidator,
            onChanged: (value) {
              setState(() {}); // Trigger rebuild to update password validations
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: "new_password".tr(),
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Password validations
          PasswordValidations(
            hasLowerCase: AppRegex.hasLowerCase(password),
            hasUpperCase: AppRegex.hasUpperCase(password),
            hasSpecialCharacters: AppRegex.hasSpecialCharacter(password),
            hasNumber: AppRegex.hasNumber(password),
            hasMinLength: AppRegex.hasMinLength(password),
          ),

          const SizedBox(height: 24),

          // Confirm password field
          MyTextField(
            controller: widget.confirmPasswordController,
            hintText: "confirm_new_password".tr(),
            obscureText: _obscureConfirmPassword,
            validator: widget.confirmPasswordValidator,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),

          const SizedBox(height: 32),

          // Reset password button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onResetPassword,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "reset_password".tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
