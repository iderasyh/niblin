import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/services/image_cache_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/recipe.dart';
import 'stage_badge.dart';
import 'favorite_button.dart';

/// A card widget that displays recipe information including image, title, and quick info
/// Features stage badges, favorite button with animation, and responsive design
class RecipeCard extends ConsumerWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.showFavoriteButton = true,
  });

  final Recipe recipe;
  final VoidCallback? onTap;
  final bool showFavoriteButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context, ref, currentLocale),
            _buildContentSection(context, l10n, currentLocale),
            _buildQuickInfoSection(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, WidgetRef ref, String currentLocale) {
    final imageCacheService = ref.read(imageCacheServiceProvider.notifier);
    
    return Stack(
      children: [
        // Recipe Image with optimized caching
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.radius16),
            topRight: Radius.circular(ResponsiveUtils.radius16),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: imageCacheService.getCachedImage(
              imageUrl: recipe.imageUrl,
              width: double.infinity,
              height: 200, // Approximate height for 16:9 aspect ratio
              fit: BoxFit.cover,
              placeholder: Container(
                color: AppColors.neutralLight,
                child: const Center(
                  child: LoadingIndicator(),
                ),
              ),
              errorWidget: Container(
                color: AppColors.neutralLight,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: ResponsiveUtils.iconSize48,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        
        // Stage Badges
        Positioned(
          top: ResponsiveUtils.spacing8,
          left: ResponsiveUtils.spacing8,
          child: Wrap(
            spacing: ResponsiveUtils.spacing4,
            children: recipe.supportedStages.map((stage) => 
              StageBadge(stage: stage)
            ).toList(),
          ),
        ),
        
        // Favorite Button
        if (showFavoriteButton)
          Positioned(
            top: ResponsiveUtils.spacing8,
            right: ResponsiveUtils.spacing8,
            child: FavoriteButton(
              recipeId: recipe.id,
              size: ResponsiveUtils.iconSize24,
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context, AppLocalizations l10n, String currentLocale) {
    return Padding(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Title
          Text(
            recipe.getLocalizedName(currentLocale),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: ResponsiveUtils.spacing4),
          
          // Recipe Description
          Text(
            recipe.getLocalizedDescription(currentLocale),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.spacing12,
        0,
        ResponsiveUtils.spacing12,
        ResponsiveUtils.spacing12,
      ),
      child: Row(
        children: [
          // Prep Time
          _buildInfoChip(
            context,
            Icons.schedule_outlined,
            '${recipe.totalTimeMinutes}m',
          ),
          
          SizedBox(width: ResponsiveUtils.spacing8),
          
          // Servings
          _buildInfoChip(
            context,
            Icons.restaurant_outlined,
            '${recipe.servings}',
          ),
          
          SizedBox(width: ResponsiveUtils.spacing8),
          
          // Rating
          if (recipe.parentRating > 0)
            _buildInfoChip(
              context,
              Icons.star_outline,
              recipe.parentRating.toStringAsFixed(1),
            ),
          
          const Spacer(),
          
          // Calories
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing8,
              vertical: ResponsiveUtils.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
            ),
            child: Text(
              '${recipe.nutritionalInfo.caloriesPerServing} cal',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.tertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.iconSize14,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: ResponsiveUtils.spacing2),
        Text(
          text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}