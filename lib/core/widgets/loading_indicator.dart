import 'dart:io';

import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: Platform.isIOS ? 1.5 : 1,
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
