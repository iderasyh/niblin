import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/assets_manager.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../widgets/baby_profile_form.dart';
import '../../../../../l10n/app_localizations.dart';

class BabyProfileScreen extends ConsumerStatefulWidget {
  const BabyProfileScreen({super.key, required this.availableHeight});

  final double availableHeight;

  @override
  ConsumerState<BabyProfileScreen> createState() => _BabyProfileScreenState();
}

class _BabyProfileScreenState extends ConsumerState<BabyProfileScreen> {
  double? availableHeight;

  @override
  void initState() {
    availableHeight = widget.availableHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: availableHeight,
          width: 1.sw,
          child: OnboardingLayout(
            image: Container(
              height: 0.5.sw,
              width: 0.5.sw,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(AssetsManager.onboardingBabyProfile),
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.75),
                ),
              ),
            ),
            title: OnboardingHeader(
              headline: l10n.onboarding_screen5_headline,
            ),
            subtitle: const BabyProfileForm(),
          ),
        ),
      ),
    );
  }
}


