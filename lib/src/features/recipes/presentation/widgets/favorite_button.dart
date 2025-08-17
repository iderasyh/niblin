import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/user_recipe_controller.dart';

/// A favorite button with heart animation that toggles recipe favorite status
class FavoriteButton extends ConsumerStatefulWidget {
  const FavoriteButton({
    super.key,
    required this.recipeId,
    this.size,
    this.backgroundColor,
  });

  final String recipeId;
  final double? size;
  final Color? backgroundColor;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
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
    final userRecipeData = userRecipeController.getUserRecipeData(widget.recipeId);
    final isFavorite = userRecipeData?.isFavorite ?? false;

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
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.error : AppColors.textSecondary,
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

  void _toggleFavorite() async {
    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Toggle favorite status
    final userRecipeController = ref.read(userRecipeControllerProvider.notifier);
    await userRecipeController.toggleFavorite(widget.recipeId);
  }
}