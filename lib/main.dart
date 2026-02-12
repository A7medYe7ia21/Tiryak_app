import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_strings.dart';
import 'core/di/dependency_injection.dart';
import 'core/helpers/shared_pref_helper.dart';
import 'core/notifications/notification_cubit.dart';
import 'core/services/notifications_service.dart';

import 'core/theme/theme_provider.dart';
import 'features/auth/logic/auth_cubit.dart';

import 'app.dart';
import 'features/pharmacy/logic/pharmacy_cubit.dart';

bool isOnboardingComplete = false;

Future<void> checkOnboardingComplete() async {
  isOnboardingComplete = await SharedPrefHelper.getBool(AppStrings.onboardingComplete);
}

Future<void> checkCurrentThemeMode() async {
  final brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  final isDarkMode = brightness == Brightness.dark;
  await SharedPrefHelper.setData("isDarkMode", isDarkMode);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.initNotifications();
  await checkOnboardingComplete();
  await checkCurrentThemeMode();
  await setupDependencyInjection();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(AppLocale.english),
        Locale(AppLocale.arabic),
      ],
      path: 'assets/l10n',
      saveLocale: true,
      fallbackLocale: const Locale(AppLocale.english),
      startLocale: const Locale(AppLocale.english),
      child: ChangeNotifierProvider.value(
        value: di<ThemeProvider>(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: di<AuthCubit>()..checkAuth(),
            ),
            BlocProvider.value(
              value: di<NotificationCubit>(),
            ),
            BlocProvider.value(
              value: di<PharmacyCubit>(),
            ),
          ],
          child: Tryiak(),
        ),
      ),
    ),
  );
}
