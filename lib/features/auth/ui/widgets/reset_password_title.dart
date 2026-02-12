import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ResetPasswordTitle extends StatelessWidget {
  final String email;

  const ResetPasswordTitle({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "reset_password_title".tr(),
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "reset_password_subtitle".tr(),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              Uri.decodeComponent(email),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }
}
