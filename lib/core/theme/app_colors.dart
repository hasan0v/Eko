import 'package:flutter/material.dart';

/// Application color constants
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2E7D32); // Green
  static const Color secondary = Color(0xFF66BB6A); // Light Green
  static const Color accent = Color(0xFFFFA726); // Orange

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);

  // Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Compost status colors
  static const Color activeStatus = Color(0xFF4CAF50);
  static const Color curingStatus = Color(0xFFFFC107);
  static const Color readyStatus = Color(0xFF2196F3);
  static const Color harvestedStatus = Color(0xFF9E9E9E);

  // Water quality colors
  static const Color excellentQuality = Color(0xFF4CAF50);
  static const Color goodQuality = Color(0xFF2196F3);
  static const Color fairQuality = Color(0xFFFFC107);
  static const Color poorQuality = Color(0xFFF44336);

  AppColors._(); // Private constructor to prevent instantiation
}
