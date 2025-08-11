import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    this.topLeft,
    this.topRight,
    this.progress,
    this.topWidget,
    this.secondaryButton,
    this.primaryButton,
  });

  final Widget image;
  final Widget title;
  final Widget? subtitle;
  final Widget? primaryButton;
  final Widget? topLeft;
  final Widget? topRight;
  final double? progress;
  final Widget? topWidget;
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing20,
          vertical: ResponsiveUtils.height20,
        ),
        child: Column(
          children: [
            topWidget ??
                Row(
                  children: [
                    if (topLeft != null) ...[
                      topLeft!,
                      SizedBox(width: ResponsiveUtils.spacing12),
                    ],
                    if (progress != null)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: ResponsiveUtils.height6,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    if (topRight != null) ...[
                      SizedBox(width: ResponsiveUtils.spacing12),
                      topRight!,
                    ],
                  ],
                ),
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeOut,
              child: image,
              builder: (context, value, child) {
                final double translateY = 20 * (1 - value);
                final double scale = 0.95 + 0.05 * value;
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, translateY),
                    child: Transform.scale(
                      scale: scale,
                      child: Center(child: child),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ResponsiveUtils.height24),
            title,
            if (subtitle != null) ...[
              SizedBox(height: ResponsiveUtils.height16),
              subtitle!,
            ],
            const Spacer(),
            if (primaryButton != null) ...[
              primaryButton!,
            ],
            if (secondaryButton != null) ...[
              SizedBox(height: ResponsiveUtils.height8),
              secondaryButton!,
            ],
          ],
        ),
      ),
    );
  }
}
