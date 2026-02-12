import 'package:flutter/material.dart';

class HomeBannerWidget extends StatefulWidget {
  final List<String> banners;

  const HomeBannerWidget({
    super.key,
    required this.banners,
  });

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageHeight = screenHeight * 0.25;
    final dotSize = screenWidth * 0.02;
    final dotActiveSize = screenWidth * 0.025;
    final spacing = screenHeight * 0.01;

    return Column(
      children: [
        SizedBox(
          height: imageHeight,
          width: screenWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.banners.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  widget.banners[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
          ),
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              width: currentIndex == index ? dotActiveSize : dotSize,
              height: currentIndex == index ? dotActiveSize : dotSize,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
