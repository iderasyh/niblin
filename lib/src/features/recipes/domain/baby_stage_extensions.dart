import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import 'baby_stage.dart';

/// Extension to provide localized names for BabyStage enum
extension BabyStageLocalization on BabyStage {
  /// Get localized display name for the baby stage
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (this) {
      case BabyStage.stage1:
        return l10n.baby_stage_1;
      case BabyStage.stage2:
        return l10n.baby_stage_2;
      case BabyStage.stage3:
        return l10n.baby_stage_3;
      case BabyStage.toddler:
        return l10n.baby_stage_toddler;
    }
  }

  /// Get localized display name without context (for use in controllers)
  String getLocalizedNameFromLocale(AppLocalizations l10n) {
    switch (this) {
      case BabyStage.stage1:
        return l10n.baby_stage_1;
      case BabyStage.stage2:
        return l10n.baby_stage_2;
      case BabyStage.stage3:
        return l10n.baby_stage_3;
      case BabyStage.toddler:
        return l10n.baby_stage_toddler;
    }
  }
}