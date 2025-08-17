import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets.dart/back_arrow.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../application/recipe_detail_controller.dart';
import '../../domain/baby_stage.dart';
import '../../domain/ingredient.dart';
import '../../domain/instruction.dart';
import '../../domain/recipe.dart';
import '../widgets/widgets.dart';

/// Recipe detail screen with hero section and comprehensive recipe information
class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recipeDetailControllerProvider(recipeId));

    if (state.isLoading && state.recipe == null) {
      return const Scaffold(body: LoadingIndicator());
    }

    if (state.error != null && state.recipe == null) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackArrow(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: ResponsiveUtils.iconSize64,
                color: AppColors.error,
              ),
              SizedBox(height: ResponsiveUtils.spacing16),
              Text(
                'Recipe not found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing8),
              Text(
                state.error!.errorCode,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final recipe = state.recipe!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section with image, video support, and basic info
          _RecipeHeroSection(
            recipe: recipe,
            selectedStage: state.selectedStage,
          ),

          // Nutritional snapshot section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.spacing16),
              child: NutritionalSnapshotWidget(
                nutritionalInfo: recipe.nutritionalInfo,
              ),
            ),
          ),

          // Ingredients section
          _IngredientsSection(recipe: recipe),

          // Instructions section
          _InstructionsSection(recipe: recipe),

          // Stage variations section
          if (state.hasStageVariations)
            _StageVariationsSection(
              recipe: recipe,
              selectedStage: state.selectedStage,
              availableStages: state.recipe?.supportedStages ?? [],
              onStageChanged: (stage) {
                ref
                    .read(recipeDetailControllerProvider(recipeId).notifier)
                    .setSelectedStage(stage);
              },
            ),

          // Personal notes section
          _PersonalNotesSection(recipeId: recipeId),

          // Storage and leftover information
          _StorageInfoSection(recipe: recipe),

          // Troubleshooting section
          _TroubleshootingSection(recipe: recipe),
        ],
      ),
    );
  }
}

/// Hero section widget with full-screen image/video support and recipe info
class _RecipeHeroSection extends ConsumerWidget {
  const _RecipeHeroSection({required this.recipe, required this.selectedStage});

