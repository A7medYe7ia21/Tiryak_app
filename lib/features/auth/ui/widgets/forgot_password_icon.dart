import 'package:flutter/material.dart';

class ForgotPasswordIcon extends StatelessWidget {
  const ForgotPasswordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(10),
            Theme.of(context).colorScheme.primary.withAlpha(5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(10),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.lock_reset_rounded,
        size: 60,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

