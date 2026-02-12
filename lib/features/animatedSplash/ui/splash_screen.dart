import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/router/go_router.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../auth/logic/auth_state.dart';
import '../widget/logo_video_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;
  bool _splashTimerCompleted = false;

  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        _splashTimerCompleted = true;
        _checkNavigationConditions();
      }
    });
  }

  void _checkNavigationConditions() {
    if (!_splashTimerCompleted || _hasNavigated) return;
    _handleNavigationFlow();
  }

  Future<void> _handleNavigationFlow() async {
    if (_hasNavigated) return;

    final isOnboardingComplete =
        await SharedPrefHelper.getBool(AppStrings.onboardingComplete);

    if (!mounted) return;

    _hasNavigated = true;

    if (!isOnboardingComplete) {
      context.go(AppPath.onBoarding);
    } else {
      final authState = context.read<AuthCubit>().state;
      authState.maybeWhen(
        authenticated: (user) => context.go(AppPath.home),
        unauthenticated: () => context.go(AppPath.userTypeSelection),
        orElse: () {
          context.go(AppPath.userTypeSelection);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (_splashTimerCompleted && !_hasNavigated) {
          _handleNavigationFlow();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade300,
        body: const Center(
          child: LogoVideoSplash(videoPath: 'assets/tiryak_animation.mp4'),
        ),
      ),
    );
  }
}
