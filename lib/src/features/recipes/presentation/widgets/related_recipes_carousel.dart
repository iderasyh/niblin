import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/recipe_recommendation_service.dart';
import '../../domain/recipe.dart';
import 'stage_badge.dart';

/// A horizontal carousel displaying related recipes with smooth scrolling
class RelatedRecipesCarousel extends ConsumerWidget {
  const RelatedRecipesCarousel({
    super.key,
    required this.currentRecipeId,
    this.onRecipeTap,
    this.title = 'Related Recipes',
  });

  final String currentRecipeId;
  final ValueChanged<Recipe>? onRecipeTap;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Recipe>>(
      future: ref
          .read(recipeRecommendationServiceProvider.notifier)
          .getRelatedRecipes(recipeId: currentRecipeId, limit: 10),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState(context);
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final relatedRecipes = snapshot.data!;
        return _buildCarousel(context, relatedRecipes);
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing16),
        SizedBox(
          height: ResponsiveUtils.height200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing16),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: ResponsiveUtils.spacing160,
                margin: EdgeInsets.only(right: ResponsiveUtils.spacing12),
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context, List<Recipe> relatedRecipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (relatedRecipes.length > 3)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full related recipes list
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveUtils.spacing16),

        // Horizontal scrolling carousel
        SizedBox(
          height: ResponsiveUtils.height220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing16),
            itemCount: relatedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = relatedRecipes[index];
              return _RelatedRecipeCard(
                recipe: recipe,
                onTap: () => onRecipeTap?.call(recipe),
                isLast: index == relatedRecipes.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual recipe card for the carousel
class _RelatedRecipeCard extends StatelessWidget {
  const _RelatedRecipeCard({
    required this.recipe,
    required this.onTap,
    required this.isLast,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      width: ResponsiveUtils.spacing160,
      margin: EdgeInsets.only(
        right: isLast ? 0 : ResponsiveUtils.spacing12,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image with stage badge overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ResponsiveUtils.radius12),
                    ),
                    child: Image.network(
                      recipe.imageUrl,
                      width: double.infinity,
                      height: ResponsiveUtils.height100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: ResponsiveUtils.height100,
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

                  // Stage badge
                  Positioned(
                    top: ResponsiveUtils.spacing8,
                    left: ResponsiveUtils.spacing8,
                    child: StageBadge(
                      stage: recipe.supportedStages.first,
                      size: StageBadgeSize.small,
                    ),
                  ),

                  // Rating badge
                  if (recipe.parentRating > 0)
                    Positioned(
                      top: ResponsiveUtils.spacing8,
                      right: ResponsiveUtils.spacing8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing6,
                          vertical: ResponsiveUtils.spacing2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.secondary,
                              size: ResponsiveUtils.iconSize12,
                            ),
                            SizedBox(width: ResponsiveUtils.spacing2),
                            Text(
                              recipe.parentRating.toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // Recipe info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(ResponsiveUtils.spacing12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe name
                      Text(
                        recipe.getLocalizedName(languageCode),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: ResponsiveUtils.spacing4),

                      // Recipe description
                      Expanded(
                        child: Text(
                          recipe.getLocalizedDescription(languageCode),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      SizedBox(height: ResponsiveUtils.spacing8),

                      // Quick info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _QuickInfo(
                            icon: Icons.schedule,
                            text: '${recipe.prepTimeMinutes + recipe.cookTimeMinutes}m',
                          ),
                          _QuickInfo(
                            icon: Icons.restaurant,
                            text: '${recipe.servings}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick info widget for displaying time and servings
class _QuickInfo extends StatelessWidget {
  const _QuickInfo({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.iconSize12,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: ResponsiveUtils.spacing2),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

/// Vertical version of related recipes for use in different layouts
class RelatedRecipesVertical extends ConsumerWidget {
  const RelatedRecipesVertical({
    super.key,
    required this.currentRecipeId,
    this.onRecipeTap,
    this.maxItems = 3,
  });

  final String currentRecipeId;
  final ValueChanged<Recipe>? onRecipeTap;
  final int maxItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Recipe>>(
      future: ref
          .read(recipeRecommendationServiceProvider.notifier)
          .getRelatedRecipes(recipeId: currentRecipeId, limit: maxItems),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildVerticalLoadingState(context);
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final relatedRecipes = snapshot.data!;
        return _buildVerticalList(context, relatedRecipes);
      },
    );
  }

  Widget _buildVerticalLoadingState(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Container(
          height: ResponsiveUtils.spacing80,
          margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing12),
          decoration: BoxDecoration(
            color: AppColors.neutralLight,
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalList(BuildContext context, List<Recipe> relatedRecipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You Might Also Like',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing12),
        ...relatedRecipes.map((recipe) {
          return _VerticalRecipeItem(
            recipe: recipe,
            onTap: () => onRecipeTap?.call(recipe),
          );
        }),
      ],
    );
  }
}

/// Vertical recipe item for compact display
class _VerticalRecipeItem extends StatelessWidget {
  const _VerticalRecipeItem({
    required this.recipe,
    required this.onTap,
  });

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing12),
        margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            // Recipe image
            ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius6),
              child: Image.network(
                recipe.imageUrl,
                width: ResponsiveUtils.spacing60,
                height: ResponsiveUtils.spacing60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: ResponsiveUtils.spacing60,
                    height: ResponsiveUtils.spacing60,
                    color: AppColors.neutralLight,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textSecondary,
                      size: ResponsiveUtils.iconSize20,
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
                    recipe.getLocalizedName(languageCode),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveUtils.spacing2),
                  Text(
                    '${recipe.prepTimeMinutes + recipe.cookTimeMinutes}m • ${recipe.servings} servings',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveUtils.iconSize16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}