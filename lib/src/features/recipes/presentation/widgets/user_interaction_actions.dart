import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import 'favorite_button.dart';
import 'meal_plan_button.dart';
import 'tried_button.dart';
import 'share_button.dart';

/// A row of user interaction buttons for recipes (favorite, meal plan, tried, share)
class UserInteractionActions extends ConsumerWidget {
  const UserInteractionActions({
    super.key,
    required this.recipeId,
    this.buttonSize,
    this.backgroundColor,
    this.spacing,
    this.showLabels = false,
  });

  final String recipeId;
  final double? buttonSize;
  final Color? backgroundColor;
  final double? spacing;
  final bool showLabels;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonSpacing = spacing ?? ResponsiveUtils.spacing12;
    final size = buttonSize ?? ResponsiveUtils.iconSize40;

    if (showLabels) {
      return _buildWithLabels(context, size, buttonSpacing);
    } else {
      return _buildCompact(context, size, buttonSpacing);
    }
  }

  Widget _buildCompact(BuildContext context, double size, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FavoriteButton(
          recipeId: recipeId,
          size: size,
          backgroundColor: backgroundColor,
        ),
        SizedBox(width: spacing),
        MealPlanButton(
          recipeId: recipeId,
          size: size,
          backgroundColor: backgroundColor,
        ),
        SizedBox(width: spacing),
        TriedButton(
          recipeId: recipeId,
          size: size,
          backgroundColor: backgroundColor,
        ),
        SizedBox(width: spacing),
        ShareButton(
          recipeId: recipeId,
          size: size,
          backgroundColor: backgroundColor,
        ),
      ],
    );
  }

  Widget _buildWithLabels(BuildContext context, double size, double spacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionWithLabel(
          label: 'Favorite',
          child: FavoriteButton(
            recipeId: recipeId,
            size: size,
            backgroundColor: backgroundColor,
          ),
        ),
        SizedBox(width: spacing),
        _ActionWithLabel(
          label: 'Meal Plan',
          child: MealPlanButton(
            recipeId: recipeId,
            size: size,
            backgroundColor: backgroundColor,
          ),
        ),
        SizedBox(width: spacing),
        _ActionWithLabel(
          label: 'Mark Tried',
          child: TriedButton(
            recipeId: recipeId,
            size: size,
            backgroundColor: backgroundColor,
          ),
        ),
        SizedBox(width: spacing),
        _ActionWithLabel(
          label: 'Share',
          child: ShareButton(
            recipeId: recipeId,
            size: size,
            backgroundColor: backgroundColor,
          ),
        ),
      ],
    );
  }
}

/// A widget that wraps an action button with a label
class _ActionWithLabel extends StatelessWidget {
  const _ActionWithLabel({required this.child, required this.label});

  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        SizedBox(height: ResponsiveUtils.spacing4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// A floating action bar that can be positioned over content
class FloatingUserInteractionActions extends StatelessWidget {
  const FloatingUserInteractionActions({
    super.key,
    required this.recipeId,
    this.bottom,
    this.right,
    this.left,
  });

  final String recipeId;
  final double? bottom;
  final double? right;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom ?? ResponsiveUtils.spacing16,
      right: right,
      left: left,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing16),
        padding: EdgeInsets.all(ResponsiveUtils.spacing12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: UserInteractionActions(
          recipeId: recipeId,
          buttonSize: ResponsiveUtils.iconSize36,
          spacing: ResponsiveUtils.spacing16,
        ),
      ),
    );
  }
}

/// A card-style container for user interaction actions
class UserInteractionCard extends StatelessWidget {
  const UserInteractionCard({
    super.key,
    required this.recipeId,
    this.title = 'Quick Actions',
    this.showTitle = true,
  });

  final String recipeId;
  final String title;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTitle) ...[
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: ResponsiveUtils.spacing16),
          ],
          UserInteractionActions(
            recipeId: recipeId,
            showLabels: true,
            buttonSize: ResponsiveUtils.iconSize44,
            spacing: ResponsiveUtils.spacing8,
          ),
        ],
      ),
    );
  }
}
