import '../../recipes/domain/baby_stage.dart';

class Baby {
  final DateTime birthday;

  Baby({required this.birthday});

  /// Calculate baby's age in months
  int get ageInMonths {
    final now = DateTime.now();
    final difference = now.difference(birthday);
    return (difference.inDays / 30.44).floor(); // Average days per month
  }

  /// Get the appropriate baby stage based on current age
  BabyStage? get currentStage {
    final age = ageInMonths;

    for (final stage in BabyStage.values) {
      if (stage.isAppropriateForAge(age)) {
        return stage;
      }
    }

    // If baby is too young (under 4 months) or too old (over 24 months)
    return null;
  }
}
