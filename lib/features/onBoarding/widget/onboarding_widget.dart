import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuildOnBoardingItem extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final String text;

  const BuildOnBoardingItem({
    super.key,
    required this.imageUrl,
    this.height,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imageUrl,
          height: height,
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(text),
        ),
      ],
    ),
  );
  }
}