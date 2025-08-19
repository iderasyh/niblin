import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/responsive_utils.dart';

class PremiumUpgradeBanner extends StatelessWidget {
  const PremiumUpgradeBanner({
    this.isUserFree =
        true, // Mock - in real app this would come from user state
    super.key,
  });

  final bool isUserFree;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    // Only show for free users
    if (!isUserFree) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.fromLTRB(
        ResponsiveUtils.spacing20,
        ResponsiveUtils.height16,
        ResponsiveUtils.spacing20,
        ResponsiveUtils.height24,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigating to premium upgrade...')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Sparkle icon
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: ResponsiveUtils.iconSize20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            SizedBox(width: ResponsiveUtils.spacing12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.tiredOfDailyPlanning,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    localization.unlockYourFullWeeklyMealPlan,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: ResponsiveUtils.spacing8),

            // CTA button
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing16,
                vertical: ResponsiveUtils.spacing8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
              ),
              child: Text(
                localization.goPremium,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
