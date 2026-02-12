import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/auth.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/location/logic/location_cubit.dart';
import '../../features/pharmacy/logic/pharmacy_cubit.dart';
import '../networking/api_constants.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../notifications/notification_cubit.dart';
import '../theme/theme_provider.dart';

final di = GetIt.instance;

Future<void> setupDependencyInjection() async {
  Dio dio = DioFactory.getDio();
  di.registerLazySingleton<ApiService>(
      () => ApiService(dio, baseUrl: ApiConstants.apiBaseUrl));

  // Cubits and Providers
  di.registerLazySingleton<AuthCubit>(
      () => AuthCubit(auth: Authentication(di<ApiService>())));
  di.registerLazySingleton<NotificationCubit>(() => NotificationCubit());
  di.registerLazySingleton<LocationCubit>(() => LocationCubit());

  di.registerLazySingleton<PharmacyCubit>(() => PharmacyCubit());

  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  di.registerLazySingleton<ThemeProvider>(() => ThemeProvider(brightness));
}
