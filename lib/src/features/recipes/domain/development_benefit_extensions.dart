import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import 'development_benefit.dart';

/// Extension to provide localized names for DevelopmentBenefit enum
extension DevelopmentBenefitLocalization on DevelopmentBenefit {
  /// Get localized display name for the development benefit
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (this) {
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

  /// Get localized display name without context (for use in controllers)
  String getLocalizedNameFromLocale(AppLocalizations l10n) {
    switch (this) {
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