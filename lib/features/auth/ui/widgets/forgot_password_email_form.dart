import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'my_textfield.dart';

class ForgotPasswordEmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final String? Function(String?) validator;

  const ForgotPasswordEmailForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "enter_your_email".tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          MyTextField(
            controller: emailController,
            hintText: "email".tr(),
            obscureText: false,
            validator: validator,
            suffixIcon: Icon(
              Icons.email_outlined,
              color: Theme.of(context).colorScheme.primary.withAlpha(60),
            ),
          ),
        ],
      ),
    );
  }
}
