import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../../l10n/app_localizations.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: OnboardingLayout(
        image: const Icon(Icons.credit_card, size: 120, color: Colors.blueGrey),
        title: OnboardingHeader(
          headline: l10n.onboarding_screen11_headline,
          subtext:
              '• ${l10n.onboarding_screen11_bullet1}\n• ${l10n.onboarding_screen11_bullet2}\n• ${l10n.onboarding_screen11_bullet3}\n• ${l10n.onboarding_screen11_bullet4}\n\n${l10n.onboarding_screen11_pricing_highlight}\n${l10n.onboarding_screen11_guarantee}',
          textAlign: TextAlign.left,
        ),
        
      ),
    );
  }
}


