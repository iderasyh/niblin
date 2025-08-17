import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/baby_stage.dart';

/// A badge widget that displays baby stage information with color-coded styling
class StageBadge extends StatelessWidget {
  const StageBadge({
    super.key,
    required this.stage,
    this.size = StageBadgeSize.small,
  });

  final BabyStage stage;
  final StageBadgeSize size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stageColor = _getStageColor(stage);
    final stageText = _getStageText(l10n, stage);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size == StageBadgeSize.small 
            ? ResponsiveUtils.spacing6 
            : ResponsiveUtils.spacing8,
        vertical: size == StageBadgeSize.small 
            ? ResponsiveUtils.spacing2 
            : ResponsiveUtils.spacing4,
      ),
      decoration: BoxDecoration(
        color: stageColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(
          size == StageBadgeSize.small 
              ? ResponsiveUtils.radius8 
              : ResponsiveUtils.radius12,
        ),
        boxShadow: [
          BoxShadow(
            color: stageColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        stageText,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: size == StageBadgeSize.small 
              ? ResponsiveUtils.fontSize10 
              : ResponsiveUtils.fontSize12,
        ),
      ),
    );
  }

  Color _getStageColor(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return AppColors.primary; // Orange for first stage
      case BabyStage.stage2:
        return AppColors.secondary; // Yellow for second stage
      case BabyStage.stage3:
        return AppColors.tertiary; // Green for third stage
      case BabyStage.toddler:
        return AppColors.neutralDark; // Dark for toddler stage
    }
  }

  String _getStageText(AppLocalizations l10n, BabyStage stage) {
    switch (stage) {
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

enum StageBadgeSize {
  small,
  medium,
}