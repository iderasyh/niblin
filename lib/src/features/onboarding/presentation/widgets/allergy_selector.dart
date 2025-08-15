import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/allergen.dart';
import '../../../../../l10n/app_localizations.dart';

class AllergySelector extends ConsumerWidget {
  const AllergySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    Widget chip(Allergen allergen, String label) {
      final selected = state.babyProfile.allergies.contains(allergen);
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => controller.toggleAllergen(allergen),
        selectedColor: AppColors.tertiary,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip(Allergen.dairy, l10n.onboarding_screen7_option_dairy),
        chip(Allergen.eggs, l10n.onboarding_screen7_option_eggs),
        chip(Allergen.peanuts, l10n.onboarding_screen7_option_peanuts),
        chip(Allergen.wheat, l10n.onboarding_screen7_option_wheat),
        chip(Allergen.other, l10n.onboarding_screen7_option_other),
      ],
    );
  }
}


