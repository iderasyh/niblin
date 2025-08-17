enum DevelopmentBenefit {
  brainDevelopment,
  immunity,
  digestiveHealth,
  boneGrowth,
  eyeHealth,
}

extension DevelopmentBenefitExtension on DevelopmentBenefit {
  String get displayNameKey {
    switch (this) {
      case DevelopmentBenefit.brainDevelopment:
        return 'development_benefit_brain';
      case DevelopmentBenefit.immunity:
        return 'development_benefit_immunity';
      case DevelopmentBenefit.digestiveHealth:
        return 'development_benefit_digestive';
      case DevelopmentBenefit.boneGrowth:
        return 'development_benefit_bone';
      case DevelopmentBenefit.eyeHealth:
        return 'development_benefit_eye';
    }
  }
}