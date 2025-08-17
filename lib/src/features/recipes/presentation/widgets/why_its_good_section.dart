import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/nutritional_info.dart';

/// A widget that displays "Why It's Good" explanation section with localization support
class WhyItsGoodSection extends StatefulWidget {
  const WhyItsGoodSection({
    super.key,
    required this.nutritionalInfo,
    required this.whyKidsLoveThis,
    this.isExpanded = false,
  });

  final NutritionalInfo nutritionalInfo;
  final Map<String, String> whyKidsLoveThis;
  final bool isExpanded;

  @override
  State<WhyItsGoodSection> createState() => _WhyItsGoodSectionState();
}

class _WhyItsGoodSectionState extends State<WhyItsGoodSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final benefitExplanation = widget.nutritionalInfo.benefitExplanations[currentLocale] ??
        widget.nutritionalInfo.benefitExplanations['en'] ?? '';
    final whyKidsLove = widget.whyKidsLoveThis[currentLocale] ??
        widget.whyKidsLoveThis['en'] ?? '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _expandAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildExpandedContent(context, benefitExplanation, whyKidsLove),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return InkWell(
      onTap: _toggleExpansion,
      borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: ResponsiveUtils.iconSize20,
              ),
            ),
            SizedBox(width: ResponsiveUtils.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why It\'s Good',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Nutritional benefits & why kids love it',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: ResponsiveUtils.iconSize24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    String benefitExplanation,
    String whyKidsLove,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        ResponsiveUtils.spacing16,
        0,
        ResponsiveUtils.spacing16,
        ResponsiveUtils.spacing16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (benefitExplanation.isNotEmpty) ...[
            _buildSubSection(
              context,
              'Nutritional Benefits',
              benefitExplanation,
              Icons.local_dining_outlined,
              AppColors.tertiary,
            ),
            SizedBox(height: ResponsiveUtils.spacing12),
          ],
          if (whyKidsLove.isNotEmpty) ...[
            _buildSubSection(
              context,
              'Why Kids Love This',
              whyKidsLove,
              Icons.favorite_outline,
              AppColors.error,
            ),
          ],
          if (widget.nutritionalInfo.funFacts.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.spacing12),
            _buildFunFactsSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSubSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius6),
          ),
          child: Icon(
            icon,
            color: color,
            size: ResponsiveUtils.iconSize16,
          ),
        ),
        SizedBox(width: ResponsiveUtils.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing4),
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunFactsSection(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final funFact = widget.nutritionalInfo.funFacts[currentLocale] ??
        widget.nutritionalInfo.funFacts['en'] ?? '';

    if (funFact.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.emoji_objects_outlined,
            color: AppColors.secondary,
            size: ResponsiveUtils.iconSize20,
          ),
          SizedBox(width: ResponsiveUtils.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fun Fact',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing2),
                Text(
                  funFact,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}