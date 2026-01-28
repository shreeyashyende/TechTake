import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Global app header with logo and settings gear.
class AppHeader extends ConsumerWidget {
  final VoidCallback? onSettingsTap;
  final bool isSettingsActive;

  const AppHeader({
    super.key,
    this.onSettingsTap,
    this.isSettingsActive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingScreen,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassLayer,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Logo and title
                _buildLogo(),
                const SizedBox(width: 12),
                const Text(
                  'TechTake',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                // Settings button
                _buildSettingsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSettingsButton() {
    final isActive = isSettingsActive;

    return GestureDetector(
      onTap: onSettingsTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.emeraldPrimary
              : AppColors.textPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.emeraldPrimary.withOpacity(0.2)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Icon(
          LucideIcons.settings,
          size: 18,
          color: isActive
              ? AppColors.background
              : AppColors.textPrimary.withOpacity(0.6),
        ),
      ),
    );
  }
}
