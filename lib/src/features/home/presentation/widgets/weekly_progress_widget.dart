import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../data/mock_data.dart';

class WeeklyProgressWidget extends StatelessWidget {
  const WeeklyProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final progressTracker = MockData.mockProgressTracker;
    final foodEmojis = progressTracker.foodEmojis;
    final encouragingMessage = progressTracker.encouragingMessage;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing20,
        vertical: ResponsiveUtils.height16,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.spacing20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Text(
                localization.thisWeeksJourney,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(width: ResponsiveUtils.spacing8),
              Icon(
                PhosphorIcons.presentationChart(),
                size: ResponsiveUtils.iconSize24,
                color: AppColors.primary,
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.height16),

          // Visual progress with food emojis
          if (foodEmojis.isNotEmpty) ...[
            Row(
              children: [
                // Food emojis
                ...foodEmojis.map(
                  (emoji) => Container(
                    margin: EdgeInsets.only(right: ResponsiveUtils.spacing8),
                    padding: EdgeInsets.all(ResponsiveUtils.spacing8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      emoji,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),

                // Plus icon if there are more foods
                if (progressTracker.newFoodsIntroduced.length > 5)
                  Container(
                    margin: EdgeInsets.only(left: ResponsiveUtils.spacing4),
                    padding: EdgeInsets.all(ResponsiveUtils.spacing8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius8,
                      ),
                    ),
                    child: Icon(
                      PhosphorIcons.plus(),
                      size: ResponsiveUtils.iconSize16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),

            SizedBox(height: ResponsiveUtils.height12),
          ],

          // Encouraging message
          Text(
            encouragingMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.3,
            ),
          ),

          SizedBox(height: ResponsiveUtils.height12),

          // Additional stats
          Row(
            children: [
              _StatChip(
                icon: PhosphorIcons.forkKnife(),
                label: localization.mealsLogged,
                value: '${progressTracker.totalMealsLogged}',
                context: context,
              ),

              SizedBox(width: ResponsiveUtils.spacing12),

              _StatChip(
                icon: PhosphorIcons.bowlFood(),
                label: localization.newFoods,
                value: '${progressTracker.newFoodsIntroduced.length}',
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.context,
  });

  final IconData icon;
  final String label;
  final String value;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing12,
        vertical: ResponsiveUtils.height8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.iconSize16,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: ResponsiveUtils.spacing6),
          Text(
            '$value $label',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
