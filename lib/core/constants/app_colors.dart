import 'package:flutter/material.dart';

/// App color constants for EcoBin
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF19E624);
  static const Color primaryDark = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);

  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF112112);
  static const Color surfaceDark = Color(0xFF1A2F1A);
  static const Color cardDark = Color(0xFF1E3A1E);

  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textTertiaryLight = Color(0xFF999999);

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFE8E8E8);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // Status Colors
  static const Color active = Color(0xFF4CAF50);
  static const Color inactive = Color(0xFF9E9E9E);
  static const Color pending = Color(0xFFFFA726);

  // Chart Colors
  static const Color chartBlue = Color(0xFF42A5F5);
  static const Color chartGreen = Color(0xFF66BB6A);
  static const Color chartOrange = Color(0xFFFFA726);
  static const Color chartRed = Color(0xFFEF5350);
  static const Color chartPurple = Color(0xFFAB47BC);
  static const Color chartYellow = Color(0xFFFFEE58);

  // Sensor Status Colors
  static const Color tempNormal = Color(0xFF4CAF50);
  static const Color tempHigh = Color(0xFFFFA726);
  static const Color tempCritical = Color(0xFFEF5350);

  // Water Quality Colors
  static const Color waterExcellent = Color(0xFF4CAF50);
  static const Color waterGood = Color(0xFF66BB6A);
  static const Color waterFair = Color(0xFFFFA726);
  static const Color waterPoor = Color(0xFFEF5350);

  // Soil Health Colors
  static const Color soilHealthy = Color(0xFF4CAF50);
  static const Color soilModerate = Color(0xFFFFA726);
  static const Color soilUnhealthy = Color(0xFFEF5350);

  // UI Elements
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2E4A2E);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);

  // Gradient Colors
  static final LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFFFA726)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
