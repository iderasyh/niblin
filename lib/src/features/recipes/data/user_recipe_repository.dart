import '../domain/user_recipe_data.dart';

/// Abstract repository interface for user recipe data operations
abstract class UserRecipeRepository {
  /// Get user recipe data for a specific user and recipe
  Future<UserRecipeData?> getUserRecipeData(String userId, String recipeId);

  /// Update user recipe data
  Future<void> updateUserRecipeData(UserRecipeData data);

  /// Get all favorite recipe IDs for a user
  Future<List<String>> getFavoriteRecipeIds(String userId);

  /// Get all tried recipe IDs for a user
  Future<List<String>> getTriedRecipeIds(String userId);

  /// Get all user recipe data for a user
  Future<List<UserRecipeData>> getAllUserRecipeData(String userId);

  /// Add recipe to meal plan for a specific date
  Future<void> addToMealPlan(String userId, String recipeId, DateTime date);

  /// Remove recipe from meal plan
  Future<void> removeFromMealPlan(String userId, String recipeId);

  /// Get meal plan recipes for a specific date
  Future<List<String>> getMealPlanRecipeIds(String userId, DateTime date);

  /// Get meal plan recipes for a date range
  Future<Map<DateTime, List<String>>> getMealPlanRecipeIdsForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );

  /// Toggle favorite status for a recipe
  Future<void> toggleFavorite(String userId, String recipeId);

  /// Mark recipe as tried
  Future<void> markAsTried(String userId, String recipeId);

  /// Update personal notes for a recipe
  Future<void> updatePersonalNotes(
    String userId,
    String recipeId,
    String? notes,
  );

  /// Increment view count for a recipe
  Future<void> incrementViewCount(String userId, String recipeId);

  /// Watch user recipe data for real-time updates
  Stream<UserRecipeData?> watchUserRecipeData(String userId, String recipeId);

  /// Watch all user recipe data for a user
  Stream<List<UserRecipeData>> watchAllUserRecipeData(String userId);

  /// Watch favorite recipe IDs for a user
  Stream<List<String>> watchFavoriteRecipeIds(String userId);
}