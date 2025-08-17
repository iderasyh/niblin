import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/recipe.dart';

/// Widget that displays emotional triggers explaining why kids love a particular recipe
class WhyKidsLoveThisSection extends StatelessWidget {
  const WhyKidsLoveThisSection({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final whyKidsLoveThis = recipe.getLocalizedWhyKidsLoveThis(languageCode);

    if (whyKidsLoveThis.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary.withValues(alpha: 0.1),
            AppColors.tertiary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with heart icon and title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.spacing8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                ),
                child: Icon(
                  Icons.favorite,
                  color: AppColors.secondary,
                  size: ResponsiveUtils.iconSize20,
                ),
              ),
              SizedBox(width: ResponsiveUtils.spacing12),
              Expanded(
                child: Text(
                  'Why Kids Love This',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Cute emoji decoration
              Text(
                '😋',
                style: TextStyle(fontSize: ResponsiveUtils.iconSize24),
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.spacing12),

          // Main content with emotional appeal
          Container(
            padding: EdgeInsets.all(ResponsiveUtils.spacing16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  whyKidsLoveThis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),

                SizedBox(height: ResponsiveUtils.spacing12),

                // Emotional appeal points
                ..._buildEmotionalPoints(context, recipe),
              ],
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing12),

          // Encouraging call-to-action
          _buildEncouragingMessage(context),
        ],
      ),
    );
  }

  List<Widget> _buildEmotionalPoints(BuildContext context, Recipe recipe) {
    final points = <Widget>[];

    // Add points based on recipe characteristics
    if (recipe.nutritionalInfo.developmentBenefits.isNotEmpty) {
      points.add(_buildEmotionalPoint(
        context,
        icon: Icons.psychology,
        text: 'Supports healthy brain development',
        emoji: '🧠',
      ));
    }

    if (recipe.parentRating >= 4.0) {
      points.add(_buildEmotionalPoint(
        context,
        icon: Icons.thumb_up,
        text: 'Loved by other parents and babies',
        emoji: '👍',
      ));
    }

    if (recipe.prepTimeMinutes <= 10) {
      points.add(_buildEmotionalPoint(
        context,
        icon: Icons.flash_on,
        text: 'Quick and easy for busy parents',
        emoji: '⚡',
      ));
    }

    // Add category-specific emotional points
    switch (recipe.category.name) {
      case 'breakfast':
        points.add(_buildEmotionalPoint(
          context,
          icon: Icons.wb_sunny,
          text: 'Perfect way to start the day with energy',
          emoji: '🌅',
        ));
        break;
      case 'snacks':
        points.add(_buildEmotionalPoint(
          context,
          icon: Icons.celebration,
          text: 'Makes snack time fun and exciting',
          emoji: '🎉',
        ));
        break;
      case 'desserts':
        points.add(_buildEmotionalPoint(
          context,
          icon: Icons.cake,
          text: 'A sweet treat that brings joy',
          emoji: '🍰',
        ));
        break;
    }

    return points;
  }

  Widget _buildEmotionalPoint(
    BuildContext context, {
    required IconData icon,
    required String text,
    required String emoji,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: ResponsiveUtils.iconSize16),
          ),
          SizedBox(width: ResponsiveUtils.spacing8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragingMessage(BuildContext context) {
    final encouragingMessages = [
      "Your little one is going to love this! 💕",
      "Get ready for some happy baby faces! 😊",
      "This recipe creates beautiful feeding moments! ✨",
      "Perfect for making mealtime magical! 🌟",
      "Watch your baby discover new flavors! 👶",
    ];

    // Use recipe ID to consistently pick the same message
    final messageIndex = recipe.id.hashCode % encouragingMessages.length;
    final message = encouragingMessages[messageIndex.abs()];

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: AppColors.tertiary,
            size: ResponsiveUtils.iconSize20,
          ),
          SizedBox(width: ResponsiveUtils.spacing8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.tertiary,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact version of the "Why Kids Love This" section for use in cards
class WhyKidsLoveThisCompact extends StatelessWidget {
  const WhyKidsLoveThisCompact({
    super.key,
    required this.recipe,
    this.maxLines = 2,
  });

  final Recipe recipe;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final whyKidsLoveThis = recipe.getLocalizedWhyKidsLoveThis(languageCode);

    if (whyKidsLoveThis.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.favorite,
            color: AppColors.secondary,
            size: ResponsiveUtils.iconSize16,
          ),
          SizedBox(width: ResponsiveUtils.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Kids Love This',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing2),
                Text(
                  whyKidsLoveThis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '😋',
            style: TextStyle(fontSize: ResponsiveUtils.iconSize16),
          ),
        ],
      ),
    );
  }
}