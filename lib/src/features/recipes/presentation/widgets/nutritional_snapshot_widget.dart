import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/nutritional_info.dart';
import 'development_benefit_icons.dart';

/// A widget that displays a nutritional snapshot with vitamins, minerals, and development benefits
class NutritionalSnapshotWidget extends StatelessWidget {
  const NutritionalSnapshotWidget({
    super.key,
    required this.nutritionalInfo,
    this.showFullDetails = false,
  });

  final NutritionalInfo nutritionalInfo;
  final bool showFullDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveUtils.spacing12),
          _buildCaloriesSection(context),
          if (showFullDetails) ...[
            SizedBox(height: ResponsiveUtils.spacing16),
            _buildVitaminsSection(context),
            SizedBox(height: ResponsiveUtils.spacing16),
            _buildMineralsSection(context),
          ],
          SizedBox(height: ResponsiveUtils.spacing16),
          _buildDevelopmentBenefitsSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing8),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
          ),
          child: Icon(
            Icons.local_dining_outlined,
            color: AppColors.tertiary,
            size: ResponsiveUtils.iconSize20,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutritional Snapshot',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Per serving',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department_outlined,
            color: AppColors.primary,
            size: ResponsiveUtils.iconSize24,
          ),
          SizedBox(width: ResponsiveUtils.spacing12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${nutritionalInfo.caloriesPerServing}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'calories',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitaminsSection(BuildContext context) {
    if (nutritionalInfo.vitamins.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Vitamins',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing8),
        Wrap(
          spacing: ResponsiveUtils.spacing8,
          runSpacing: ResponsiveUtils.spacing8,
          children: nutritionalInfo.vitamins.entries.take(4).map((entry) {
            return _buildNutrientChip(
              context,
              entry.key,
              '${entry.value.toStringAsFixed(1)}mg',
              AppColors.secondary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMineralsSection(BuildContext context) {
    if (nutritionalInfo.minerals.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Essential Minerals',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing8),
        Wrap(
          spacing: ResponsiveUtils.spacing8,
          runSpacing: ResponsiveUtils.spacing8,
          children: nutritionalInfo.minerals.entries.take(4).map((entry) {
            return _buildNutrientChip(
              context,
              entry.key,
              '${entry.value.toStringAsFixed(1)}mg',
              AppColors.tertiary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDevelopmentBenefitsSection(BuildContext context) {
    if (nutritionalInfo.developmentBenefits.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Development Benefits',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: ResponsiveUtils.spacing8),
        DevelopmentBenefitIcons(
          benefits: nutritionalInfo.developmentBenefits,
          explanations: nutritionalInfo.benefitExplanations,
        ),
      ],
    );
  }

  Widget _buildNutrientChip(
    BuildContext context,
    String name,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing12,
        vertical: ResponsiveUtils.spacing6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(width: ResponsiveUtils.spacing4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
