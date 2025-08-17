import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../features/onboarding/domain/allergen.dart';
import '../../domain/baby_stage.dart';
import 'allergy_warning_badges.dart';
import 'texture_progression_guide.dart';

/// A widget that displays serving guidance with texture consistency guide and age-appropriate information
class ServingGuidanceWidget extends StatelessWidget {
  const ServingGuidanceWidget({
    super.key,
    required this.servingGuidance,
    required this.supportedStages,
    required this.allergens,
    required this.servings,
    this.selectedStage,
  });

  final Map<String, String> servingGuidance;
  final List<BabyStage> supportedStages;
  final List<Allergen> allergens;
  final int servings;
  final BabyStage? selectedStage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;
    final guidance = servingGuidance[currentLocale] ?? 
                    servingGuidance['en'] ?? 
                    'Serve according to your baby\'s developmental stage';

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, l10n),
          SizedBox(height: ResponsiveUtils.spacing16),
          _buildServingSizeSection(context, l10n),
          SizedBox(height: ResponsiveUtils.spacing16),
          _buildGuidanceText(context, guidance),
          if (allergens.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.spacing16),
            AllergyWarningBadges(allergens: allergens),
          ],
          SizedBox(height: ResponsiveUtils.spacing16),
          TextureProgressionGuide(
            supportedStages: supportedStages,
            selectedStage: selectedStage,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
          ),
          child: Icon(
            Icons.restaurant_menu_outlined,
            color: AppColors.secondary,
            size: ResponsiveUtils.iconSize20,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Serving Guidance',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Age-appropriate serving tips',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServingSizeSection(BuildContext context, AppLocalizations l10n) {
    final currentStage = selectedStage ?? supportedStages.first;
    final servingSize = _calculateServingSize(currentStage);
    
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.straighten_outlined,
            color: AppColors.secondary,
            size: ResponsiveUtils.iconSize24,
          ),
          SizedBox(width: ResponsiveUtils.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Serving Size',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing2),
                Text(
                  servingSize,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing8,
              vertical: ResponsiveUtils.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
            ),
            child: Text(
              '$servings servings',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceText(BuildContext context, String guidance) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.textSecondary,
            size: ResponsiveUtils.iconSize20,
          ),
          SizedBox(width: ResponsiveUtils.spacing8),
          Expanded(
            child: Text(
              guidance,
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

  String _calculateServingSize(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return '1-2 tablespoons (15-30ml)';
      case BabyStage.stage2:
        return '2-4 tablespoons (30-60ml)';
      case BabyStage.stage3:
        return '1/4 to 1/2 cup (60-120ml)';
      case BabyStage.toddler:
        return '1/2 to 1 cup (120-240ml)';
    }
  }
}