import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/onboarding_repository.dart';
import '../domain/allergen.dart';
import '../domain/feeding_style.dart';
import '../domain/onboarding_goal.dart';
import '../domain/onboarding_step.dart';
import 'onboarding_state.dart';

part 'onboarding_controller.g.dart';

@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    return OnboardingState.initial();
  }

  void goToStep(OnboardingStep step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    final index = OnboardingStep.values.indexOf(state.currentStep);
    if (index < OnboardingStep.values.length - 1) {
      state = state.copyWith(currentStep: OnboardingStep.values[index + 1]);
    }
  }

  void previousStep() {
    final index = OnboardingStep.values.indexOf(state.currentStep);
    if (index > 0) {
      state = state.copyWith(currentStep: OnboardingStep.values[index - 1]);
    }
  }

  void updateName(String name) {
    final String? nameError = name.trim().isEmpty ? 'Name required' : null;
    state = state.copyWith(
      babyProfile: state.babyProfile.copyWith(babyName: name),
      nameError: nameError,
    );
  }

  void updateDateOfBirth(DateTime date) {
    // Consider reasonable DOB: not in future and not older than 5 years
    final now = DateTime.now();
    String? dobError;
    if (date.isAfter(now)) {
      dobError = 'Invalid date';
    } else if (now.difference(date).inDays > 365 * 6) {
      dobError = 'Too old';
    }
    state = state.copyWith(
      babyProfile: state.babyProfile.copyWith(dateOfBirth: date),
      dateOfBirthError: dobError,
    );
  }

  void updateFeedingStyle(FeedingStyle style) {
    state = state.copyWith(
      babyProfile: state.babyProfile.copyWith(feedingStyle: style),
    );
  }

  void toggleAllergen(Allergen allergen) {
    final current = List<Allergen>.from(state.babyProfile.allergies);
    if (current.contains(allergen)) {
      current.remove(allergen);
    } else {
      current.add(allergen);
    }
    state = state.copyWith(
      babyProfile: state.babyProfile.copyWith(allergies: current),
    );
  }

  void toggleGoal(OnboardingGoal goal) {
    final current = List<OnboardingGoal>.from(state.babyProfile.goals);
    if (current.contains(goal)) {
      current.remove(goal);
    } else {
      current.add(goal);
    }
    state = state.copyWith(
      babyProfile: state.babyProfile.copyWith(goals: current),
    );
  }

  Future<void> saveProfileAndProceed() async {
    final repo = ref.read(onboardingRepositoryProvider);
    // Validate minimal requirements
    if (state.babyProfile.babyName.trim().isEmpty) {
      state = state.copyWith(nameError: 'Name required');
      return;
    }
    if (state.dateOfBirthError != null) {
      return;
    }
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      await repo.saveBabyProfile(state.babyProfile);
      nextStep();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<void> completeOnboarding() async {
    final repo = ref.read(onboardingRepositoryProvider);
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      await repo.setOnboardingCompleted(true);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }
}


