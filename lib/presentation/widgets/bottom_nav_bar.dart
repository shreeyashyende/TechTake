import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../providers/providers.dart';

/// Bottom navigation bar with 4 tabs: Home, Phases, Find, Saved.
class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final isSettingsOpen = ref.watch(isSettingsOpenProvider);

    // Helper to handle nav tap - closes settings and navigates
    void handleNavTap(int index) {
      // Always close settings first
      if (isSettingsOpen) {
        ref.read(isSettingsOpenProvider.notifier).state = false;
      }
      // Always set the index to trigger navigation
      ref.read(bottomNavIndexProvider.notifier).state = index;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        border: const Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: LucideIcons.home,
                label: 'HOME',
                isSelected: !isSettingsOpen && selectedIndex == 0,
                onTap: () => handleNavTap(0),
              ),
              _NavItem(
                icon: LucideIcons.layers,
                label: 'PHASES',
                isSelected: !isSettingsOpen && selectedIndex == 1,
                onTap: () => handleNavTap(1),
              ),
              _NavItem(
                icon: LucideIcons.search,
                label: 'FIND',
                isSelected: !isSettingsOpen && selectedIndex == 2,
                onTap: () => handleNavTap(2),
              ),
              _NavItem(
                icon: LucideIcons.bookmark,
                label: 'SAVED',
                isSelected: !isSettingsOpen && selectedIndex == 3,
                onTap: () => handleNavTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? AppColors.emeraldPrimary
        : AppColors.textPrimary.withOpacity(0.2);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.emeraldPrimary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.navLabel.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
