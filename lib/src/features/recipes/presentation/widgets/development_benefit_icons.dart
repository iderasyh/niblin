import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/development_benefit.dart';

/// A widget that displays development benefit icons with educational tooltips
class DevelopmentBenefitIcons extends StatelessWidget {
  const DevelopmentBenefitIcons({
    super.key,
    required this.benefits,
    this.explanations = const <String, String>{},
    this.showLabels = true,
    this.iconSize,
  });

  final List<DevelopmentBenefit> benefits;
  final Map<String, String> explanations;
  final bool showLabels;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return Wrap(
      spacing: ResponsiveUtils.spacing12,
      runSpacing: ResponsiveUtils.spacing12,
      children: benefits.map((benefit) {
        return _buildBenefitIcon(context, l10n, benefit, currentLocale);
      }).toList(),
    );
  }

  Widget _buildBenefitIcon(
    BuildContext context,
    AppLocalizations l10n,
    DevelopmentBenefit benefit,
    String currentLocale,
  ) {
    final benefitData = _getBenefitData(benefit);
    final explanation = explanations[currentLocale] ?? explanations['en'] ?? '';

    Widget iconWidget = Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing8),
      decoration: BoxDecoration(
        color: benefitData.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: benefitData.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Icon(
        benefitData.icon,
        color: benefitData.color,
        size: iconSize ?? ResponsiveUtils.iconSize24,
      ),
    );

    // Wrap with tooltip if explanation is available
    if (explanation.isNotEmpty) {
      iconWidget = Tooltip(
        message: explanation,
        decoration: BoxDecoration(
          color: AppColors.neutralDark,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
        ),
        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
        ),
        child: iconWidget,
      );
    }

    if (!showLabels) {
      return iconWidget;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        SizedBox(height: ResponsiveUtils.spacing4),
        SizedBox(
          width: ResponsiveUtils.spacing64,
          child: Text(
            _getBenefitDisplayName(l10n, benefit),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  _BenefitData _getBenefitData(DevelopmentBenefit benefit) {
    switch (benefit) {
      case DevelopmentBenefit.brainDevelopment:
        return _BenefitData(
          icon: Icons.psychology_outlined,
          color: AppColors.primary,
        );
      case DevelopmentBenefit.immunity:
        return _BenefitData(
          icon: Icons.shield_outlined,
          color: AppColors.secondary,
        );
      case DevelopmentBenefit.digestiveHealth:
        return _BenefitData(
          icon: Icons.favorite_outline,
          color: AppColors.tertiary,
        );
      case DevelopmentBenefit.boneGrowth:
        return _BenefitData(
          icon: Icons.accessibility_new_outlined,
          color: AppColors.neutralDark,
        );
      case DevelopmentBenefit.eyeHealth:
        return _BenefitData(
          icon: Icons.visibility_outlined,
          color: AppColors.error,
        );
    }
  }

  String _getBenefitDisplayName(AppLocalizations l10n, DevelopmentBenefit benefit) {
    switch (benefit) {
      case DevelopmentBenefit.brainDevelopment:
        return l10n.development_benefit_brain;
      case DevelopmentBenefit.immunity:
        return l10n.development_benefit_immunity;
      case DevelopmentBenefit.digestiveHealth:
        return l10n.development_benefit_digestive;
      case DevelopmentBenefit.boneGrowth:
        return l10n.development_benefit_bone;
      case DevelopmentBenefit.eyeHealth:
        return l10n.development_benefit_eye;
    }
  }
}

class _BenefitData {
  const _BenefitData({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}