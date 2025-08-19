import '../../recipes/domain/baby_stage.dart';
import 'allergen.dart';
import 'feeding_style.dart';
import 'onboarding_goal.dart';

class BabyProfile {
  const BabyProfile({
    required this.babyName,
    required this.dateOfBirth,
    required this.feedingStyle,
    this.allergies = const <Allergen>[],
    this.goals = const <OnboardingGoal>[],
  });

  final String babyName;
  final DateTime dateOfBirth;
  final FeedingStyle feedingStyle;
  final List<Allergen> allergies;
  final List<OnboardingGoal> goals;

  BabyProfile copyWith({
    String? babyName,
    DateTime? dateOfBirth,
    FeedingStyle? feedingStyle,
    List<Allergen>? allergies,
    List<OnboardingGoal>? goals,
  }) {
    return BabyProfile(
      babyName: babyName ?? this.babyName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      feedingStyle: feedingStyle ?? this.feedingStyle,
      allergies: allergies ?? this.allergies,
      goals: goals ?? this.goals,
    );
  }

  /// Calculate baby's age in months
  int get ageInMonths {
    final now = DateTime.now();
    final difference = now.difference(dateOfBirth);
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'babyName': babyName,
      'dateOfBirthIso': dateOfBirth.toIso8601String(),
      'feedingStyle': feedingStyle.name,
      'allergies': allergies.map((a) => a.name).toList(),
      'goals': goals.map((g) => g.name).toList(),
    };
  }

  factory BabyProfile.fromMap(Map<String, dynamic> map) {
    final dynamic dateIso = map['dateOfBirthIso'];
    return BabyProfile(
      babyName: map['babyName'] as String,
      dateOfBirth: dateIso is String
          ? DateTime.parse(dateIso)
          : DateTime.fromMillisecondsSinceEpoch(map['dateOfBirthMs'] as int),
      feedingStyle: FeedingStyle.values.firstWhere(
        (e) => e.name == (map['feedingStyle'] as String),
        orElse: () => FeedingStyle.purees,
      ),
      allergies: (map['allergies'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (e) => Allergen.values.firstWhere(
              (a) => a.name == (e as String),
              orElse: () => Allergen.other,
            ),
          )
          .toList(),
      goals: (map['goals'] as List<dynamic>? ?? const <dynamic>[])
          .map(
            (e) => OnboardingGoal.values.firstWhere(
              (g) => g.name == (e as String),
              orElse: () => OnboardingGoal.healthyGrowth,
            ),
          )
          .toList(),
    );
  }

  @override
  String toString() {
    return 'BabyProfile(babyName: '
        '$babyName, dateOfBirth: $dateOfBirth, feedingStyle: $feedingStyle, allergies: $allergies, goals: $goals)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BabyProfile &&
        other.babyName == babyName &&
        other.dateOfBirth == dateOfBirth &&
        other.feedingStyle == feedingStyle &&
        _listEquals(other.allergies, allergies) &&
        _listEquals(other.goals, goals);
  }

  @override
  int get hashCode {
    return Object.hash(
      babyName,
      dateOfBirth,
      feedingStyle,
      Object.hashAll(allergies),
      Object.hashAll(goals),
    );
  }
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
