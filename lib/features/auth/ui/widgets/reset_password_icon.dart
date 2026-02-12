import 'package:flutter/material.dart';

class ResetPasswordIcon extends StatelessWidget {
  const ResetPasswordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        Icons.key_rounded,
        size: 60,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