  final Recipe recipe;
  final BabyStage selectedStage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return SliverAppBar(
      expandedHeight: ResponsiveUtils.height320,
      floating: false,
      pinned: true,
      leading: Container(
        margin: EdgeInsets.all(ResponsiveUtils.spacing8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const BackArrow(color: Colors.white),
      ),
      backgroundColor: AppColors.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Recipe image with fallback
            _RecipeImage(imageUrl: recipe.imageUrl, videoUrl: recipe.videoUrl),

            // Gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),

            // Recipe info overlay
            Positioned(
              bottom: ResponsiveUtils.spacing16,
              left: ResponsiveUtils.spacing16,
              right: ResponsiveUtils.spacing16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stage badge
                  StageBadge(stage: selectedStage, size: StageBadgeSize.medium),

                  SizedBox(height: ResponsiveUtils.spacing8),

                  // Recipe name
                  Text(
                    recipe.getLocalizedName(languageCode),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.spacing8),

                  // Quick info row
                  _QuickInfoRow(recipe: recipe),

                  SizedBox(height: ResponsiveUtils.spacing8),

                  // Parent rating
                  _ParentRatingDisplay(rating: recipe.parentRating),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recipe image widget with video support and loading states
class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.imageUrl, this.videoUrl});

  final String imageUrl;
  final String? videoUrl;

  @override
  Widget build(BuildContext context) {
    // For now, we'll just show the image
    // Video support can be added later with video_player package
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          color: AppColors.neutralLight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingIndicator(),
                SizedBox(height: ResponsiveUtils.spacing8),
                Text(
                  'Loading recipe image...',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.neutralLight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: ResponsiveUtils.iconSize64,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: ResponsiveUtils.spacing8),
              Text(
                'Image not available',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (videoUrl != null) ...[
                SizedBox(height: ResponsiveUtils.spacing4),
                Icon(
                  Icons.play_circle_outline,
                  size: ResponsiveUtils.iconSize32,
                  color: AppColors.primary,
                ),
                Text(
                  'Video available',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Quick info row showing prep time, cook time, and servings
class _QuickInfoRow extends StatelessWidget {
  const _QuickInfoRow({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoChip(
          icon: Icons.schedule,
          label: '${recipe.prepTimeMinutes}m prep',
        ),
        SizedBox(width: ResponsiveUtils.spacing8),
        _InfoChip(icon: Icons.timer, label: '${recipe.cookTimeMinutes}m cook'),
        SizedBox(width: ResponsiveUtils.spacing8),
        _InfoChip(icon: Icons.restaurant, label: '${recipe.servings} servings'),
      ],
    );
  }
}

/// Individual info chip for quick recipe information
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing8,
        vertical: ResponsiveUtils.spacing4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.iconSize16,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: ResponsiveUtils.spacing4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Parent rating display with star visualization
class _ParentRatingDisplay extends StatelessWidget {
  const _ParentRatingDisplay({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.spacing8,
            vertical: ResponsiveUtils.spacing4,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StarRating(rating: rating),
              SizedBox(width: ResponsiveUtils.spacing4),
              Text(
                rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Star rating widget with partial star support
class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;

        if (rating >= starValue) {
          // Full star
          return Icon(
            Icons.star,
            size: ResponsiveUtils.iconSize16,
            color: AppColors.secondary,
          );
        } else if (rating >= starValue - 0.5) {
          // Half star
          return Icon(
            Icons.star_half,
            size: ResponsiveUtils.iconSize16,
            color: AppColors.secondary,
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            size: ResponsiveUtils.iconSize16,
            color: AppColors.textSecondary,
          );
        }
      }),
    );
  }
}

/// Ingredients section with category grouping and substitution tips
class _IngredientsSection extends ConsumerWidget {
  const _IngredientsSection({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final ingredients = recipe.getLocalizedIngredients(languageCode);

    if (ingredients.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // Group ingredients by category
    final groupedIngredients = <String, List<Ingredient>>{};
    for (final ingredient in ingredients) {
      final category = ingredient.category ?? 'Other';
      groupedIngredients.putIfAbsent(category, () => []).add(ingredient);
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with measurement unit toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ingredients',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                _MeasurementUnitToggle(),
              ],
            ),

            SizedBox(height: ResponsiveUtils.spacing16),

            // Add to shopping list button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement add to shopping list functionality
                },
                icon: Icon(Icons.shopping_cart_outlined),
                label: Text('Add All to Shopping List'),
              ),
            ),

            SizedBox(height: ResponsiveUtils.spacing16),

            // Grouped ingredients
            ...groupedIngredients.entries.map((entry) {
              return _IngredientCategorySection(
                category: entry.key,
                ingredients: entry.value,
                languageCode: languageCode,
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Measurement unit toggle widget
class _MeasurementUnitToggle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, we'll just show a static toggle
    // In a full implementation, this would be connected to a provider
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitToggleButton(
            label: 'Metric',
            isSelected: true,
            onTap: () {
              // TODO: Implement unit toggle
            },
          ),
          _UnitToggleButton(
            label: 'Imperial',
            isSelected: false,
            onTap: () {
              // TODO: Implement unit toggle
            },
          ),
        ],
      ),
    );
  }
}

/// Individual unit toggle button
class _UnitToggleButton extends StatelessWidget {
  const _UnitToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing12,
          vertical: ResponsiveUtils.spacing6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Ingredient category section
class _IngredientCategorySection extends StatelessWidget {
  const _IngredientCategorySection({
    required this.category,
    required this.ingredients,
    required this.languageCode,
  });

  final String category;
  final List<Ingredient> ingredients;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing8),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Ingredients in this category
        ...ingredients.map((ingredient) {
          return _IngredientItem(
            ingredient: ingredient,
            languageCode: languageCode,
          );
        }),

        SizedBox(height: ResponsiveUtils.spacing16),
      ],
    );
  }
}

