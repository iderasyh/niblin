enum BabyStage {
  stage1(4, 6),
  stage2(6, 8),
  stage3(8, 12),
  toddler(12, 24);

  const BabyStage(this.minMonths, this.maxMonths);
  
  final int minMonths;
  final int maxMonths;

  String get displayNameKey {
    switch (this) {
      case BabyStage.stage1:
        return 'baby_stage_1';
      case BabyStage.stage2:
        return 'baby_stage_2';
      case BabyStage.stage3:
        return 'baby_stage_3';
      case BabyStage.toddler:
        return 'baby_stage_toddler';
    }
  }

  bool isAppropriateForAge(int ageInMonths) {
    return ageInMonths >= minMonths && ageInMonths < maxMonths;
  }
}