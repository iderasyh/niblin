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
    );
  }

  final OnboardingStep currentStep;
  final int totalSteps;
  final BabyProfile babyProfile;

  final String? nameError;
  final String? dateOfBirthError;

  final bool isSaving;
  final String? errorMessage;

  bool get isValidProfile => nameError == null && dateOfBirthError == null;

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
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      babyProfile: babyProfile ?? this.babyProfile,
      nameError: nameError,
      dateOfBirthError: dateOfBirthError,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
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
        other.errorMessage == errorMessage;
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
      );
}


