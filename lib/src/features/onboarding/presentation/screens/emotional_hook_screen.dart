import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/onboarding_controller.dart';
import '../widgets/language_selector.dart';
import '../widgets/onboarding_cta_button.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../routing/app_router.dart';

class EmotionalHookScreen extends ConsumerWidget {
  const EmotionalHookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: OnboardingLayout(
        topWidget: Row(
          children: [
            // TODO: Add logoo
            Icon(
              Icons.logo_dev,
              size: ResponsiveUtils.spacing30,
              color: AppColors.primary,
            ),
            SizedBox(width: ResponsiveUtils.spacing8),
            Expanded(
              child: Text(
                'Niblin',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.primary),
              ),
            ),
            LanguageSelector(),
          ],
        ),
        image: Container(
          height: 0.5.sw,
          width: 0.5.sw,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(AssetsManager.onboardingEmotionalHook),
            ),
          ),
        ),
        title: OnboardingHeader(
          headline: l10n.onboarding_screen1_headline,
          subtext: l10n.onboarding_screen1_subtext,
        ),
        primaryButton: OnboardingCtaButton(
          label: l10n.onboarding_screen1_cta,
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref.read(onboardingControllerProvider.notifier).nextStep();
            context.goNamed(AppRoute.onboarding.name);
          },
        ),
        secondaryButton: TextButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
          },
          child: Text(
            l10n.onboarding_screen1_secondary_button,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
