import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/cache_service.dart';
import '../data/firebase_recipe_repository.dart';
import '../domain/baby_stage.dart';
import '../domain/recipe.dart';
import '../domain/recipe_error.dart';
import 'recipe_error_recovery.dart';

part 'recipe_detail_controller.g.dart';

/// State class for recipe detail with stage variations
class RecipeDetailState {
  final Recipe? recipe;
  final bool isLoading;
  final RecipeError? error;
  final BabyStage selectedStage;
  final List<Recipe> recommendations;
  final bool isLoadingRecommendations;
  final bool isUsingCachedData;
  final bool hasIncompleteContent;

  const RecipeDetailState({
    this.recipe,
    this.isLoading = false,
    this.error,
    this.selectedStage = BabyStage.stage1,
    this.recommendations = const [],
    this.isLoadingRecommendations = false,
    this.isUsingCachedData = false,
    this.hasIncompleteContent = false,
  });

  RecipeDetailState copyWith({
    Recipe? recipe,
    bool? isLoading,
    RecipeError? error,
    BabyStage? selectedStage,
    List<Recipe>? recommendations,
    bool? isLoadingRecommendations,
    bool? isUsingCachedData,
    bool? hasIncompleteContent,
  }) {
    return RecipeDetailState(
      recipe: recipe ?? this.recipe,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedStage: selectedStage ?? this.selectedStage,
      recommendations: recommendations ?? this.recommendations,
      isLoadingRecommendations: isLoadingRecommendations ?? this.isLoadingRecommendations,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
      hasIncompleteContent: hasIncompleteContent ?? this.hasIncompleteContent,
    );
  }

  /// Get the current recipe adapted for the selected stage
  Recipe? get adaptedRecipe {
    if (recipe == null) return null;
    
    // If the recipe doesn't support the selected stage, return the original
    if (!recipe!.supportedStages.contains(selectedStage)) {
      return recipe;
    }
    
    // For now, return the original recipe
    // In a full implementation, this would adapt ingredients and instructions
    // based on the selected stage (puree vs mashed vs finger food)
    return recipe;
  }

  /// Check if the recipe supports stage variations
  bool get hasStageVariations {
    return (recipe?.supportedStages.length ?? 0) > 1;
  }
}

@riverpod
class RecipeDetailController extends _$RecipeDetailController {
  @override
  RecipeDetailState build(String recipeId) {
    // Auto-load recipe when controller is created
    _loadRecipe(recipeId);
    return const RecipeDetailState();
  }

