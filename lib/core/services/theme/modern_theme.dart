import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors_modern.dart';

class ModernTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: ModernAppColors.primaryDeep,
        primaryContainer: ModernAppColors.primaryLight,
        secondary: ModernAppColors.accent,
        secondaryContainer: ModernAppColors.accentLight,
        tertiary: ModernAppColors.sage,
        tertiaryContainer: ModernAppColors.mint,
        surface: ModernAppColors.backgroundPrimary,
        onPrimary: Colors.white,
        onSecondary: ModernAppColors.textPrimary,
        onSurface: ModernAppColors.textPrimary,
        onSurfaceVariant: ModernAppColors.textSecondary,
        outline: ModernAppColors.textTertiary,
        shadow: ModernAppColors.shadowMedium,
        error: ModernAppColors.error,
        onError: Colors.white,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: _headlineStyle.copyWith(
          color: ModernAppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: ModernAppColors.textPrimary,
          size: 24,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: ModernAppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: ModernAppColors.shadowMedium,
        surfaceTintColor: Colors.transparent,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ModernAppColors.primaryDeep,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ModernAppColors.primaryDeep,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: ModernAppColors.textPrimary,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ModernAppColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: ModernAppColors.primaryDeep,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: ModernAppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(
          color: ModernAppColors.textTertiary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: ModernAppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ModernAppColors.accent,
        linearTrackColor: ModernAppColors.backgroundTertiary,
        circularTrackColor: ModernAppColors.backgroundTertiary,
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: ModernAppColors.accent,
        inactiveTrackColor: ModernAppColors.backgroundTertiary,
        thumbColor: ModernAppColors.accent,
        overlayColor: ModernAppColors.accentWithOpacity20,
        valueIndicatorColor: ModernAppColors.primaryDeep,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ModernAppColors.primaryDeep,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        titleTextStyle: _bodyStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ModernAppColors.textPrimary,
        ),
        subtitleTextStyle: _bodyStyle.copyWith(
          fontSize: 14,
          color: ModernAppColors.textSecondary,
        ),
        iconColor: ModernAppColors.textSecondary,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarTheme(
        labelColor: ModernAppColors.primaryDeep,
        unselectedLabelColor: ModernAppColors.textTertiary,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ModernAppColors.accentWithOpacity20,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: _displayStyle.copyWith(fontSize: 57, fontWeight: FontWeight.w800),
        displayMedium: _displayStyle.copyWith(fontSize: 45, fontWeight: FontWeight.w700),
        displaySmall: _displayStyle.copyWith(fontSize: 36, fontWeight: FontWeight.w600),
        headlineLarge: _headlineStyle.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
        headlineMedium: _headlineStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
        headlineSmall: _headlineStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
        titleLarge: _titleStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: _titleStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        titleSmall: _titleStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        bodyLarge: _bodyStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: _bodyStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: _bodyStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: _labelStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        labelMedium: _labelStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        labelSmall: _labelStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: ModernAppColors.backgroundTertiary,
        thickness: 1,
        space: 24,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ModernAppColors.accent;
          }
          return ModernAppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ModernAppColors.accentWithOpacity30;
          }
          return ModernAppColors.backgroundTertiary;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ModernAppColors.accent;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(
          color: ModernAppColors.textTertiary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ModernAppColors.accent,
        foregroundColor: ModernAppColors.textPrimary,
        elevation: 8,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ModernAppColors.cardBackground,
        selectedItemColor: ModernAppColors.primaryDeep,
        unselectedItemColor: ModernAppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Navigation Rail Theme
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: ModernAppColors.cardBackground,
        selectedIconTheme: IconThemeData(
          color: ModernAppColors.primaryDeep,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: ModernAppColors.textTertiary,
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: ModernAppColors.primaryDeep,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: ModernAppColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Text Styles Base
  static const TextStyle _displayStyle = TextStyle(
    fontFamily: 'Inter',
    color: ModernAppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle _headlineStyle = TextStyle(
    fontFamily: 'Inter',
    color: ModernAppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle _titleStyle = TextStyle(
    fontFamily: 'Inter',
    color: ModernAppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.4,
  );

  static const TextStyle _bodyStyle = TextStyle(
    fontFamily: 'Inter',
    color: ModernAppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.5,
  );

  static const TextStyle _labelStyle = TextStyle(
    fontFamily: 'Inter',
    color: ModernAppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // Custom Text Styles
  static TextStyle get arabicTextStyle => const TextStyle(
    fontFamily: 'NotoSansArabic',
    color: ModernAppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.6,
  );

  static TextStyle get audioPlayerTitle => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static TextStyle get audioPlayerSubtitle => const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFFB3B3B3),
    letterSpacing: 0.1,
    height: 1.4,
  );
}