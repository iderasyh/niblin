import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/user_recipe_controller.dart';
import '../../application/recipe_detail_controller.dart';

/// A button that allows users to share recipe information with partners/caregivers
class ShareButton extends ConsumerStatefulWidget {
  const ShareButton({
    super.key,
    required this.recipeId,
    this.size,
    this.backgroundColor,
  });

  final String recipeId;
  final double? size;
  final Color? backgroundColor;

  @override
  ConsumerState<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends ConsumerState<ShareButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
              onPressed: _showShareOptions,
              icon: Icon(
                Icons.share_outlined,
                color: AppColors.textSecondary,
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

  void _showShareOptions() async {
    // Trigger press animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveUtils.radius20),
        ),
      ),
      builder: (context) => _ShareOptionsSheet(recipeId: widget.recipeId),
    );
  }
}

/// Bottom sheet with sharing options
class _ShareOptionsSheet extends ConsumerWidget {
  const _ShareOptionsSheet({required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeDetailControllerProvider(recipeId));
    final userRecipeController = ref.watch(userRecipeControllerProvider);
    
    final recipe = recipeState.recipe;
    if (recipe == null) {
      return const SizedBox.shrink();
    }

    final languageCode = Localizations.localeOf(context).languageCode;
    final recipeName = recipe.getLocalizedName(languageCode);

    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: ResponsiveUtils.spacing40,
              height: ResponsiveUtils.spacing4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius2),
              ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing24),

          // Title
          Text(
            'Share Recipe',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing8),

          Text(
            'Share "$recipeName" with your partner or caregiver',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: ResponsiveUtils.spacing24),

          // Share options
          _ShareOption(
            icon: Icons.link,
            title: 'Copy Recipe Link',
            subtitle: 'Share a link to this recipe',
            onTap: () => _copyRecipeLink(context, recipeName),
          ),

          SizedBox(height: ResponsiveUtils.spacing12),

          _ShareOption(
            icon: Icons.note_alt_outlined,
            title: 'Share My Notes',
            subtitle: 'Include your personal notes and progress',
            onTap: () => _shareWithNotes(context, recipe, userRecipeController),
          ),

          SizedBox(height: ResponsiveUtils.spacing12),

          _ShareOption(
            icon: Icons.shopping_cart_outlined,
            title: 'Share Shopping List',
            subtitle: 'Send ingredients list for shopping',
            onTap: () => _shareShoppingList(context, recipe, languageCode),
          ),

          SizedBox(height: ResponsiveUtils.spacing24),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _copyRecipeLink(BuildContext context, String recipeName) {
    // In a real app, this would be a deep link to the recipe
    final recipeLink = 'https://niblin.app/recipes/$recipeId';
    
    Clipboard.setData(ClipboardData(text: recipeLink));
    
    Navigator.of(context).pop();
    
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
              'Recipe link copied to clipboard',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.tertiary,
      ),
    );
  }

  void _shareWithNotes(
    BuildContext context,
    recipe,
    UserRecipeState userRecipeController,
  ) {
    final userData = userRecipeController.getUserRecipeData(recipeId);
    final languageCode = Localizations.localeOf(context).languageCode;
    final recipeName = recipe.getLocalizedName(languageCode);
    
    final shareData = {
      'recipeName': recipeName,
      'recipeId': recipeId,
      'isFavorite': userRecipeController.isFavorite(recipeId),
      'hasTried': userRecipeController.hasTried(recipeId),
      'personalNotes': userData?.personalNotes,
      'triedDate': userData?.triedDate?.toIso8601String(),
      'viewCount': userData?.viewCount ?? 0,
    };

    final shareText = _formatShareText(shareData);
    
    Clipboard.setData(ClipboardData(text: shareText));
    
    Navigator.of(context).pop();
    
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
              'Recipe details copied to clipboard',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.tertiary,
      ),
    );
  }

  void _shareShoppingList(BuildContext context, recipe, String languageCode) {
    final ingredients = recipe.getLocalizedIngredients(languageCode);
    final recipeName = recipe.getLocalizedName(languageCode);
    
    final shoppingList = StringBuffer();
    shoppingList.writeln('Shopping List for: $recipeName');
    shoppingList.writeln('');
    
    // Group ingredients by category
    final groupedIngredients = <String, List>{};
    for (final ingredient in ingredients) {
      final category = ingredient.category ?? 'Other';
      groupedIngredients.putIfAbsent(category, () => []).add(ingredient);
    }
    
    for (final entry in groupedIngredients.entries) {
      shoppingList.writeln('${entry.key}:');
      for (final ingredient in entry.value) {
        shoppingList.writeln('• ${ingredient.amount} ${ingredient.unit} ${ingredient.name}');
      }
      shoppingList.writeln('');
    }
    
    shoppingList.writeln('Generated by Niblin - Baby Feeding App');
    
    Clipboard.setData(ClipboardData(text: shoppingList.toString()));
    
    Navigator.of(context).pop();
    
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
              'Shopping list copied to clipboard',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.tertiary,
      ),
    );
  }

  String _formatShareText(Map<String, dynamic> shareData) {
    final buffer = StringBuffer();
    
    buffer.writeln('Recipe: ${shareData['recipeName']}');
    buffer.writeln('');
    
    if (shareData['isFavorite'] == true) {
      buffer.writeln('⭐ This is one of my favorite recipes!');
    }
    
    if (shareData['hasTried'] == true) {
      buffer.writeln('✅ I\'ve tried this recipe');
      if (shareData['triedDate'] != null) {
        final triedDate = DateTime.parse(shareData['triedDate']);
        buffer.writeln('   Tried on: ${_formatDate(triedDate)}');
      }
    }
    
    if (shareData['personalNotes'] != null && shareData['personalNotes'].toString().isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('My Notes:');
      buffer.writeln(shareData['personalNotes']);
    }
    
    buffer.writeln('');
    buffer.writeln('View this recipe in Niblin: https://niblin.app/recipes/${shareData['recipeId']}');
    
    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Individual share option widget
class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.spacing48,
              height: ResponsiveUtils.spacing48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: ResponsiveUtils.iconSize24,
              ),
            ),
            
            SizedBox(width: ResponsiveUtils.spacing16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.spacing4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveUtils.iconSize16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}