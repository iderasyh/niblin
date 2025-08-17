import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/user_recipe_controller.dart';

/// A button that allows users to mark recipes as tried with progress tracking
class TriedButton extends ConsumerStatefulWidget {
  const TriedButton({
    super.key,
    required this.recipeId,
    this.size,
    this.backgroundColor,
  });

  final String recipeId;
  final double? size;
  final Color? backgroundColor;

  @override
  ConsumerState<TriedButton> createState() => _TriedButtonState();
}

class _TriedButtonState extends ConsumerState<TriedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.15,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRecipeController = ref.watch(userRecipeControllerProvider);
    final hasTried = userRecipeController.hasTried(widget.recipeId);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Container(
              width: widget.size ?? ResponsiveUtils.iconSize32,
              height: widget.size ?? ResponsiveUtils.iconSize32,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _isLoading ? null : (hasTried ? null : _markAsTried),
                icon: _isLoading
                    ? SizedBox(
                        width: (widget.size ?? ResponsiveUtils.iconSize32) * 0.4,
                        height: (widget.size ?? ResponsiveUtils.iconSize32) * 0.4,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.tertiary,
                        ),
                      )
                    : Icon(
                        hasTried ? Icons.check_circle : Icons.check_circle_outline,
                        color: hasTried ? AppColors.tertiary : AppColors.textSecondary,
                        size: (widget.size ?? ResponsiveUtils.iconSize32) * 0.6,
                      ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _markAsTried() async {
    // Trigger celebration animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    setState(() {
      _isLoading = true;
    });

    try {
      final userRecipeController = ref.read(userRecipeControllerProvider.notifier);
      await userRecipeController.markAsTried(widget.recipeId);

      if (mounted) {
        // Show celebration feedback
        _showTriedCelebration();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                  size: ResponsiveUtils.iconSize20,
                ),
                SizedBox(width: ResponsiveUtils.spacing8),
                Text(
                  'Failed to mark as tried',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showTriedCelebration() {
    final userRecipeController = ref.read(userRecipeControllerProvider.notifier);
    final stats = userRecipeController.getProgressStats();
    final totalTried = stats['totalTried'] ?? 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.celebration,
              color: Colors.white,
              size: ResponsiveUtils.iconSize24,
            ),
            SizedBox(width: ResponsiveUtils.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Great job! Recipe marked as tried!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (totalTried > 1)
                    Text(
                      'You\'ve now tried $totalTried recipes! 🎉',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.tertiary,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        ),
      ),
    );

    // Show milestone celebrations
    _checkForMilestones(totalTried);
  }

  void _checkForMilestones(int totalTried) {
    final milestones = [1, 5, 10, 25, 50, 100];
    
    if (milestones.contains(totalTried)) {
      // Delay the milestone celebration slightly
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _showMilestoneCelebration(totalTried);
        }
      });
    }
  }

  void _showMilestoneCelebration(int milestone) {
    String message;
    IconData icon;

    switch (milestone) {
      case 1:
        message = 'First recipe tried! Welcome to your feeding journey! 🌟';
        icon = Icons.star;
        break;
      case 5:
        message = '5 recipes tried! You\'re building great habits! 🚀';
        icon = Icons.rocket_launch;
        break;
      case 10:
        message = '10 recipes tried! You\'re becoming a baby food expert! 👨‍🍳';
        icon = Icons.restaurant_menu;
        break;
      case 25:
        message = '25 recipes tried! Amazing dedication to variety! 🏆';
        icon = Icons.emoji_events;
        break;
      case 50:
        message = '50 recipes tried! You\'re a feeding superstar! ⭐';
        icon = Icons.star_rate;
        break;
      case 100:
        message = '100 recipes tried! Incredible milestone achieved! 🎊';
        icon = Icons.celebration;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveUtils.spacing64,
              height: ResponsiveUtils.spacing64,
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: ResponsiveUtils.iconSize32,
                color: AppColors.tertiary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing16),
            Text(
              'Milestone Reached!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.spacing8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.spacing24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.tertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}