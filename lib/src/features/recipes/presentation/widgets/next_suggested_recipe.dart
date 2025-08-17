import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/recipe_recommendation_service.dart';
import '../../domain/recipe.dart';

/// Widget that displays the next suggested recipe based on recommendation algorithm
class NextSuggestedRecipe extends ConsumerWidget {
  const NextSuggestedRecipe({
    super.key,
    required this.currentRecipeId,
    this.onRecipeTap,
  });

  final String currentRecipeId;
  final ValueChanged<Recipe>? onRecipeTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Recipe?>(
      future: ref
          .read(recipeRecommendationServiceProvider.notifier)
          .getNextSuggestedRecipe(currentRecipeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context);
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        final suggestedRecipe = snapshot.data!;
        return _buildSuggestionCard(context, suggestedRecipe);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: ResponsiveUtils.iconSize20,
              ),
              SizedBox(width: ResponsiveUtils.spacing8),
              Text(
                'Next Suggested Recipe',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing16),
          Container(
            height: ResponsiveUtils.height120,
            decoration: BoxDecoration(
              color: AppColors.neutralLight,
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ResponsiveUtils.spacing24,
                    height: ResponsiveUtils.spacing24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing8),
                  Text(
                    'Finding your next recipe...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(BuildContext context, Recipe suggestedRecipe) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with suggestion icon and title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.spacing8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: AppColors.primary,
                  size: ResponsiveUtils.iconSize20,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Suggested Recipe',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'Based on your preferences',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.spacing16),

          // Recipe preview card
          InkWell(
            onTap: () => onRecipeTap?.call(suggestedRecipe),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
            child: Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing12),
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  // Recipe image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                    child: Image.network(
                      suggestedRecipe.imageUrl,
                      width: ResponsiveUtils.spacing80,
                      height: ResponsiveUtils.spacing80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: ResponsiveUtils.spacing80,
                          height: ResponsiveUtils.spacing80,
                          color: AppColors.neutralLight,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.textSecondary,
                            size: ResponsiveUtils.iconSize32,
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(width: ResponsiveUtils.spacing12),

                  // Recipe info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestedRecipe.getLocalizedName(languageCode),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: ResponsiveUtils.spacing4),

                        Text(
                          suggestedRecipe.getLocalizedDescription(languageCode),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: ResponsiveUtils.spacing8),

                        // Quick info row
                        Row(
                          children: [
                            _InfoChip(
                              icon: Icons.schedule,
                              label: '${suggestedRecipe.prepTimeMinutes + suggestedRecipe.cookTimeMinutes}m',
                            ),
                            SizedBox(width: ResponsiveUtils.spacing8),
                            _InfoChip(
                              icon: Icons.star,
                              label: suggestedRecipe.parentRating.toStringAsFixed(1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow indicator
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: ResponsiveUtils.iconSize16,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing12),

          // Action button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => onRecipeTap?.call(suggestedRecipe),
              icon: Icon(Icons.restaurant_menu),
              label: Text('Try This Recipe'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small info chip for displaying quick recipe information
class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing6,
        vertical: ResponsiveUtils.spacing2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.iconSize12,
            color: AppColors.primary,
          ),
          SizedBox(width: ResponsiveUtils.spacing2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}