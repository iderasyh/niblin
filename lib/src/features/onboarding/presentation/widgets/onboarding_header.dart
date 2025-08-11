import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class OnboardingHeader extends StatefulWidget {
  const OnboardingHeader({
    super.key,
    required this.headline,
    this.subtext,
    this.textAlign = TextAlign.center,
  });
  final String headline;
  final String? subtext;
  final TextAlign textAlign;

  @override
  State<OnboardingHeader> createState() => _OnboardingHeaderState();
}

class _OnboardingHeaderState extends State<OnboardingHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _uiController;
  late final Animation<double> _fadeTitle;
  late final Animation<Offset> _slideTitle;

  @override
  void initState() {
    super.initState();
    _uiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeTitle = CurvedAnimation(
      parent: _uiController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideTitle = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(_fadeTitle);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _uiController.forward();
    });
  }

  @override
  void dispose() {
    _uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headline = widget.headline;
    final subtext = widget.subtext;
    final textAlign = widget.textAlign;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing20),
      child: FadeTransition(
        opacity: _fadeTitle,
        child: SlideTransition(
          position: _slideTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                headline,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              if (subtext != null) ...[
                SizedBox(height: ResponsiveUtils.height8),
                Text(
                  subtext,
                  textAlign: textAlign,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
