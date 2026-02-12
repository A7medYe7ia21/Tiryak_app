import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/go_router.dart';
import 'widget/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int _selectedIndex = 0;

  late final List<Widget> pagesList;

  @override
  void initState() {
    super.initState();
    pagesList = [
      BuildOnBoardingItem(
        imageUrl: "assets/images/wishlist.svg",
        height: 350,
        text: "discover_products".tr(),
      ),
      BuildOnBoardingItem(
        imageUrl: "assets/images/online-shopping.svg",
        height: 350,
        text: "get_orders_delivered".tr(),
      ),
      BuildOnBoardingItem(
        imageUrl: "assets/images/purchase.svg",
        height: 300,
        text: "shop_with_confidence".tr(),
      ),
    ];
    assert(pagesList.length <= 3, 'You can only have up to 3 pages');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: pagesList,
              ),
            ),
            Row(
              spacing: 20,
              children: [
                SizedBox(width: 2),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _controller.animateToPage(
                          _selectedIndex == 0
                              ? pagesList.length - 1
                              : _selectedIndex - 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: _selectedIndex == 0
                          ? Text("skip".tr())
                          : Text("back".tr()),
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: pagesList.length,
                  effect: WormEffect(
                    dotColor: Theme.of(context).colorScheme.secondary,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                  onDotClicked: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                    _controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_selectedIndex == pagesList.length - 1) {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool(AppStrings.onboardingComplete, true);
                          if (context.mounted) {
                            context.go(AppPath.authGate);
                          }
                        } else {
                          _controller.animateToPage(
                            _selectedIndex + 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: _selectedIndex == pagesList.length - 1
                          ? Text("done".tr())
                          : Text("next".tr()),
                    ),
                  ),
                ),
                SizedBox(width: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
