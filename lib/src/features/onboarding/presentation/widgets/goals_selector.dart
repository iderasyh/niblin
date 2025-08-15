import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_goal.dart';
import '../../../../../l10n/app_localizations.dart';

class GoalsSelector extends ConsumerWidget {
  const GoalsSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    Widget chip(OnboardingGoal goal, String label) {
      final selected = state.babyProfile.goals.contains(goal);
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => controller.toggleGoal(goal),
        selectedColor: AppColors.tertiary,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip(OnboardingGoal.healthyGrowth, l10n.onboarding_screen9_option_growth),
        chip(OnboardingGoal.preventPickyEating, l10n.onboarding_screen9_option_picky),
        chip(OnboardingGoal.allergenSafety, l10n.onboarding_screen9_option_allergen),
        chip(OnboardingGoal.mealPlanningHelp, l10n.onboarding_screen9_option_planning),
      ],
    );
  }
}