  /// Load recipe by ID with caching and offline support
  Future<void> _loadRecipe(String recipeId) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true, 
      error: null,
      isUsingCachedData: false,
      hasIncompleteContent: false,
    );

    try {
      final repository = ref.read(recipeRepositoryProvider);

      // Fetch from repository with error recovery
      final recipe = await ref.read(recipeErrorRecoveryProvider).recoverRecipe(
        recipeId,
        const RecipeNetworkError(), // Placeholder for potential error
        () => repository.getRecipeById(recipeId),
      );

      if (recipe != null) {
        // Validate and sanitize recipe content
        try {
          final validatedRecipe = ref.read(recipeErrorRecoveryProvider).validateAndSanitizeRecipe(recipe);
          
          // Cache the validated recipe
          final cacheService = ref.read(cacheServiceProvider.notifier);
          cacheService.setWithSuffix(
            CacheKey.recipeById,
            recipeId,
            validatedRecipe,
          );

          state = state.copyWith(
            recipe: validatedRecipe,
            isLoading: false,
            selectedStage: _getDefaultStage(validatedRecipe),
            isUsingCachedData: false,
            hasIncompleteContent: false,
          );

          // Load recommendations in background
          _loadRecommendations(recipeId);
        } catch (contentError) {
          if (contentError is RecipeContentError) {
            // Recipe has incomplete content, but show what we have
            state = state.copyWith(
              recipe: recipe,
              isLoading: false,
              selectedStage: _getDefaultStage(recipe),
              error: contentError,
              hasIncompleteContent: true,
            );
          } else {
            rethrow;
          }
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: RecipeNotFoundError(recipeId: recipeId),
        );
      }
    } catch (e) {
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: 'loadRecipe',
      );

      // Try to recover with cached data
      final errorRecovery = ref.read(recipeErrorRecoveryProvider);
      
      try {
        final cachedRecipe = await errorRecovery.recoverRecipe(
          recipeId,
          error,
          () => throw error, // Don't retry, just use cache
        );

        if (cachedRecipe != null) {
          state = state.copyWith(
            recipe: cachedRecipe,
            isLoading: false,
            selectedStage: _getDefaultStage(cachedRecipe),
            error: error,
            isUsingCachedData: true,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            error: error,
            isUsingCachedData: false,
          );
        }
      } catch (_) {
        state = state.copyWith(
          isLoading: false,
          error: error,
          isUsingCachedData: false,
        );
      }
    }
  }

  /// Load recommended recipes
  Future<void> _loadRecommendations(String recipeId) async {
    state = state.copyWith(isLoadingRecommendations: true);

    try {
      final repository = ref.read(recipeRepositoryProvider);

      // For now, we'll use a simple recommendation strategy
      // In a full implementation, this would be more sophisticated
      final recommendations = await _getSimpleRecommendations(repository);

      state = state.copyWith(
        recommendations: recommendations,
        isLoadingRecommendations: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingRecommendations: false,
        recommendations: [],
      );
    }
  }

  /// Simple recommendation strategy based on category and stage
  Future<List<Recipe>> _getSimpleRecommendations(
    FirebaseRecipeRepository repository,
  ) async {
    if (state.recipe == null) return [];

    try {
      // Get recipes from the same category
      final categoryRecipes = await repository.getRecipesByCategory(
        state.recipe!.category,
      );

      // Filter out the current recipe and limit to 5 recommendations
      final recommendations = categoryRecipes
          .where((r) => r.id != state.recipe!.id)
          .take(5)
          .toList();

      return recommendations;
    } catch (e) {
      return [];
    }
  }

  /// Set the selected stage for recipe adaptation
  void setSelectedStage(BabyStage stage) {
    if (state.recipe == null || !state.recipe!.supportedStages.contains(stage)) {
      return;
    }

    state = state.copyWith(selectedStage: stage);
  }

  /// Refresh recipe data
  Future<void> refresh() async {
    if (state.recipe == null) return;

    // Clear cache
    final cacheService = ref.read(cacheServiceProvider.notifier);
    cacheService.removeWithSuffix(CacheKey.recipeById, state.recipe!.id);

    await _loadRecipe(state.recipe!.id);
  }

  /// Retry loading recipe after error
  Future<void> retryLoadRecipe() async {
    if (state.recipe?.id != null) {
      state = state.copyWith(error: null);
      await _loadRecipe(state.recipe!.id);
    }
  }

  /// Show cached data if available
  void showCachedData() {
    if (state.error?.shouldShowCachedData == true && state.recipe?.id != null) {
      // This will be handled by the error recovery service
      _loadRecipe(state.recipe!.id);
    }
  }

  /// Get fallback recipe for missing content
  Recipe? getFallbackRecipe(String recipeId, String languageCode) {
    if (state.error is RecipeNotFoundError) {
      final errorRecovery = ref.read(recipeErrorRecoveryProvider);
      return errorRecovery.createFallbackRecipe(recipeId, languageCode);
    }
    return null;
  }

  /// Get default stage based on recipe's supported stages
  BabyStage _getDefaultStage(Recipe recipe) {
    if (recipe.supportedStages.isEmpty) return BabyStage.stage1;
    
    // Return the first supported stage
    return recipe.supportedStages.first;
  }

  /// Check if a stage is supported by the current recipe
  bool isStageSupported(BabyStage stage) {
    return state.recipe?.supportedStages.contains(stage) ?? false;
  }

  /// Get available stages for the current recipe
  List<BabyStage> get availableStages {
    return state.recipe?.supportedStages ?? [];
  }
}