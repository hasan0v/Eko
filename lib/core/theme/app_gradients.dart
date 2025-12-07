import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Modern gradient definitions for the app
class AppGradients {
  AppGradients._();

  // Primary Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF19E624), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [Color(0xFF19E624), Color(0xFF4CAF50)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    colors: [Color(0xFF19E624), Color(0xFF4CAF50)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Vibrant Accent Gradients
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFFFA726), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF5350), Color(0xFFE57373), Color(0xFFEF9A9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient infoGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF64B5F6), Color(0xFF90CAF9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF8FAFB), Color(0xFFFFFFFF), Color(0xFFF0F4F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF111315), Color(0xFF1A1D1F), Color(0xFF0D0F10)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card Gradients
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x40FFFFFF),
      Color(0x20FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [
      Color(0x20FFFFFF),
      Color(0x10FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer/Loading Gradients
  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFE8ECF0),
      Color(0xFFF8FAFB),
      Color(0xFFE8ECF0),
    ],
    begin: Alignment(-1.0, 0.0),
    end: Alignment(1.0, 0.0),
  );

  // Special Effect Gradients
  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x4019E624),
      Color(0x2019E624),
      Color(0x0019E624),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const SweepGradient rainbowGradient = SweepGradient(
    colors: [
      Color(0xFF19E624),
      Color(0xFF42A5F5),
      Color(0xFFAB47BC),
      Color(0xFFEF5350),
      Color(0xFFFFA726),
      Color(0xFF19E624),
    ],
  );

  // Overlay Gradients
  static const LinearGradient overlayGradient = LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x80000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient topOverlayGradient = LinearGradient(
    colors: [
      Color(0x80000000),
      Color(0x00000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Status Gradients
  static const LinearGradient activeGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient inactiveGradient = LinearGradient(
    colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pendingGradient = LinearGradient(
    colors: [Color(0xFFFFA726), Color(0xFFFFB74D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sensor/Chart Gradients
  static const LinearGradient temperatureGradient = LinearGradient(
    colors: [Color(0xFFEF5350), Color(0xFFFFA726), Color(0xFF42A5F5)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient humidityGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF64B5F6), Color(0xFF90CAF9)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient phGradient = LinearGradient(
    colors: [
      Color(0xFFEF5350), // Acidic (red)
      Color(0xFFFFA726), // Neutral (orange)
      Color(0xFF66BB6A), // Alkaline (green)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Water Quality Gradients
  static const LinearGradient waterQualityGradient = LinearGradient(
    colors: [
      Color(0xFF42A5F5),
      Color(0xFF4CAF50),
      Color(0xFF66BB6A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soil Health Gradients
  static const LinearGradient soilHealthGradient = LinearGradient(
    colors: [
      Color(0xFF8D6E63),
      Color(0xFFA1887F),
      Color(0xFF4CAF50),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
