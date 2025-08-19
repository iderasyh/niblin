import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/cache_service.dart';
import '../../../onboarding/domain/baby_profile.dart';

class BabyStatusWidget extends ConsumerWidget {
  const BabyStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);

    final cacheData = ref.watch(cacheServiceProvider);
    final babyProfile = cacheData[CacheKey.babyProfile.name] as BabyProfile?;

    if (babyProfile == null) {
      return const SizedBox.shrink();
    }

    final ageInMonths = babyProfile.ageInMonths;
    final ageText = ageInMonths == 1
        ? '1 ${localization?.monthOld}'
        : '$ageInMonths ${localization?.monthsOld}';

    return Text(
      '${babyProfile.babyName}, $ageText',
      style: Theme.of(
        context,
      ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
    );
  }
}
