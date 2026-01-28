import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// TechTake app theme configuration.
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.emeraldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.emeraldPrimary,
        secondary: AppColors.emeraldGlow,
        surface: AppColors.cardGradientStart,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      splashColor: AppColors.emeraldPrimary.withOpacity(0.1),
      highlightColor: AppColors.emeraldPrimary.withOpacity(0.05),
    );
  }
}
