import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/firebase_recipe_repository.dart';
import '../domain/recipe.dart';
import '../domain/baby_stage.dart';
import '../domain/category.dart';
import 'user_recipe_controller.dart';
import '../../auth/data/firebase_auth_repository.dart';

part 'recipe_recommendation_service.g.dart';

/// Service for generating recipe recommendations based on user history and baby stage
@riverpod
class RecipeRecommendationService extends _$RecipeRecommendationService {
  @override
  Future<List<Recipe>> build() async {
    return [];
  }

  /// Get recommended recipes for a user based on their baby's stage and history
  Future<List<Recipe>> getRecommendedRecipes({
    required BabyStage babyStage,
    int limit = 10,
    String? excludeRecipeId,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return [];

    try {
      final repository = ref.read(recipeRepositoryProvider);
      final userRecipeController = ref.read(userRecipeControllerProvider);

      // Get user's recipe history
      final favoriteRecipeIds = userRecipeController.favoriteRecipeIds;
      final triedRecipeIds = userRecipeController.triedRecipeIds;
      final userRecipeData = userRecipeController.userRecipeData;

      // Get all recipes for the baby's stage
      final stageRecipes = await repository.getRecipesByStage();

      // Filter out the current recipe if specified
      final availableRecipes = stageRecipes
          .where((recipe) => recipe.id != excludeRecipeId)
          .toList();

      // Apply recommendation algorithm
      final recommendations = _generateRecommendations(
        availableRecipes: availableRecipes,
        favoriteRecipeIds: favoriteRecipeIds,
        triedRecipeIds: triedRecipeIds,
        userRecipeData: userRecipeData,
        babyStage: babyStage,
        limit: limit,
      );

      state = AsyncValue.data(recommendations);
      return recommendations;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  /// Get next suggested recipe based on current recipe
  Future<Recipe?> getNextSuggestedRecipe(String currentRecipeId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return null;

    try {
      final repository = ref.read(recipeRepositoryProvider);
      final currentRecipe = await repository.getRecipeById(currentRecipeId);
      
      if (currentRecipe == null) return null;

      // Get recommendations for the same stage as current recipe
      final primaryStage = currentRecipe.supportedStages.first;
      final recommendations = await getRecommendedRecipes(
        babyStage: primaryStage,
        limit: 1,
        excludeRecipeId: currentRecipeId,
      );

      return recommendations.isNotEmpty ? recommendations.first : null;
    } catch (e) {
      return null;
    }
  }

  /// Get related recipes based on category and stage
  Future<List<Recipe>> getRelatedRecipes({
    required String recipeId,
    int limit = 5,
  }) async {
    try {
      final repository = ref.read(recipeRepositoryProvider);
      final currentRecipe = await repository.getRecipeById(recipeId);
      
      if (currentRecipe == null) return [];

      // Get recipes from the same category
      final categoryRecipes = await repository.getRecipesByCategory(
        currentRecipe.category,
      );

      // Filter out current recipe and apply similarity scoring
      final relatedRecipes = categoryRecipes
          .where((recipe) => recipe.id != recipeId)
          .toList();

      // Sort by similarity to current recipe
      relatedRecipes.sort((a, b) => _calculateSimilarityScore(currentRecipe, b)
          .compareTo(_calculateSimilarityScore(currentRecipe, a)));

      return relatedRecipes.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  /// Generate personalized recommendations using multiple factors
  List<Recipe> _generateRecommendations({
    required List<Recipe> availableRecipes,
    required List<String> favoriteRecipeIds,
    required List<String> triedRecipeIds,
    required Map<String, dynamic> userRecipeData,
    required BabyStage babyStage,
    required int limit,
  }) {
    // Score each recipe based on multiple factors
    final scoredRecipes = availableRecipes.map((recipe) {
      double score = 0.0;

      // Base score from recipe rating
      score += recipe.parentRating * 10;

      // Boost score for recipes in favorite categories
      score += _getCategoryPreferenceScore(
        recipe.category,
        favoriteRecipeIds,
        availableRecipes,
      );

      // Boost score for recipes with similar nutritional benefits
      score += _getNutritionalSimilarityScore(
        recipe,
        favoriteRecipeIds,
        availableRecipes,
      );

      // Boost score for untried recipes
      if (!triedRecipeIds.contains(recipe.id)) {
        score += 20;
      }

      // Boost score for recipes that match baby's developmental needs
      score += _getDevelopmentalScore(recipe, babyStage);

      // Reduce score for recipes viewed many times but not favorited
      final userData = userRecipeData[recipe.id];
      if (userData != null) {
        final viewCount = userData['viewCount'] ?? 0;
        final isFavorite = favoriteRecipeIds.contains(recipe.id);
        
        if (viewCount > 3 && !isFavorite) {
          score -= 10; // User has seen it but didn't favorite it
        }
      }

      // Add some randomness to avoid always showing the same recipes
      score += (DateTime.now().millisecondsSinceEpoch % 100) / 10.0;

      return MapEntry(recipe, score);
    }).toList();

    // Sort by score and return top recommendations
    scoredRecipes.sort((a, b) => b.value.compareTo(a.value));
    
    return scoredRecipes
        .take(limit)
        .map((entry) => entry.key)
        .toList();
  }

  /// Calculate preference score based on favorite categories
  double _getCategoryPreferenceScore(
    Category recipeCategory,
    List<String> favoriteRecipeIds,
    List<Recipe> allRecipes,
  ) {
    if (favoriteRecipeIds.isEmpty) return 0.0;

    // Count favorites in each category
    final categoryCount = <Category, int>{};
    for (final recipeId in favoriteRecipeIds) {
      final recipe = allRecipes.firstWhere(
        (r) => r.id == recipeId,
        orElse: () => allRecipes.first,
      );
      categoryCount[recipe.category] = (categoryCount[recipe.category] ?? 0) + 1;
    }

    // Return score based on category preference
    final categoryFavorites = categoryCount[recipeCategory] ?? 0;
    return categoryFavorites * 15.0; // 15 points per favorite in this category
  }

  /// Calculate nutritional similarity score
  double _getNutritionalSimilarityScore(
    Recipe recipe,
    List<String> favoriteRecipeIds,
    List<Recipe> allRecipes,
  ) {
    if (favoriteRecipeIds.isEmpty) return 0.0;

    double totalSimilarity = 0.0;
    int count = 0;

    for (final favoriteId in favoriteRecipeIds) {
      final favoriteRecipe = allRecipes.firstWhere(
        (r) => r.id == favoriteId,
        orElse: () => allRecipes.first,
      );

      // Compare development benefits
      final commonBenefits = recipe.nutritionalInfo.developmentBenefits
          .where((benefit) => favoriteRecipe.nutritionalInfo.developmentBenefits
              .contains(benefit))
          .length;

      totalSimilarity += commonBenefits * 5.0; // 5 points per common benefit
      count++;
    }

    return count > 0 ? totalSimilarity / count : 0.0;
  }

  /// Calculate developmental appropriateness score
  double _getDevelopmentalScore(Recipe recipe, BabyStage babyStage) {
    double score = 0.0;

    // Boost score if recipe supports the current stage
    if (recipe.supportedStages.contains(babyStage)) {
      score += 25.0;
    }

    // Additional boost if recipe supports progression to next stage
    final nextStage = _getNextStage(babyStage);
    if (nextStage != null && recipe.supportedStages.contains(nextStage)) {
      score += 10.0;
    }

    return score;
  }

  /// Calculate similarity score between two recipes
  double _calculateSimilarityScore(Recipe recipe1, Recipe recipe2) {
    double score = 0.0;

    // Same category
    if (recipe1.category == recipe2.category) {
      score += 30.0;
    }

    // Similar stages
    final commonStages = recipe1.supportedStages
        .where((stage) => recipe2.supportedStages.contains(stage))
        .length;
    score += commonStages * 10.0;

    // Similar development benefits
    final commonBenefits = recipe1.nutritionalInfo.developmentBenefits
        .where((benefit) => recipe2.nutritionalInfo.developmentBenefits
            .contains(benefit))
        .length;
    score += commonBenefits * 5.0;

    // Similar prep time
    final timeDifference = (recipe1.prepTimeMinutes - recipe2.prepTimeMinutes).abs();
    if (timeDifference <= 5) {
      score += 10.0;
    } else if (timeDifference <= 10) {
      score += 5.0;
    }

    return score;
  }

  /// Get the next developmental stage
  BabyStage? _getNextStage(BabyStage currentStage) {
    switch (currentStage) {
      case BabyStage.stage1:
        return BabyStage.stage2;
      case BabyStage.stage2:
        return BabyStage.stage3;
      case BabyStage.stage3:
        return BabyStage.toddler;
      case BabyStage.toddler:
        return null; // No next stage
    }
  }

  /// Clear cached recommendations
  void clearCache() {
    state = const AsyncValue.data([]);
  }

  /// Refresh recommendations
  Future<void> refreshRecommendations(BabyStage babyStage) async {
    await getRecommendedRecipes(babyStage: babyStage);
  }
}