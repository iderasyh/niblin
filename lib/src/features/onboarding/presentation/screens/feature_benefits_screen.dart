import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../../l10n/app_localizations.dart';

class FeatureBenefitsScreen extends ConsumerWidget {
  const FeatureBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: OnboardingLayout(
        // TODO: Animated carousel showing: recipe grid → allergy tracker screen → shopping list screen.
        image: const Icon(Icons.apps, size: 120, color: Colors.teal),
        title: OnboardingHeader(
          headline: l10n.onboarding_screen4_headline,
          subtext: '• ${l10n.onboarding_screen4_bullet1}\n• ${l10n.onboarding_screen4_bullet2}\n• ${l10n.onboarding_screen4_bullet3}',
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}


