import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TechTake typography styles following the design specification.
/// Uses Inter for general UI and JetBrains Mono for technical labels.
abstract class AppTypography {
  // Phase Label - 8px, weight 900, letter-spacing 0.2em
  static TextStyle get phaseLabel => GoogleFonts.inter(
        fontSize: 8,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.6, // 0.2em = 0.2 * 8
        color: AppColors.textMuted,
      );

  // Chapter Label - 11px, weight 800, emerald
  static TextStyle get chapterLabel => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.emeraldPrimary,
      );

  // Word Title - 24px, weight 900, white
  static TextStyle get wordTitle => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      );

  // Section Header - 9px, weight 700, emerald, letter-spacing 0.1em
  static TextStyle get sectionHeader => GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.9, // 0.1em = 0.1 * 9
        color: AppColors.emeraldPrimary,
      );

  // Definition - 20px, medium, leading-snug, white/90
  static TextStyle get definition => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.375, // leading-snug
        color: AppColors.textPrimary.withOpacity(0.9),
      );

  // Body Text - 16px, regular, leading-relaxed, white/70-80
  static TextStyle get bodyText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.625, // leading-relaxed
        color: AppColors.textPrimary.withOpacity(0.7),
      );

  // Body Text Light - 14px, white/80
  static TextStyle get bodyTextLight => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.625,
        color: AppColors.textPrimary.withOpacity(0.8),
      );

  // Story Text - 16px, serif italic, white/90
  static TextStyle get storyText => GoogleFonts.lora(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        height: 1.625, // leading-relaxed
        color: AppColors.textPrimary.withOpacity(0.9),
      );

  // Tab Label - 8px, extra-bold, uppercase, tracking-tighter
  static TextStyle get tabLabel => GoogleFonts.inter(
        fontSize: 8,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4, // tracking-tighter
        color: AppColors.textMuted,
      );

  // Phase Title - 21px, weight 900, white
  static TextStyle get phaseTitle => GoogleFonts.inter(
        fontSize: 21,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      );

  // Chapter Title - 18px, weight 900
  static TextStyle get chapterTitle => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      );

  // Progress Text - 10px, weight 900, uppercase, widest tracking
  static TextStyle get progressText => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.5, // widest tracking
        color: AppColors.textMuted,
      );

  // Word Pill - 13px, weight 900, uppercase, tracking-tighter
  static TextStyle get wordPill => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5, // tracking-tighter
      );

  // Loading Status - 10px, JetBrains Mono, white/40, uppercase
  static TextStyle get loadingStatus => GoogleFonts.jetBrainsMono(
        fontSize: 10,
        color: AppColors.textMuted,
      );

  // Nav Label - 9px, weight 900, uppercase
  static TextStyle get navLabel => GoogleFonts.inter(
        fontSize: 9,
        fontWeight: FontWeight.w900,
      );

  // Screen Title - 24px, weight 900, white
  static TextStyle get screenTitle => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      );

  // Subtitle - 10px, weight 900, white/40, uppercase, letter-spacing 0.2em
  static TextStyle get subtitle => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0, // 0.2em
        color: AppColors.textMuted,
      );

  // Description - 14px, weight 500, white/40
  static TextStyle get description => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.625,
        color: AppColors.textMuted,
      );

  // Group Header - 10px, weight 900, white/30, uppercase
  static TextStyle get groupHeader => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.0,
        color: AppColors.textPrimary.withOpacity(0.3),
      );
}
