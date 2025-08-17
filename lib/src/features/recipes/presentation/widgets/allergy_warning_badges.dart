import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../features/onboarding/domain/allergen.dart';

/// A widget that displays allergy warning badges with clear visual indicators
class AllergyWarningBadges extends StatelessWidget {
  const AllergyWarningBadges({
    super.key,
    required this.allergens,
    this.showIntroductionTips = true,
  });

  final List<Allergen> allergens;
  final bool showIntroductionTips;

  @override
  Widget build(BuildContext context) {
    if (allergens.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveUtils.spacing8),
          _buildAllergenBadges(context),
          if (showIntroductionTips) ...[
            SizedBox(height: ResponsiveUtils.spacing12),
            _buildIntroductionTips(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.warning_amber_outlined,
          color: AppColors.error,
          size: ResponsiveUtils.iconSize20,
        ),
        SizedBox(width: ResponsiveUtils.spacing8),
        Text(
          'Allergy Information',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildAllergenBadges(BuildContext context) {
    return Wrap(
      spacing: ResponsiveUtils.spacing8,
      runSpacing: ResponsiveUtils.spacing6,
      children: allergens.map((allergen) {
        return _buildAllergenBadge(context, allergen);
      }).toList(),
    );
  }

  Widget _buildAllergenBadge(BuildContext context, Allergen allergen) {
    final allergenData = _getAllergenData(allergen);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing10,
        vertical: ResponsiveUtils.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            allergenData.icon,
            color: AppColors.error,
            size: ResponsiveUtils.iconSize14,
          ),
          SizedBox(width: ResponsiveUtils.spacing4),
          Text(
            allergenData.displayName,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionTips(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing10),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.iconSize16,
              ),
              SizedBox(width: ResponsiveUtils.spacing6),
              Text(
                'Introduction Tips',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing6),
          ...allergens.map((allergen) {
            final tip = _getIntroductionTip(allergen);
            if (tip.isEmpty) return const SizedBox.shrink();
            
            return Padding(
              padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: ResponsiveUtils.spacing6),
                    width: ResponsiveUtils.spacing4,
                    height: ResponsiveUtils.spacing4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.spacing8),
                  Expanded(
                    child: Text(
                      tip,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtils.fontSize12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  _AllergenData _getAllergenData(Allergen allergen) {
    switch (allergen) {
      case Allergen.dairy:
        return const _AllergenData(
          icon: Icons.local_drink_outlined,
          displayName: 'Dairy',
        );
      case Allergen.eggs:
        return const _AllergenData(
          icon: Icons.egg_outlined,
          displayName: 'Eggs',
        );
      case Allergen.peanuts:
        return const _AllergenData(
          icon: Icons.grain_outlined,
          displayName: 'Peanuts',
        );
      case Allergen.wheat:
        return const _AllergenData(
          icon: Icons.grass_outlined,
          displayName: 'Wheat',
        );
      case Allergen.other:
        return const _AllergenData(
          icon: Icons.more_horiz_outlined,
          displayName: 'Other',
        );
    }
  }

  String _getIntroductionTip(Allergen allergen) {
    switch (allergen) {
      case Allergen.dairy:
        return 'Introduce dairy gradually, starting with small amounts mixed into familiar foods.';
      case Allergen.eggs:
        return 'Start with well-cooked eggs. Offer small amounts and watch for reactions.';
      case Allergen.peanuts:
        return 'Introduce peanut products early (around 6 months) to reduce allergy risk.';
      case Allergen.wheat:
        return 'Begin with small amounts of wheat-containing foods and monitor for reactions.';
      case Allergen.other:
        return 'Consult your pediatrician before introducing this allergen.';
    }
  }
}

class _AllergenData {
  const _AllergenData({
    required this.icon,
    required this.displayName,
  });

  final IconData icon;
  final String displayName;
}