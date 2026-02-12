import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Color.fromARGB(255, 53, 53, 53),
    tertiary: Color.fromARGB(255, 25, 25, 25),
    inversePrimary: Colors.grey.shade300,
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
  ),
);
