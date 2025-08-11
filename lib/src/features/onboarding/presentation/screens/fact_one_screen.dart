import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_layout.dart';
import '../../../../../l10n/app_localizations.dart';

class FactOneScreen extends ConsumerStatefulWidget {
  const FactOneScreen({super.key});

  @override
  ConsumerState<FactOneScreen> createState() => _FactOneScreenState();
}

class _FactOneScreenState extends ConsumerState<FactOneScreen>
    with TickerProviderStateMixin {
  bool _isLottieLoaded = false;
  late final AnimationController _controller;
  late final Animation<double> _fadeLottie;
  late final Animation<Offset> _slideLottie;

  // UI animations for title and CTA (start on screen open)
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
      backgroundColor: AppColors.background,
      body: OnboardingLayout(
        image: SizedBox(
          width: 0.5.sw,
          height: 0.5.sw,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  blurRadius: 42,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_isLottieLoaded)
                    FractionalTranslation(
                      translation: const Offset(-0.41, 0.0),
                      child: FadeTransition(
                        opacity: _fadeLottie,
                        child: SlideTransition(
                          position: _slideLottie,
                          child: Lottie.asset(
                            AssetsManager.onboardingFactOne,
                            animate: true,
                            repeat: true,
                            reverse: true,
                            fit: BoxFit.cover,
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
                      ),
                    )
                  else
                    FractionalTranslation(
                      translation: const Offset(-0.41, 0.0),
                      child: Lottie.asset(
                        AssetsManager.onboardingFactOne,
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
          headline: l10n.onboarding_screen2_headline,
          subtext: l10n.onboarding_screen2_subtext,
        ),
      ),
    );
  }
}
