import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/baby_stage.dart';

/// A widget that displays texture progression visual guide for different baby stages
class TextureProgressionGuide extends StatelessWidget {
  const TextureProgressionGuide({
    super.key,
    required this.supportedStages,
    this.selectedStage,
    this.onStageSelected,
  });

  final List<BabyStage> supportedStages;
  final BabyStage? selectedStage;
  final ValueChanged<BabyStage>? onStageSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveUtils.spacing12),
          _buildStageSelector(context, l10n),
          SizedBox(height: ResponsiveUtils.spacing12),
          _buildTextureDescription(context, l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.timeline_outlined,
          color: AppColors.textPrimary,
          size: ResponsiveUtils.iconSize20,
        ),
        SizedBox(width: ResponsiveUtils.spacing8),
        Text(
          'Texture Progression',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStageSelector(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: supportedStages.map((stage) {
          final isSelected = selectedStage == stage;
          final stageData = _getStageData(stage, l10n);
          
          return GestureDetector(
            onTap: () => onStageSelected?.call(stage),
            child: Container(
              margin: EdgeInsets.only(right: ResponsiveUtils.spacing8),
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing12,
                vertical: ResponsiveUtils.spacing8,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? stageData.color.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
                border: Border.all(
                  color: isSelected 
                      ? stageData.color
                      : AppColors.textSecondary.withValues(alpha: 0.3),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    stageData.icon,
                    color: isSelected ? stageData.color : AppColors.textSecondary,
                    size: ResponsiveUtils.iconSize16,
                  ),
                  SizedBox(width: ResponsiveUtils.spacing6),
                  Text(
                    stageData.shortName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected ? stageData.color : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextureDescription(BuildContext context, AppLocalizations l10n) {
    final currentStage = selectedStage ?? supportedStages.first;
    final stageData = _getStageData(currentStage, l10n);
    
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: stageData.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
        border: Border.all(
          color: stageData.color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                stageData.icon,
                color: stageData.color,
                size: ResponsiveUtils.iconSize20,
              ),
              SizedBox(width: ResponsiveUtils.spacing8),
              Expanded(
                child: Text(
                  stageData.fullName,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: stageData.color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.spacing8),
          Text(
            stageData.textureDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing8),
          _buildTextureVisual(context, currentStage, stageData.color),
        ],
      ),
    );
  }

  Widget _buildTextureVisual(BuildContext context, BabyStage stage, Color color) {
    return Row(
      children: [
        Text(
          'Texture:',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing8),
        Expanded(
          child: _getTextureVisual(stage, color),
        ),
      ],
    );
  }

  Widget _getTextureVisual(BabyStage stage, Color color) {
    switch (stage) {
      case BabyStage.stage1:
        // Smooth puree - single smooth circle
        return Row(
          children: [
            Container(
              width: ResponsiveUtils.spacing20,
              height: ResponsiveUtils.spacing20,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing4),
            Text(
              'Smooth puree',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      
      case BabyStage.stage2:
        // Mashed with lumps - multiple small circles
        return Row(
          children: [
            ...List.generate(3, (index) => Container(
              margin: EdgeInsets.only(right: ResponsiveUtils.spacing2),
              width: ResponsiveUtils.spacing12 + (index * 2),
              height: ResponsiveUtils.spacing12 + (index * 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.3 + (index * 0.1)),
                shape: BoxShape.circle,
              ),
            )),
            SizedBox(width: ResponsiveUtils.spacing4),
            Text(
              'Mashed with lumps',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      
      case BabyStage.stage3:
        // Soft finger foods - rectangular shapes
        return Row(
          children: [
            ...List.generate(3, (index) => Container(
              margin: EdgeInsets.only(right: ResponsiveUtils.spacing2),
              width: ResponsiveUtils.spacing8,
              height: ResponsiveUtils.spacing16,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius2),
              ),
            )),
            SizedBox(width: ResponsiveUtils.spacing4),
            Text(
              'Soft finger foods',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      
      case BabyStage.toddler:
        // Regular texture - mixed shapes
        return Row(
          children: [
            Container(
              width: ResponsiveUtils.spacing12,
              height: ResponsiveUtils.spacing12,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing2),
            Container(
              width: ResponsiveUtils.spacing8,
              height: ResponsiveUtils.spacing16,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius2),
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing2),
            Container(
              width: ResponsiveUtils.spacing10,
              height: ResponsiveUtils.spacing10,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.4),
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing4),
            Text(
              'Regular texture',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
    }
  }

  _StageData _getStageData(BabyStage stage, AppLocalizations l10n) {
    switch (stage) {
      case BabyStage.stage1:
        return _StageData(
          icon: Icons.water_drop_outlined,
          color: AppColors.primary,
          shortName: 'Stage 1',
          fullName: l10n.baby_stage_1,
          textureDescription: 'Smooth, thin purees that flow easily off a spoon. No lumps or chunks.',
        );
      case BabyStage.stage2:
        return _StageData(
          icon: Icons.grain_outlined,
          color: AppColors.secondary,
          shortName: 'Stage 2',
          fullName: l10n.baby_stage_2,
          textureDescription: 'Thicker purees with small, soft lumps. Baby can handle more texture.',
        );
      case BabyStage.stage3:
        return _StageData(
          icon: Icons.restaurant_outlined,
          color: AppColors.tertiary,
          shortName: 'Stage 3',
          fullName: l10n.baby_stage_3,
          textureDescription: 'Soft finger foods and chunky textures. Baby can pick up and chew soft pieces.',
        );
      case BabyStage.toddler:
        return _StageData(
          icon: Icons.child_care_outlined,
          color: AppColors.neutralDark,
          shortName: 'Toddler',
          fullName: l10n.baby_stage_toddler,
          textureDescription: 'Regular family foods with varied textures. Can handle most adult textures.',
        );
    }
  }
}

class _StageData {
  const _StageData({
    required this.icon,
    required this.color,
    required this.shortName,
    required this.fullName,
    required this.textureDescription,
  });

  final IconData icon;
  final Color color;
  final String shortName;
  final String fullName;
  final String textureDescription;
}