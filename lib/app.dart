import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/di/dependency_injection.dart';
import 'core/router/go_router.dart';
import 'core/theme/theme_provider.dart';
import 'features/location/logic/location_cubit.dart';

class Tryiak extends StatelessWidget {
  const Tryiak({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: di<LocationCubit>()..requestLocationPermission(),
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'Tryiak',
              debugShowCheckedModeBanner: false,
              theme: Provider.of<ThemeProvider>(context).themeData,
              themeAnimationCurve: Curves.fastOutSlowIn,
              themeAnimationDuration: Duration(milliseconds: 1500),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              routerConfig: AppNavigation.router,
            );
          },
        ));
  }
}
