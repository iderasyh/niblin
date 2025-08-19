import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class MealActionButtons extends StatelessWidget {
  const MealActionButtons({
    required this.onViewRecipe,
    required this.onLogMeal,
    required this.onSwap,
    super.key,
  });

  final VoidCallback onViewRecipe;
  final VoidCallback onLogMeal;
  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Primary action - View Recipe
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onViewRecipe,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.spacing12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
              ),
            ),
            child: Text(
              localization.viewRecipe,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
            ),
          ),
        ),

        SizedBox(height: ResponsiveUtils.spacing8),

        // Secondary actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onLogMeal,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.height8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius6,
                    ),
                  ),
                ),
                child: Text(
                  localization.logMeal,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
                ),
              ),
            ),

            SizedBox(width: ResponsiveUtils.spacing8),

            Expanded(
              child: TextButton(
                onPressed: onSwap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.height8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius6,
                    ),
                  ),
                ),
                child: Text(
                  localization.swap,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
