import 'package:flutter/material.dart';

/// App Color Scheme
class AppColors {
  // Primary colors (matching existing blue gradient)
  static const Color primary = Color(0xFF0077b6);
  static const Color secondary = Color(0xFF0096c7);
  static const Color primaryDark = Color(0xFF005f8a);
  
  // Status colors
  static const Color success = Color(0xFF28a745);
  static const Color successDark = Color(0xFF218838);
  static const Color error = Color(0xFFff5252);
  static const Color errorDark = Color(0xFFd32f2f);
  static const Color warning = Color(0xFFffc107);
  static const Color info = Color(0xFF17a2b8);
  
  // Background
  static const Color background = Color(0xFFf5f5f5);
  static const Color surface = Colors.white;
  
  // Text colors
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  
  // Other
  static const Color divider = Color(0xFFcccccc);
  static const Color shadow = Color(0x1A000000);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
