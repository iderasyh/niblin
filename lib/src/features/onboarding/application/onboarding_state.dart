import '../domain/allergen.dart';
import '../domain/baby_profile.dart';
import '../domain/feeding_style.dart';
import '../domain/onboarding_goal.dart';
import '../domain/onboarding_step.dart';

class OnboardingState {
  const OnboardingState({
    required this.currentStep,
    required this.totalSteps,
    required this.babyProfile,
    this.nameError,
    this.dateOfBirthError,
    this.isSaving = false,
    this.errorMessage,
    this.hasSelectedDateOfBirth = false,
    this.hasSelectedFeedingStyle = false,
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      currentStep: OnboardingStep.emotionalHook,
      totalSteps: OnboardingStep.values.length,
      babyProfile: BabyProfile(
        babyName: '',
        dateOfBirth: DateTime.now(),
        feedingStyle: FeedingStyle.purees,
        allergies: const <Allergen>[],
        goals: const <OnboardingGoal>[],
      ),
      hasSelectedDateOfBirth: false,
      hasSelectedFeedingStyle: true,
    );
  }

  final OnboardingStep currentStep;
  final int totalSteps;
  final BabyProfile babyProfile;

  final String? nameError;
  final String? dateOfBirthError;

  final bool isSaving;
  final String? errorMessage;
  final bool hasSelectedDateOfBirth;
  final bool hasSelectedFeedingStyle;

  bool get isValidProfile => nameError == null && dateOfBirthError == null;

  // Profile is considered complete when:
  // - name is non-empty and has no error
  // - date of birth has no error
  // - feeding style is selected (always non-null in model)
  bool get isProfileComplete {
    final bool hasName = babyProfile.babyName.trim().isNotEmpty;
    final bool hasValidDob = dateOfBirthError == null;
    return hasName && hasValidDob && hasSelectedDateOfBirth && hasSelectedFeedingStyle;
  }

  bool get hasSelectedGoals => babyProfile.goals.isNotEmpty;

  double get progressFraction {
    final index = OnboardingStep.values.indexOf(currentStep) + 1;
    return index / totalSteps;
  }

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    int? totalSteps,
    BabyProfile? babyProfile,
    String? nameError,
    String? dateOfBirthError,
    bool? isSaving,
    String? errorMessage,
    bool? hasSelectedDateOfBirth,
    bool? hasSelectedFeedingStyle,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      babyProfile: babyProfile ?? this.babyProfile,
      nameError: nameError,
      dateOfBirthError: dateOfBirthError,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      hasSelectedDateOfBirth: hasSelectedDateOfBirth ?? this.hasSelectedDateOfBirth,
      hasSelectedFeedingStyle: hasSelectedFeedingStyle ?? this.hasSelectedFeedingStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingState &&
        other.currentStep == currentStep &&
        other.totalSteps == totalSteps &&
        other.babyProfile == babyProfile &&
        other.nameError == nameError &&
        other.dateOfBirthError == dateOfBirthError &&
        other.isSaving == isSaving &&
        other.errorMessage == errorMessage &&
        other.hasSelectedDateOfBirth == hasSelectedDateOfBirth &&
        other.hasSelectedFeedingStyle == hasSelectedFeedingStyle;
  }

  @override
  int get hashCode => Object.hash(
        currentStep,
        totalSteps,
        babyProfile,
        nameError,
        dateOfBirthError,
        isSaving,
        errorMessage,
        hasSelectedDateOfBirth,
        hasSelectedFeedingStyle,
      );
}


