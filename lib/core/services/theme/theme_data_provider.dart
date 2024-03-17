import 'package:flutter/material.dart';

class ThemeDataProvider {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFedc0a0)),
    // primaryColor: const Color(0xFFfde8d3),
    // Customize other theme properties like textTheme, buttonTheme, etc.
  );
}
