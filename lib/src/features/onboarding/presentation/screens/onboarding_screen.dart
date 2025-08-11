import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/common_widgets.dart/back_arrow.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../routing/app_router.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/onboarding_step.dart';
import '../widgets/onboarding_cta_button.dart';
import 'allergies_preferences_screen.dart';
import 'baby_profile_screen.dart';
import 'fact_one_screen.dart';
import 'fact_three_screen.dart';
import 'fact_two_screen.dart';
import 'feature_benefits_screen.dart';
import 'goals_screen.dart';
import 'locked_preview_screen.dart';
import 'paywall_screen.dart';
import 'relatable_problem_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late final AnimationController _ctaController;
  late final Animation<double> _fadeCta;
  late final Animation<Offset> _slideCta;
  late double _progressFrom;
  late double _progressTo;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final initialProgress =
        ref.read(onboardingControllerProvider).progressFraction;
    _progressFrom = initialProgress;
    _progressTo = initialProgress;
    _ctaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeCta = CurvedAnimation(parent: _ctaController, curve: Curves.easeOut);
    _slideCta = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fadeCta);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctaController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final onboardingPageController = ref.read(
      onboardingControllerProvider.notifier,
    );
    final state = ref.watch(onboardingControllerProvider);
    if (_progressTo != state.progressFraction) {
      _progressFrom = _progressTo;
      _progressTo = state.progressFraction;
    }
    final firstScreen = state.currentStep == OnboardingStep.factOne;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.spacing20),
          child: Column(
            children: [
              Row(
                children: [
                  firstScreen
                      ? IconButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            context.goNamed(AppRoute.welcome.name);
                          },
                          icon: const Icon(Icons.close),
                        )
                      : BackArrow(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            onboardingPageController.previousStep();
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                  SizedBox(width: ResponsiveUtils.spacing12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: _progressFrom,
                          end: _progressTo,
                        ),
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: ResponsiveUtils.height6,
                            backgroundColor: Colors.grey.shade300,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.spacing12),
                  IconButton(
                    onPressed: () {},
                    icon: Text(
                      '${(((state.currentStep.index + 1) / state.totalSteps) * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.spacing24),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const FactOneScreen(),
                    const RelatableProblemScreen(),
                    const FeatureBenefitsScreen(),
                    const BabyProfileScreen(),
                    const FactTwoScreen(),
                    const AllergiesPreferencesScreen(),
                    const FactThreeScreen(),
                    const GoalsScreen(),
                    const LockedPreviewScreen(),
                    const PaywallScreen(),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing24),
              FadeTransition(
                opacity: _fadeCta,
                child: SlideTransition(
                  position: _slideCta,
                  child: OnboardingCtaButton(
                    label: _getCtaLabel(state.currentStep),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      ref
                          .read(onboardingControllerProvider.notifier)
                          .nextStep();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCtaLabel(OnboardingStep currentStep) {
    final l10n = AppLocalizations.of(context)!;
    switch (currentStep) {
      case OnboardingStep.emotionalHook:
        return l10n.onboarding_screen2_cta;
      case OnboardingStep.relatableProblem:
        return l10n.onboarding_screen3_cta;
      case OnboardingStep.featureBenefits:
        return l10n.onboarding_screen4_cta;
      case OnboardingStep.babyProfile:
        return l10n.onboarding_screen5_cta;
      case OnboardingStep.factTwo:
        return l10n.onboarding_screen6_cta;
      case OnboardingStep.allergiesPreferences:
        return l10n.onboarding_screen7_cta;
      case OnboardingStep.factThree:
        return l10n.onboarding_screen8_cta;
      case OnboardingStep.goals:
        return l10n.onboarding_screen9_cta;
      case OnboardingStep.lockedPreview:
        return l10n.onboarding_screen10_cta;
      case OnboardingStep.paywall:
        return l10n.onboarding_screen11_cta;
      case OnboardingStep.factOne:
        return l10n.onboarding_screen2_cta;
    }
  }
}
