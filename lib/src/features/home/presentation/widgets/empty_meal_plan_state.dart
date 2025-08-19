import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/responsive_utils.dart';

class EmptyMealPlanState extends StatelessWidget {
  const EmptyMealPlanState({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing20),
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.all(ResponsiveUtils.spacing24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.forkKnife(),
              size: ResponsiveUtils.iconSize48,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.6),
            ),

            SizedBox(height: ResponsiveUtils.height16),

            Text(
              localization.noMealsScheduledForToday,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: ResponsiveUtils.height8),

            Text(
              localization.tapHereToExploreRecipes,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: ResponsiveUtils.height20),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exploring recipes...')),
                );
              },
              icon: Icon(
                PhosphorIcons.magnifyingGlass(),
                size: ResponsiveUtils.iconSize18,
              ),
              label: Text(localization.exploreRecipes),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing20,
                  vertical: ResponsiveUtils.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
