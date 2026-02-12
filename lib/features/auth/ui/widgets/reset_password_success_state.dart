import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordSuccessState extends StatelessWidget {
  const ResetPasswordSuccessState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Success icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 60,
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 32),

        // Success message
        Text(
          "password_reset_success_title".tr(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "password_reset_success_subtitle".tr(),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 32),

        // Loading indicator
        const CircularProgressIndicator(),

        const SizedBox(height: 16),

        Text(
          "redirecting_to_login".tr(),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
