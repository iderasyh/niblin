import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../../l10n/app_localizations.dart';

class LockedPreviewScreen extends ConsumerWidget {
  const LockedPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: OnboardingLayout(
        image: const Icon(Icons.lock, size: 120, color: Colors.grey),
        title: OnboardingHeader(
          headline: l10n.onboarding_screen10_headline,
          subtext: l10n.onboarding_screen10_subtext,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _blurredCard(l10n.onboarding_screen10_recipe1),
            const SizedBox(height: 8),
            _blurredCard(l10n.onboarding_screen10_recipe2),
            const SizedBox(height: 8),
            _blurredCard(l10n.onboarding_screen10_recipe3),
          ],
        ),
      ),
    );
  }

  Widget _blurredCard(String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(
            height: 56,
            color: Colors.orange.shade100,
          ),
          Container(
            height: 56,
            color: Colors.white.withOpacity(0.7),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          )
        ],
      ),
    );
  }
}


