import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../../l10n/app_localizations.dart';

class FactTwoScreen extends ConsumerStatefulWidget {
  const FactTwoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FactTwoScreenState();
}

class _FactTwoScreenState extends ConsumerState<FactTwoScreen>
    with TickerProviderStateMixin {
  bool _isLottieLoaded = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeLottie;
  late final Animation<Offset> _slideLottie;
  late final AnimationController _uiController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeLottie = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideLottie = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(_fadeLottie);

    // Title and CTA animations (immediately on open)
    _uiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start UI animations on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _uiController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: OnboardingLayout(
        image: SizedBox(
          width: 1.sw,
          height: ResponsiveUtils.height200,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_isLottieLoaded)
                    FadeTransition(
                      opacity: _fadeLottie,
                      child: SlideTransition(
                        position: _slideLottie,
                        child: const SizedBox.expand(
                          child: _FactTwoLottie(),
                        ),
                      ),
                    )
                  else
                    SizedBox.expand(
                      child: Lottie.asset(
                        AssetsManager.onboardingFactTwo,
                        animate: false,
                        repeat: false,
                        reverse: false,
                        fit: BoxFit.cover,
                        onLoaded: (_) {
                          if (!mounted) return;
                          setState(() => _isLottieLoaded = true);
                          _controller.forward();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                            ),
                          );
                        },
                      ),
                    ),
                  AnimatedOpacity(
                    opacity: _isLottieLoaded ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Center(child: LoadingIndicator()),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: OnboardingHeader(
          headline: l10n.onboarding_screen6_headline,
          subtext: l10n.onboarding_screen6_subtext,
        ),
      ),
    );
  }
}

class _FactTwoLottie extends StatelessWidget {
  const _FactTwoLottie();

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      AssetsManager.onboardingFactTwo,
      animate: true,
      repeat: true,
      reverse: true,
      fit: BoxFit.cover,
    );
  }
}
