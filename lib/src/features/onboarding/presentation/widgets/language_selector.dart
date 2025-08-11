import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../l10n/l10n.dart';
import '../../../../../l10n/locale_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeControllerProvider);
    return PopupMenuButton<String>(
      onSelected: (String newLocale) {
        HapticFeedback.mediumImpact();
        ref.read(localeControllerProvider.notifier).setLocale(newLocale);
      },
      elevation: 1,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      itemBuilder: (BuildContext context) {
        return L10n.all.map((locale) {
          return PopupMenuItem<String>(
            value: locale.languageCode,
            child: Row(
              children: [
                Text(
                  L10n.getFlag(locale.languageCode),
                  style: TextStyle(fontSize: ResponsiveUtils.fontSize20),
                ),
                SizedBox(width: ResponsiveUtils.spacing12),
                Text(L10n.getLanguageName(locale.languageCode)),
              ],
            ),
          );
        }).toList();
      },
      child: _buildLanguageItem(currentLocale),
    );
  }

  /// Builds the language item for the language selector
  /// which is visible in the top-right corner of the screen
  Widget _buildLanguageItem(String currentLocale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing12,
        vertical: ResponsiveUtils.height4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.25),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L10n.getFlag(currentLocale),
            style: TextStyle(fontSize: ResponsiveUtils.fontSize20),
          ),
          SizedBox(width: ResponsiveUtils.spacing8),
          Text(L10n.getLanguageName(currentLocale)),
          SizedBox(width: ResponsiveUtils.spacing4),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: ResponsiveUtils.fontSize20,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
