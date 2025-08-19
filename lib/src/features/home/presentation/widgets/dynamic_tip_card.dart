import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/common_widgets.dart/platform_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../tips/domain/tip_content.dart';
import '../../data/mock_data.dart';
import '../../../onboarding/domain/baby_profile.dart';
import '../../../../core/services/cache_service.dart';

class DynamicTipCard extends ConsumerWidget {
  const DynamicTipCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final cacheData = ref.watch(cacheServiceProvider);
    final babyProfile = cacheData[CacheKey.babyProfile.name] as BabyProfile?;

    final babyAge = babyProfile?.ageInMonths ?? 0;
    final tip = MockData.getTipForAge(babyAge);

    if (tip == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing20,
        vertical: ResponsiveUtils.height16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.only(bottom: ResponsiveUtils.height12),
            child: Row(
              children: [
                Text(
                  localization.forThisStage,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(width: ResponsiveUtils.spacing8),
                Icon(
                  PhosphorIcons.lightbulb(),
                  size: ResponsiveUtils.iconSize24,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          // Tip card
          _TipCard(tip: tip),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final TipContent tip;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Opening: ${tip.title}')));
        },
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        child: Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content type and category
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing8,
                      vertical: ResponsiveUtils.height4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(tip.category, context),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tip.typeIcon,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(width: ResponsiveUtils.spacing4),
                        Text(
                          tip.typeDisplayText,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    PlatformIcons.forward,
                    size: ResponsiveUtils.iconSize14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveUtils.height12),

              // Title
              Text(
                tip.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              SizedBox(height: ResponsiveUtils.height8),

              // Description
              Text(
                tip.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.4,
                ),
              ),

              SizedBox(height: ResponsiveUtils.height12),

              // Age range indicator
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing10,
                  vertical: ResponsiveUtils.height6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                ),
                child: Text(
                  '${localization.ages} ${tip.targetAgeMinMonths}-${tip.targetAgeMaxMonths} ${localization.months}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(TipCategory category, BuildContext context) {
    switch (category) {
      case TipCategory.feeding:
        return Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3);
      case TipCategory.safety:
        return Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.3);
      case TipCategory.development:
        return Theme.of(
          context,
        ).colorScheme.tertiaryContainer.withValues(alpha: 0.3);
      case TipCategory.sleep:
        return Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.3);
      case TipCategory.general:
      case TipCategory.other:
        return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
  }
}
