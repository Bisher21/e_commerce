import 'package:flutter/material.dart';

class AppColors {
  // Core brand
  static const Color primary = Colors.deepPurple;
  static const Color primaryLight = Color(0xFFEDE7F6);
  static const Color primaryDark = Color(0xFF4527A0);

  // Neutrals
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color black45 = Colors.black45;
  static const Color grey = Colors.grey;
  static Color grey1 = Colors.grey.shade100;
  static Color grey2 = Colors.grey.shade200;
  static Color grey3 = Colors.grey.shade300;

  // Semantic
  static const Color yellow = Color(0xFFFFC107);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);

  // Surfaces
  static const Color surface = Colors.white;
  static const Color scaffoldBg = Color(0xFFF8F7FC);

  // Shadows
  static Color shadowColor = Colors.black.withValues(alpha: 0.07);
  static Color shadowColorMedium = Colors.black.withValues(alpha: 0.12);
}
