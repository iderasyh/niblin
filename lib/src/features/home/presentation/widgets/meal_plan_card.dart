import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/locale_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/image_cache_service.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../recipes/domain/recipe.dart';
import 'meal_action_buttons.dart';

class MealPlanCard extends ConsumerWidget {
  const MealPlanCard({
    required this.mealTitle,
    required this.recipe,
    super.key,
  });

  final String mealTitle;
  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final imageCacheService = ref.read(imageCacheServiceProvider.notifier);
    return Container(
      width: 0.65.sw,
      margin: EdgeInsets.only(right: ResponsiveUtils.spacing16),
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Meal title
          Text(
            mealTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: ResponsiveUtils.height8),

          // Recipe name
          Text(
            recipe.name[locale] ?? 'Recipe Name',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          SizedBox(height: ResponsiveUtils.height12),

          // Recipe image placeholder
          Container(
            height: ResponsiveUtils.height120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: imageCacheService.getCachedImage(
              imageUrl: recipe.imageUrl,
              width: double.infinity,
              height: ResponsiveUtils.height120,
            ),
          ),

          SizedBox(height: ResponsiveUtils.height12),

          // Quick info chips
          Wrap(
            spacing: ResponsiveUtils.spacing8,
            runSpacing: ResponsiveUtils.spacing4,
            children: [
              _InfoChip(
                icon: PhosphorIcons.clock(),
                text:
                    '${recipe.prepTimeMinutes + recipe.cookTimeMinutes} ${AppLocalizations.of(context)!.minTotal}',
                context: context,
              ),
              _InfoChip(
                icon: PhosphorIcons.forkKnife(),
                text:
                    recipe.nutritionalInfo.oneWordDescription[locale] ??
                    'Nutritious',
                context: context,
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.height16),

          // Action buttons
          MealActionButtons(
            onViewRecipe: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing ${recipe.name['en']} recipe')),
              );
            },
            onLogMeal: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged ${recipe.name['en']}')),
              );
            },
            onSwap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Swapping ${recipe.name['en']}')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.context,
  });

  final IconData icon;
  final String text;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing8,
        vertical: ResponsiveUtils.spacing4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.fontSize14,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: ResponsiveUtils.spacing4),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