/// Individual ingredient item with substitution tips
class _IngredientItem extends StatefulWidget {
  const _IngredientItem({required this.ingredient, required this.languageCode});

  final Ingredient ingredient;
  final String languageCode;

  @override
  State<_IngredientItem> createState() => _IngredientItemState();
}

class _IngredientItemState extends State<_IngredientItem> {
  bool _showSubstitution = false;

  @override
  Widget build(BuildContext context) {
    final hasSubstitution = widget.ingredient.substitutionTips.isNotEmpty;
    final substitutionTip =
        widget.ingredient.substitutionTips[widget.languageCode] ??
        widget.ingredient.substitutionTips['en'] ??
        '';

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main ingredient row
          Row(
            children: [
              // Amount and unit
              SizedBox(
                width: ResponsiveUtils.spacing80,
                child: Text(
                  '${widget.ingredient.amount} ${widget.ingredient.unit}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),

              // Ingredient name
              Expanded(
                child: Text(
                  widget.ingredient.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

              // Substitution tip button
              if (hasSubstitution)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showSubstitution = !_showSubstitution;
                    });
                  },
                  icon: Icon(
                    _showSubstitution ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                    size: ResponsiveUtils.iconSize20,
                  ),
                ),
            ],
          ),

          // Substitution tip (expandable)
          if (_showSubstitution && substitutionTip.isNotEmpty)
            Container(
              margin: EdgeInsets.only(
                left: ResponsiveUtils.spacing80,
                top: ResponsiveUtils.spacing4,
              ),
              padding: EdgeInsets.all(ResponsiveUtils.spacing12),
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: ResponsiveUtils.iconSize16,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: ResponsiveUtils.spacing8),
                  Expanded(
                    child: Text(
                      substitutionTip,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Instructions section with step-by-step layout
class _InstructionsSection extends ConsumerWidget {
  const _InstructionsSection({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final instructions = recipe.getLocalizedInstructions(languageCode);

    if (instructions.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Text(
              'Instructions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: ResponsiveUtils.spacing16),

            // Instructions list
            ...instructions.map((instruction) {
              return _InstructionStep(
                instruction: instruction,
                isLast: instruction == instructions.last,
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Individual instruction step
class _InstructionStep extends StatelessWidget {
  const _InstructionStep({required this.instruction, required this.isLast});

  final Instruction instruction;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : ResponsiveUtils.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number with cooking action icon
          Container(
            width: ResponsiveUtils.spacing48,
            height: ResponsiveUtils.spacing48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                // Step number
                Center(
                  child: Text(
                    '${instruction.stepNumber}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Cooking action icon (if available)
                if (instruction.cookingActionIcon != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: ResponsiveUtils.spacing16,
                      height: ResponsiveUtils.spacing16,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getCookingActionIcon(instruction.cookingActionIcon!),
                        size: ResponsiveUtils.iconSize10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: ResponsiveUtils.spacing12),

          // Instruction content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main instruction
                Text(
                  instruction.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                // Estimated time
                if (instruction.estimatedTimeMinutes != null)
                  Padding(
                    padding: EdgeInsets.only(top: ResponsiveUtils.spacing4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: ResponsiveUtils.iconSize14,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: ResponsiveUtils.spacing4),
                        Text(
                          '~${instruction.estimatedTimeMinutes} min',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                // Baby-specific note
                if (instruction.babySpecificNote != null)
                  Container(
                    margin: EdgeInsets.only(top: ResponsiveUtils.spacing8),
                    padding: EdgeInsets.all(ResponsiveUtils.spacing12),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius8,
                      ),
                      border: Border.all(
                        color: AppColors.tertiary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.child_care,
                          size: ResponsiveUtils.iconSize16,
                          color: AppColors.tertiary,
                        ),
                        SizedBox(width: ResponsiveUtils.spacing8),
                        Expanded(
                          child: Text(
                            instruction.babySpecificNote!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCookingActionIcon(String iconName) {
    // Map cooking action icon names to actual icons
    switch (iconName.toLowerCase()) {
      case 'mix':
      case 'stir':
        return Icons.rotate_right;
      case 'heat':
      case 'cook':
        return Icons.local_fire_department;
      case 'chop':
      case 'cut':
        return Icons.content_cut;
      case 'blend':
        return Icons.sports_bar; // Using sports_bar as blender alternative
      case 'boil':
        return Icons.water_drop;
      case 'bake':
        return Icons.microwave; // Using microwave as oven alternative
      case 'cool':
        return Icons.ac_unit;
      case 'serve':
        return Icons.restaurant;
      default:
        return Icons
            .restaurant_menu; // Using restaurant_menu as cooking alternative
    }
  }
}

/// Stage variations section with tabs for different texture variations
class _StageVariationsSection extends StatelessWidget {
  const _StageVariationsSection({
    required this.recipe,
    required this.selectedStage,
    required this.availableStages,
    required this.onStageChanged,
  });

  final Recipe recipe;
  final BabyStage selectedStage;
  final List<BabyStage> availableStages;
  final ValueChanged<BabyStage> onStageChanged;

  @override
  Widget build(BuildContext context) {
    if (availableStages.length <= 1) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stage Variations',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: ResponsiveUtils.spacing12),

            Text(
              'This recipe can be adapted for different developmental stages:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),

            SizedBox(height: ResponsiveUtils.spacing16),

            // Stage tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableStages.map((stage) {
                  final isSelected = stage == selectedStage;
                  return Padding(
                    padding: EdgeInsets.only(right: ResponsiveUtils.spacing8),
                    child: _StageTab(
                      stage: stage,
                      isSelected: isSelected,
                      onTap: () => onStageChanged(stage),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: ResponsiveUtils.spacing16),

            // Stage-specific guidance
            _StageGuidanceCard(stage: selectedStage, recipe: recipe),
          ],
        ),
      ),
    );
  }
}

/// Individual stage tab
class _StageTab extends StatelessWidget {
  const _StageTab({
    required this.stage,
    required this.isSelected,
    required this.onTap,
  });

  final BabyStage stage;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing16,
          vertical: ResponsiveUtils.spacing12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          _getStageDisplayName(stage),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getStageDisplayName(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return 'Stage 1\n4-6 months';
      case BabyStage.stage2:
        return 'Stage 2\n6-8 months';
      case BabyStage.stage3:
        return 'Stage 3\n8-12 months';
      case BabyStage.toddler:
        return 'Toddler\n12-24 months';
    }
  }
}

/// Stage-specific guidance card
class _StageGuidanceCard extends StatelessWidget {
  const _StageGuidanceCard({required this.stage, required this.recipe});

  final BabyStage stage;
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStageIcon(stage),
                color: AppColors.primary,
                size: ResponsiveUtils.iconSize20,
              ),
              SizedBox(width: ResponsiveUtils.spacing8),
              Text(
                _getStageTitle(stage),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveUtils.spacing12),

          Text(
            _getStageGuidance(stage),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  IconData _getStageIcon(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return Icons.water_drop;
      case BabyStage.stage2:
        return Icons
            .restaurant_menu; // Using restaurant_menu as rice_bowl alternative
      case BabyStage.stage3:
        return Icons.restaurant;
      case BabyStage.toddler:
        return Icons.child_care;
    }
  }

  String _getStageTitle(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return 'Smooth Puree';
      case BabyStage.stage2:
        return 'Mashed Texture';
      case BabyStage.stage3:
        return 'Finger Foods';
      case BabyStage.toddler:
        return 'Family Foods';
    }
  }

  String _getStageGuidance(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return 'Blend all ingredients until completely smooth. No lumps should remain. Serve at room temperature or slightly warm.';
      case BabyStage.stage2:
        return 'Mash ingredients with a fork, leaving some small, soft lumps for texture. Baby should be able to mash with their gums.';
      case BabyStage.stage3:
        return 'Cut into small, soft pieces that baby can pick up with their fingers. Pieces should be about the size of baby\'s thumb.';
      case BabyStage.toddler:
        return 'Serve in age-appropriate portions. Can be the same as family meals with minor modifications for safety.';
    }
  }
}

/// Personal notes section with text input and save functionality
class _PersonalNotesSection extends ConsumerStatefulWidget {
  const _PersonalNotesSection({required this.recipeId});

  final String recipeId;

  @override
  ConsumerState<_PersonalNotesSection> createState() =>
      _PersonalNotesSectionState();
}

class _PersonalNotesSectionState extends ConsumerState<_PersonalNotesSection> {
  late TextEditingController _notesController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // In a real implementation, we would get the user's notes from a provider
    // For now, we'll just show the UI structure

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Notes',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (!_isEditing)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: Icon(Icons.edit_outlined),
                    label: Text('Edit'),
                  ),
              ],
            ),

            SizedBox(height: ResponsiveUtils.spacing12),

            if (_isEditing) ...[
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Add your personal notes, tweaks, or observations about this recipe...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.radius12,
                    ),
                  ),
                ),
              ),

              SizedBox(height: ResponsiveUtils.spacing12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _notesController.clear();
                        });
                      },
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.spacing12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving ? null : _saveNotes,
                      child: _isSaving
                          ? SizedBox(
                              width: ResponsiveUtils.spacing16,
                              height: ResponsiveUtils.spacing16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('Save'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveUtils.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _notesController.text.isEmpty
                      ? 'No notes yet. Tap Edit to add your personal tweaks and observations.'
                      : _notesController.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _notesController.text.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontStyle: _notesController.text.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveNotes() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // TODO: Implement saving notes to user recipe data
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notes saved successfully'),
            backgroundColor: AppColors.tertiary,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save notes'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

/// Storage and leftover information section
class _StorageInfoSection extends StatelessWidget {
  const _StorageInfoSection({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final storageInfo = recipe.getLocalizedStorageInfo(languageCode);

    if (storageInfo.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storage & Leftovers',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: ResponsiveUtils.spacing16),

            Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveUtils.spacing8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius8,
                          ),
                        ),
                        child: Icon(
                          Icons
                              .home_outlined, // Using home as kitchen alternative
                          color: AppColors.secondary,
                          size: ResponsiveUtils.iconSize20,
                        ),
                      ),
                      SizedBox(width: ResponsiveUtils.spacing12),
                      Expanded(
                        child: Text(
                          storageInfo,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveUtils.spacing12),

                  // Additional storage tips
                  Container(
                    padding: EdgeInsets.all(ResponsiveUtils.spacing12),
                    decoration: BoxDecoration(
                      color: AppColors.neutralLight,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.radius8,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: ResponsiveUtils.iconSize16,
                          color: AppColors.secondary,
                        ),
                        SizedBox(width: ResponsiveUtils.spacing8),
                        Expanded(
                          child: Text(
                            'Always check temperature before serving reheated food to baby. Stir well to avoid hot spots.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Troubleshooting section with expandable tips
class _TroubleshootingSection extends StatefulWidget {
  const _TroubleshootingSection({required this.recipe});

  final Recipe recipe;

  @override
  State<_TroubleshootingSection> createState() =>
      _TroubleshootingSectionState();
}

class _TroubleshootingSectionState extends State<_TroubleshootingSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final troubleshootingTips = widget.recipe.getLocalizedTroubleshooting(
      languageCode,
    );

    if (troubleshootingTips.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Troubleshooting Tips',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            if (_isExpanded) ...[
              SizedBox(height: ResponsiveUtils.spacing16),

              Container(
                padding: EdgeInsets.all(ResponsiveUtils.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: AppColors.error,
                          size: ResponsiveUtils.iconSize20,
                        ),
                        SizedBox(width: ResponsiveUtils.spacing8),
                        Text(
                          'Common Issues & Solutions',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveUtils.spacing12),

                    ...troubleshootingTips.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tip = entry.value;

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == troubleshootingTips.length - 1
                              ? 0
                              : ResponsiveUtils.spacing8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: ResponsiveUtils.spacing6,
                              height: ResponsiveUtils.spacing6,
                              margin: EdgeInsets.only(
                                top: ResponsiveUtils.spacing8,
                                right: ResponsiveUtils.spacing8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tip,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
