import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/router/go_router.dart';
import 'core/widgets/loading_indicator.dart';
import 'features/auth/logic/auth_cubit.dart';
import 'features/auth/logic/auth_state.dart';
import 'features/location/logic/location_cubit.dart';
import 'features/auth/ui/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, this.isPharmacy = false});
  final bool isPharmacy;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle navigation based on authentication state
        if (state is EmailVerificationPending) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(
                '${AppPath.verifyEmail}?email=${Uri.encodeComponent(state.email)}');
          });
        } else if (state is Authenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Request location permission when user is authenticated
            context.read<LocationCubit>().requestLocationPermission();

            // Navigate based on user role
            final String route = state.user.role == 'pharmacy'
                ? AppPath.pharmacyHome
                : AppPath.home;
            context.go(route);
          });
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(body: LoadingIndicator());
        } else if (state is AuthError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().checkAuth(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is EmailVerificationPending) {
          // Show loading while navigating to verify email
          return const Scaffold(body: LoadingIndicator());
        } else if (state is Authenticated) {
          // Show loading while navigating to home
          return const Scaffold(body: LoadingIndicator());
        } else {
          // Unauthenticated - show login/register (unified for pharmacy & patient)
          return Scaffold(body: LoginOrRegister(isPharmacy: isPharmacy));
        }
      },
    );
  }
}
