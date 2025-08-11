import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../widgets/goals_selector.dart';
import '../../../../../l10n/app_localizations.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: OnboardingLayout(
        image: Container(
          height: ResponsiveUtils.height230,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
            image: DecorationImage(
              image: AssetImage(AssetsManager.onboardingGoals),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: OnboardingHeader(
          headline: l10n.onboarding_screen9_headline,
        ),
        subtitle: const GoalsSelector(),
      ),
    );
  }
}


