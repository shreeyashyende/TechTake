import 'package:flutter/material.dart';

/// TechTake color palette following the design specification.
/// Uses dark mode with emerald accents and glassmorphism effects.
abstract class AppColors {
  // Background
  static const Color background = Color(0xFF000000);

  // Primary Accent - Emerald
  static const Color emeraldPrimary = Color(0xFF34D399);
  static const Color emeraldGlow = Color(0xFF10B981);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0x66FFFFFF); // 40% white

  // Card Surface Gradient
  static const Color cardGradientStart = Color(0xFF1A1A1A);
  static const Color cardGradientEnd = Color(0xFF0A0A0A);

  // Glass Layer
  static const Color glassLayer = Color(0xB3000000); // 70% black - rgba(0,0,0,0.7)

  // Borders
  static const Color border = Color(0x1AFFFFFF); // 10% white - rgba(255,255,255,0.1)

  // Utility colors
  static const Color error = Color(0xFFF87171); // red-400
  static const Color success = emeraldPrimary;

  // Opacity variants for emerald
  static Color emeraldWithOpacity(double opacity) =>
      emeraldPrimary.withOpacity(opacity);

  // Opacity variants for white
  static Color whiteWithOpacity(double opacity) =>
      textPrimary.withOpacity(opacity);

  // Card gradient
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [cardGradientStart, cardGradientEnd],
  );
}
