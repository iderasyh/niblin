import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
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
  final TextEditingController _dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    _nameController.value = _nameController.value.copyWith(
      text: state.babyProfile.babyName,
      selection: TextSelection.collapsed(
        offset: state.babyProfile.babyName.length,
      ),
    );
    final String dobText = state.hasSelectedDateOfBirth
        ? DateFormat.yMMMd().format(state.babyProfile.dateOfBirth)
        : '';
    _dobController.value = _dobController.value.copyWith(
      text: dobText,
      selection: TextSelection.collapsed(offset: dobText.length),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.onboarding_screen5_field_name,
              errorText: state.nameError,
            ),
            onChanged: controller.updateName,
            validator: (value) {
              if ((value ?? '').trim().isEmpty) return l10n.nameRequired;
              return null;
            },
          ),
          SizedBox(height: ResponsiveUtils.height12),
          TextFormField(
            controller: _dobController,
            readOnly: true,
            showCursor: false,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
              labelText: l10n.onboarding_screen5_field_dob,
              errorText: state.dateOfBirthError,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            onTap: () => _showDobPicker(context),
          ),
          SizedBox(height: ResponsiveUtils.height12),
          Text(l10n.onboarding_screen5_field_feeding_style),
          SizedBox(height: ResponsiveUtils.height8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: Text(l10n.purees),
                selected: state.babyProfile.feedingStyle == FeedingStyle.purees,
                onSelected: (_) =>
                    controller.updateFeedingStyle(FeedingStyle.purees),
                selectedColor: AppColors.tertiary,
              ),
              ChoiceChip(
                label: Text(l10n.blw),
                selected: state.babyProfile.feedingStyle == FeedingStyle.blw,
                onSelected: (_) =>
                    controller.updateFeedingStyle(FeedingStyle.blw),
                selectedColor: AppColors.tertiary,
              ),
              ChoiceChip(
                label: Text(l10n.mixed),
                selected: state.babyProfile.feedingStyle == FeedingStyle.mixed,
                onSelected: (_) =>
                    controller.updateFeedingStyle(FeedingStyle.mixed),
                selectedColor: AppColors.tertiary,
              ),
            ],
          ),
          if (!state.hasSelectedFeedingStyle)
            Padding(
              padding: EdgeInsets.only(top: ResponsiveUtils.height8),
              child: Text(
                l10n.pleaseSelectAFeedingStyle,
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showDobPicker(BuildContext context) async {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final localization = AppLocalizations.of(context)!;
    final state = ref.read(onboardingControllerProvider);
    final DateTime now = DateTime.now();
    final DateTime minDate = now.subtract(const Duration(days: 365 * 6));
    final DateTime maxDate = now;
    final DateTime initial = state.hasSelectedDateOfBirth
        ? state.babyProfile.dateOfBirth
        : DateTime(now.year, now.month, now.day);

    final TargetPlatform platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS) {
      DateTime tempPicked = initial;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ResponsiveUtils.radius16),
              ),
            ),
            padding: EdgeInsets.only(
              top: ResponsiveUtils.height12,
              bottom: ResponsiveUtils.height20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(localization.cancel),
                    ),
                    Text(
                      localization.selectDateOfBirth,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.updateDateOfBirth(tempPicked);
                        Navigator.of(ctx).pop();
                      },
                      child: Text(localization.done),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveUtils.height230,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initial,
                    minimumDate: minDate,
                    maximumDate: maxDate,
                    onDateTimeChanged: (DateTime value) {
                      tempPicked = value;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: minDate,
        lastDate: maxDate,
        helpText: localization.selectDateOfBirth,
        cancelText: localization.cancel,
        confirmText: localization.done,
      );
      if (picked != null) {
        controller.updateDateOfBirth(picked);
      }
    }
  }
}
