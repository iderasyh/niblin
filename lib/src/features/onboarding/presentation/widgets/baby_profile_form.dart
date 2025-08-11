import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/onboarding_controller.dart';
import '../../domain/feeding_style.dart';
import '../../../../../l10n/app_localizations.dart';

class BabyProfileForm extends ConsumerStatefulWidget {
  const BabyProfileForm({super.key});

  @override
  ConsumerState<BabyProfileForm> createState() => _BabyProfileFormState();
}

class _BabyProfileFormState extends ConsumerState<BabyProfileForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    _nameController.value = _nameController.value.copyWith(
      text: state.babyProfile.babyName,
      selection: TextSelection.collapsed(offset: state.babyProfile.babyName.length),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: l10n.onboarding_screen5_field_name,
            errorText: state.nameError,
          ),
          onChanged: controller.updateName,
        ),
        const SizedBox(height: 12),
        InputDatePickerFormField(
          firstDate: DateTime.now().subtract(const Duration(days: 365 * 6)),
          lastDate: DateTime.now(),
          onDateSubmitted: controller.updateDateOfBirth,
          onDateSaved: controller.updateDateOfBirth,
          fieldLabelText: l10n.onboarding_screen5_field_dob,
          errorInvalidText: state.dateOfBirthError,
        ),
        const SizedBox(height: 12),
        Text(l10n.onboarding_screen5_field_feeding_style),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Purees'),
              selected: state.babyProfile.feedingStyle == FeedingStyle.purees,
              onSelected: (_) => controller.updateFeedingStyle(FeedingStyle.purees),
            ),
            ChoiceChip(
              label: const Text('BLW'),
              selected: state.babyProfile.feedingStyle == FeedingStyle.blw,
              onSelected: (_) => controller.updateFeedingStyle(FeedingStyle.blw),
            ),
            ChoiceChip(
              label: const Text('Mixed'),
              selected: state.babyProfile.feedingStyle == FeedingStyle.mixed,
              onSelected: (_) => controller.updateFeedingStyle(FeedingStyle.mixed),
            ),
          ],
        ),
      ],
    );
  }
}


