import '../domain/baby_stage.dart';
import '../domain/category.dart';
import '../domain/recipe.dart';

/// Abstract repository interface for recipe operations
abstract class RecipeRepository {
  /// Get recipes by category with optional language support
  Future<List<Recipe>> getRecipesByCategory(
    Category category, {
    String? language,
  });

  /// Get recipes by baby stage with optional language support
  Future<List<Recipe>> getRecipesByStage({String? language});

  /// Get recipes by both category and stage with optional language support
  Future<List<Recipe>> getRecipesByCategoryAndStage(
    Category category, {
    String? language,
  });

  /// Get a specific recipe by ID with optional language support
  Future<Recipe?> getRecipeById(String id, {String? language});

  /// Search recipes by query with optional language support
  Future<List<Recipe>> searchRecipes(String query, {String? language});

  /// Get recommended recipes for a user with optional language support
  Future<List<Recipe>> getRecommendedRecipes(String userId, {String? language});

  /// Watch recipes by category (real-time updates)
  Stream<List<Recipe>> watchRecipesByCategory(Category category, BabyStage stage);

  /// Watch recipes by stage (real-time updates)
  Stream<List<Recipe>> watchRecipesByStage(BabyStage stage);

  /// Watch a specific recipe by ID (real-time updates)
  Stream<Recipe?> watchRecipeById(String id);
}
