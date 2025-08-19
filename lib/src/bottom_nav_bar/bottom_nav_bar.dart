import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../l10n/app_localizations.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive_utils.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Method to handle navigation when a bottom nav item is tapped
  void _onTap(BuildContext context, int index) {
    HapticFeedback.mediumImpact();
    navigationShell.goBranch(
      index,
      // Reset the navigation stack when switching branches
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: BottomAppBar(
          elevation: 0,
          color: AppColors.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                0,
                PhosphorIconsRegular.house,
                PhosphorIconsFill.house,
                localization.home,
              ),
              _buildNavItem(
                context,
                1,
                PhosphorIconsRegular.binoculars,
                PhosphorIconsFill.binoculars,
                localization.explore,
              ),
              _buildNavItem(
                context,
                2,
                PhosphorIconsRegular.calendarHeart,
                PhosphorIconsFill.calendarHeart,
                localization.plan,
              ),
              _buildNavItem(
                context,
                3,
                PhosphorIconsRegular.baby,
                PhosphorIconsFill.baby,
                localization.tracker,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual navigation items with labels
  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final theme = Theme.of(context);
    final bool isActive = navigationShell.currentIndex == index;
    final Color color = isActive ? AppColors.primary : AppColors.textSecondary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing8),
      child: InkWell(
        onTap: () => _onTap(context, index),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        // Wrap the content in AnimatedOpacity and AnimatedScale for animation
        child: AnimatedOpacity(
          opacity: isActive ? 1.0 : 0.7, // Fade slightly when inactive
          duration: const Duration(milliseconds: 200), // Match scale duration
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: isActive ? 1.1 : 1.0, // Scale up slightly when active
            duration: const Duration(milliseconds: 200), // Animation duration
            curve: Curves.easeInOut, // Animation curve
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? activeIcon : icon,
                  color: color,
                  size: ResponsiveUtils.iconSize20,
                ),
                SizedBox(height: ResponsiveUtils.height4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: ResponsiveUtils.fontSize12,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
