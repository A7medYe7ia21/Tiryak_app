import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth_gate.dart';
import '../../features/animatedSplash/ui/splash_screen.dart';
import '../../features/auth/ui/reset_password_page.dart';
import '../../features/auth/ui/verify_email_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/onBoarding/onboarding_screen.dart';
import '../../features/onBoarding/user_type_selection_screen.dart';
import '../../features/pharmacy/ui/pharmacy_home_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/orders/ui/orders_screen.dart';
import 'wrapper.dart';

class AppPath {
  AppPath._();
  static const String splash = '/';
  static const String onBoarding = '/onBoarding';
  static const String authGate = '/authGate';
  static const String verifyEmail = '/verifyEmail';
  static const String resetPassword = '/resetPassword';
  static const String home = "/home";
  static const String search = "/search";
  static const String cart = "/cart";
  static const String reminders = "/reminders";
  static const String account = "/account";
  static const String userTypeSelection = "/userTypeSelection";
  static const String pharmacyHome = "/pharmacyHome";
  static const String pharmacyRequests = "/pharmacyRequests";
  static const String pharmacyProfile = "/pharmacyProfile";
}

class AppPathName {
  AppPathName._();
  static const String splash = "Splash";
  static const String onBoarding = "OnBoarding";
  static const String authGate = "AuthGate";
  static const String verifyEmail = "VerifyEmail";
  static const String resetPassword = "ResetPassword";
  static const String home = "Home";
  static const String search = "Search";
  static const String cart = "Cart";
  static const String reminders = "Reminders";
  static const String account = "Account";
  static const String userTypeSelection = "UserTypeSelection";
  static const String pharmacyHome = "PharmacyHome";
  static const String pharmacyRequests = "PharmacyRequests";
  static const String pharmacyProfile = "PharmacyProfile";
}

class AppNavigation {
  AppNavigation._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorHome = GlobalKey<NavigatorState>();
  static final _shellNavigatorOrders = GlobalKey<NavigatorState>();
  static final _shellNavigatorAccount = GlobalKey<NavigatorState>();

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: AppPath.userTypeSelection,
    debugLogDiagnostics: true, // Enable for debugging deep links
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      // Handle deep link redirects
      final uri = state.uri;
      print("Router redirect - URI: $uri");
      print("Router redirect - Scheme: ${uri.scheme}");
      print("Router redirect - Host: ${uri.host}");
      print("Router redirect - Path: ${uri.path}");
      print("Router redirect - Query: ${uri.queryParameters}");

      // Handle deep links for reset password
      bool isResetPasswordLink = false;

      // Check for custom scheme: tryiak://reset-password
      if (uri.scheme == 'tryiak' &&
          (uri.host == 'reset-password' || uri.path == '/reset-password')) {
        isResetPasswordLink = true;
      }

      // Check for HTTPS scheme: https://tryiak/reset-password
      if (uri.scheme == 'https' &&
          uri.host == 'tryiak' &&
          uri.path.contains('reset-password')) {
        isResetPasswordLink = true;
      }

      // Check for HTTP scheme: http://tiryak/reset-password
      if (uri.scheme == 'http' &&
          uri.host == 'tiryak' &&
          uri.path.contains('reset-password')) {
        isResetPasswordLink = true;
      }

      if (isResetPasswordLink) {
        String email = uri.queryParameters['email'] ?? '';
        String token = uri.queryParameters['token'] ?? '';

        // Handle nested token structure - extract the actual token from nested URL
        if (token.contains('token=')) {
          // Split by 'token=' and get the last occurrence for the actual token
          final tokenParts = token.split('token=');
          if (tokenParts.length >= 2) {
            // Get the last part after 'token='
            final lastTokenPart = tokenParts.last;
            // Find where the token ends (either at '&' or end of string)
            final ampersandIndex = lastTokenPart.indexOf('&');
            token = ampersandIndex != -1
                ? lastTokenPart.substring(0, ampersandIndex)
                : lastTokenPart;
          }
        }

        print(
            "Reset password deep link detected - Email: $email, Token: $token");
        print(
            "Redirecting to: ${AppPath.resetPassword}?email=${Uri.encodeComponent(email)}&token=${Uri.encodeComponent(token)}");
        return '${AppPath.resetPassword}?email=${Uri.encodeComponent(email)}&token=${Uri.encodeComponent(token)}';
      }

      return null; // No redirect needed
    },
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          /// Branch Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: <RouteBase>[
              GoRoute(
                path: AppPath.home,
                name: AppPathName.home,
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeScreen(),
              ),
            ],
          ),

          /// Branch Search
          StatefulShellBranch(
            navigatorKey: _shellNavigatorOrders,
            routes: <RouteBase>[
              GoRoute(
                path: AppPath.search,
                name: AppPathName.search,
                builder: (BuildContext context, GoRouterState state) {
                  // Support query params to focus or pre-fill the search field
                  return OrdersScreen();
                },
              ),
            ],
          ),

          /// Branch Account
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAccount,
            routes: <RouteBase>[
              GoRoute(
                path: AppPath.account,
                name: AppPathName.account,
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      /// Splash Screen
      GoRoute(
        path: AppPath.splash,
        name: AppPathName.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),

      /// User Type Selection Screen
      GoRoute(
        path: AppPath.userTypeSelection,
        name: AppPathName.userTypeSelection,
        builder: (BuildContext context, GoRouterState state) =>
            const UserTypeSelectionScreen(),
      ),

      /// Pharmacy Home Screen
      GoRoute(
        path: AppPath.pharmacyHome,
        name: AppPathName.pharmacyHome,
        builder: (BuildContext context, GoRouterState state) =>
            const PharmacyHomeScreen(),
      ),

      /// Onboarding Screen
      GoRoute(
        path: AppPath.onBoarding,
        name: AppPathName.onBoarding,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),

      /// Verify Email Screen
      GoRoute(
        path: AppPath.verifyEmail,
        name: AppPathName.verifyEmail,
        builder: (BuildContext context, GoRouterState state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return VerifyEmailScreen(email: email);
        },
      ),

      /// Reset Password Screen
      GoRoute(
        path: AppPath.resetPassword,
        name: AppPathName.resetPassword,
        builder: (BuildContext context, GoRouterState state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordPage(email: email, token: token);
        },
      ),

      /// Auth Gate (supports ?type=pharmacy or ?type=patient for login/register)
      GoRoute(
        path: AppPath.authGate,
        name: AppPathName.authGate,
        builder: (BuildContext context, GoRouterState state) {
          final userType = state.uri.queryParameters['type'] ?? 'patient';
          final isPharmacy = userType == 'pharmacy';
          return AuthGate(isPharmacy: isPharmacy);
        },
      ),
    ],
  );
}
