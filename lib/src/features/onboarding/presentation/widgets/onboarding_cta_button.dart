import 'package:flutter/material.dart';

import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingCtaButton extends StatelessWidget {
  const OnboardingCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.primary),
          foregroundColor: WidgetStateProperty.all(AppColors.textOnButton),
          overlayColor: WidgetStateProperty.all(AppColors.primary),
          shadowColor: WidgetStateProperty.all(AppColors.primary),
          surfaceTintColor: WidgetStateProperty.all(AppColors.primary),
          textStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.titleLarge,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: isLoading
              ? const LoadingIndicator(color: AppColors.textOnButton)
              : Text(label),
        ),
      ),
    );
  }
}
