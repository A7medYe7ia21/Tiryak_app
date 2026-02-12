import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/spacing.dart';

class PasswordValidations extends StatelessWidget {
  final bool hasLowerCase;
  final bool hasUpperCase;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  final bool hasMinLength;
  const PasswordValidations({
    super.key,
    required this.hasLowerCase,
    required this.hasUpperCase,
    required this.hasSpecialCharacters,
    required this.hasNumber,
    required this.hasMinLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildValidationRow(context, 'at_least_lower'.tr(), hasLowerCase),
        verticalSpace(2),
        buildValidationRow(context, 'at_least_upper'.tr(), hasUpperCase),
        verticalSpace(2),
        buildValidationRow(
            context, 'at_least_special'.tr(), hasSpecialCharacters),
        verticalSpace(2),
        buildValidationRow(context, 'at_least_number'.tr(), hasNumber),
        verticalSpace(2),
        buildValidationRow(context, 'at_least_8_chars'.tr(), hasMinLength),
      ],
    );
  }

  Widget buildValidationRow(
      BuildContext context, String text, bool hasValidated) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 2.5,
          backgroundColor: Colors.grey,
        ),
        horizontalSpace(6),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            decoration: hasValidated ? TextDecoration.lineThrough : null,
            decorationColor: Colors.grey,
            decorationThickness: 2,
            color: hasValidated
                ? Colors.blueAccent
                : Theme.of(context).colorScheme.primary,
          ),
        )
      ],
    );
  }
}
