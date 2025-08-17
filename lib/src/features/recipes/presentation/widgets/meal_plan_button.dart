import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/user_recipe_controller.dart';

/// A button that allows users to add recipes to their meal plan with date picker
class MealPlanButton extends ConsumerStatefulWidget {
  const MealPlanButton({
    super.key,
    required this.recipeId,
    this.size,
    this.backgroundColor,
  });

  final String recipeId;
  final double? size;
  final Color? backgroundColor;

  @override
  ConsumerState<MealPlanButton> createState() => _MealPlanButtonState();
}

class _MealPlanButtonState extends ConsumerState<MealPlanButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
    final isInMealPlan = _isRecipeInMealPlan();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
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
              onPressed: _isLoading ? null : _showMealPlanDialog,
              icon: _isLoading
                  ? SizedBox(
                      width: (widget.size ?? ResponsiveUtils.iconSize32) * 0.4,
                      height: (widget.size ?? ResponsiveUtils.iconSize32) * 0.4,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Icon(
                      isInMealPlan ? Icons.event : Icons.event_outlined,
                      color: isInMealPlan ? AppColors.primary : AppColors.textSecondary,
                      size: (widget.size ?? ResponsiveUtils.iconSize32) * 0.6,
                    ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        );
      },
    );
  }

  bool _isRecipeInMealPlan() {
    final userRecipeController = ref.read(userRecipeControllerProvider);
    final now = DateTime.now();
    
    // Check if recipe is in meal plan for the next 7 days
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      if (userRecipeController.isInMealPlan(widget.recipeId, date)) {
        return true;
      }
    }
    return false;
  }

  void _showMealPlanDialog() async {
    // Trigger press animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      await _addToMealPlan(selectedDate);
    }
  }

  Future<void> _addToMealPlan(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userRecipeController = ref.read(userRecipeControllerProvider.notifier);
      await userRecipeController.addToMealPlan(widget.recipeId, date);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: ResponsiveUtils.iconSize20,
                ),
                SizedBox(width: ResponsiveUtils.spacing8),
                Expanded(
                  child: Text(
                    'Added to meal plan for ${_formatDate(date)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.tertiary,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () => _removeFromMealPlan(date),
            ),
          ),
        );
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
                Expanded(
                  child: Text(
                    'Failed to add to meal plan',
                    style: const TextStyle(color: Colors.white),
                  ),
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

  Future<void> _removeFromMealPlan(DateTime date) async {
    try {
      final userRecipeController = ref.read(userRecipeControllerProvider.notifier);
      await userRecipeController.removeFromMealPlan(widget.recipeId, date);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: ResponsiveUtils.iconSize20,
                ),
                SizedBox(width: ResponsiveUtils.spacing8),
                Text(
                  'Removed from meal plan',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.tertiary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove from meal plan'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'today';
    } else if (targetDate == tomorrow) {
      return 'tomorrow';
    } else {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      
      return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
    }
  }
}