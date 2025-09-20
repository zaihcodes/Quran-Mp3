import 'package:flutter/material.dart';

/// Modern, relaxing color palette inspired by spiritual tranquility and premium audio experiences
class ModernAppColors {
  // Primary Colors - Deep Ocean & Sage Green for tranquility
  static const Color primaryDeep = Color(0xFF1A365D); // Deep ocean blue
  static const Color primaryMedium = Color(0xFF2D5F7F); // Medium ocean blue
  static const Color primaryLight = Color(0xFF4A7FA1); // Light ocean blue
  static const Color primarySoft = Color(0xFF6B9FC3); // Soft ocean blue

  // Accent Colors - Warm Gold & Sunset for spiritual warmth
  static const Color accent = Color(0xFFD4AF37); // Warm gold
  static const Color accentLight = Color(0xFFE8C547); // Light gold
  static const Color accentSoft = Color(0xFFF2E5AA); // Soft gold

  // Sage & Mint for natural calmness
  static const Color sage = Color(0xFF87A96B); // Sage green
  static const Color mint = Color(0xFFA8D8A8); // Mint green
  static const Color mintSoft = Color(0xFFE8F5E8); // Soft mint

  // Background Colors - Layered depth
  static const Color backgroundPrimary = Color(0xFFF8FAFE); // Pure white with blue tint
  static const Color backgroundSecondary = Color(0xFFF1F6FB); // Light blue-gray
  static const Color backgroundTertiary = Color(0xFFEBF2F8); // Deeper blue-gray
  static const Color backgroundDark = Color(0xFF0F1419); // Dark mode primary

  // Card & Surface Colors with glassmorphism
  static const Color cardBackground = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackgroundSoft = Color(0xFFFDFDFE); // Soft white
  static const Color glassBackground = Color(0x1AFFFFFF); // Glass effect
  static const Color glassBorder = Color(0x33FFFFFF); // Glass border

  // Text Colors with proper contrast
  static const Color textPrimary = Color(0xFF1A202C); // Dark gray-blue
  static const Color textSecondary = Color(0xFF4A5568); // Medium gray
  static const Color textTertiary = Color(0xFF718096); // Light gray
  static const Color textOnDark = Color(0xFFF7FAFC); // Light text for dark backgrounds

  // Interactive Colors
  static const Color success = Color(0xFF48BB78); // Success green
  static const Color warning = Color(0xFFED8936); // Warning orange
  static const Color error = Color(0xFFE53E3E); // Error red
  static const Color info = Color(0xFF3182CE); // Info blue

  // Shadow & Overlay Colors
  static const Color shadowLight = Color(0x0A000000); // Light shadow
  static const Color shadowMedium = Color(0x15000000); // Medium shadow
  static const Color shadowDark = Color(0x25000000); // Dark shadow
  static const Color overlay = Color(0x40000000); // Modal overlay

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeep, primaryMedium, primaryLight],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
    stops: [0.0, 1.0],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundPrimary, backgroundSecondary],
    stops: [0.0, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, cardBackgroundSoft],
    stops: [0.0, 1.0],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x20FFFFFF),
      Color(0x10FFFFFF),
    ],
    stops: [0.0, 1.0],
  );

  // Audio Player Specific Colors
  static const Color playerBackground = Color(0xFF0D1117); // Dark player background
  static const Color playerCard = Color(0xFF161B22); // Player card background
  static const Color progressBar = accent; // Progress bar color
  static const Color progressBackground = Color(0xFF21262D); // Progress background
  static const Color volumeSlider = primaryMedium; // Volume slider

  // Islamic/Spiritual Theme Colors
  static const Color spiritualGold = Color(0xFFFFD700); // Islamic gold
  static const Color spiritualGreen = Color(0xFF008751); // Islamic green
  static const Color spiritualBlue = Color(0xFF003F7F); // Prayer time blue
  static const Color spiritualCream = Color(0xFFFFFDD0); // Cream for text backgrounds

  // Helper methods for creating colors with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Pre-defined opacity variants for common use cases
  static Color get primaryWithOpacity10 => withOpacity(primaryDeep, 0.1);
  static Color get primaryWithOpacity20 => withOpacity(primaryDeep, 0.2);
  static Color get primaryWithOpacity30 => withOpacity(primaryDeep, 0.3);
  static Color get accentWithOpacity10 => withOpacity(accent, 0.1);
  static Color get accentWithOpacity20 => withOpacity(accent, 0.2);
  static Color get accentWithOpacity30 => withOpacity(accent, 0.3);
  static Color get textWithOpacity60 => withOpacity(textPrimary, 0.6);
  static Color get textWithOpacity40 => withOpacity(textPrimary, 0.4);
}