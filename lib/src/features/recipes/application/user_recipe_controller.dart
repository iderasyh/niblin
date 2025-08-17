import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/data/firebase_auth_repository.dart';
import '../data/firebase_user_recipe_repository.dart';
import '../domain/recipe_error.dart';
import '../domain/user_recipe_data.dart';
import 'recipe_edge_case_handler.dart';
import 'recipe_validation_service.dart';

part 'user_recipe_controller.g.dart';

/// State class for user recipe interactions
class UserRecipeState {
  final Map<String, UserRecipeData> userRecipeData;
  final List<String> favoriteRecipeIds;
  final List<String> triedRecipeIds;
  final Map<DateTime, List<String>> mealPlan;
  final bool isLoading;
  final RecipeError? error;

  const UserRecipeState({
    this.userRecipeData = const {},
    this.favoriteRecipeIds = const [],
    this.triedRecipeIds = const [],
    this.mealPlan = const {},
    this.isLoading = false,
    this.error,
  });

  UserRecipeState copyWith({
    Map<String, UserRecipeData>? userRecipeData,
    List<String>? favoriteRecipeIds,
    List<String>? triedRecipeIds,
    Map<DateTime, List<String>>? mealPlan,
    bool? isLoading,
    RecipeError? error,
  }) {
    return UserRecipeState(
      userRecipeData: userRecipeData ?? this.userRecipeData,
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
      triedRecipeIds: triedRecipeIds ?? this.triedRecipeIds,
      mealPlan: mealPlan ?? this.mealPlan,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Check if a recipe is favorited
  bool isFavorite(String recipeId) {
    return favoriteRecipeIds.contains(recipeId);
  }

  /// Check if a recipe has been tried
  bool hasTried(String recipeId) {
    return triedRecipeIds.contains(recipeId);
  }

  /// Get user recipe data for a specific recipe
  UserRecipeData? getUserRecipeData(String recipeId) {
    return userRecipeData[recipeId];
  }

  /// Check if a recipe is in meal plan for a specific date
  bool isInMealPlan(String recipeId, DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return mealPlan[dateKey]?.contains(recipeId) ?? false;
  }

  /// Get meal plan recipes for a specific date
  List<String> getMealPlanRecipes(DateTime date) {
    final dateKey = DateTime(date.year, date.month, date.day);
    return mealPlan[dateKey] ?? [];
  }
}

@riverpod
class UserRecipeController extends _$UserRecipeController {
  @override
  UserRecipeState build() {
    // Auto-load user data when controller is created
    _loadUserData();
    return const UserRecipeState();
  }

  /// Load all user recipe data
  Future<void> _loadUserData() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(userRecipeRepositoryProvider);

      // Load all user recipe data in parallel
      final allUserDataFuture = repository.getAllUserRecipeData(user.id);
      final favoritesFuture = repository.getFavoriteRecipeIds(user.id);
      final triedFuture = repository.getTriedRecipeIds(user.id);
      final mealPlanFuture = repository.getMealPlanRecipeIdsForDateRange(
        user.id,
        DateTime.now().subtract(const Duration(days: 30)),
        DateTime.now().add(const Duration(days: 30)),
      );

      final results = await Future.wait([
        allUserDataFuture,
        favoritesFuture,
        triedFuture,
        mealPlanFuture,
      ]);

      final allUserData = results[0] as List<UserRecipeData>;
      final favorites = results[1] as List<String>;
      final tried = results[2] as List<String>;
      final mealPlanData = results[3] as Map<DateTime, List<String>>;

      // Convert user data list to map
      final userDataMap = <String, UserRecipeData>{};
      for (final data in allUserData) {
        userDataMap[data.recipeId] = data;
      }

      state = state.copyWith(
        userRecipeData: userDataMap,
        favoriteRecipeIds: favorites,
        triedRecipeIds: tried,
        mealPlan: mealPlanData,
        isLoading: false,
      );
    } catch (e) {
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: 'loadUserData',
      );
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  /// Toggle favorite status for a recipe
  Future<void> toggleFavorite(String recipeId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      await repository.toggleFavorite(user.id, recipeId);

      // Update local state optimistically
      final currentFavorites = List<String>.from(state.favoriteRecipeIds);
      if (currentFavorites.contains(recipeId)) {
        currentFavorites.remove(recipeId);
      } else {
        currentFavorites.add(recipeId);
      }

      state = state.copyWith(favoriteRecipeIds: currentFavorites);

      // Update user recipe data
      await _updateUserRecipeData(recipeId);
    } catch (e) {
      // Revert optimistic update on error
      await _loadUserData();
    }
  }

  /// Mark recipe as tried
  Future<void> markAsTried(String recipeId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      await repository.markAsTried(user.id, recipeId);

      // Update local state optimistically
      final currentTried = List<String>.from(state.triedRecipeIds);
      if (!currentTried.contains(recipeId)) {
        currentTried.add(recipeId);
      }

      state = state.copyWith(triedRecipeIds: currentTried);

      // Update user recipe data
      await _updateUserRecipeData(recipeId);
    } catch (e) {
      // Revert optimistic update on error
      await _loadUserData();
    }
  }

  /// Update personal notes for a recipe with validation
  Future<void> updatePersonalNotes(String recipeId, String? notes) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = state.copyWith(
        error: const RecipePermissionError(
          message: 'User not authenticated',
          operation: 'updatePersonalNotes',
        ),
      );
      return;
    }

    // Validate and sanitize notes
    final validationService = ref.read(recipeValidationServiceProvider);
    try {
      final sanitizedNotes = validationService.validateAndSanitizePersonalNotes(notes);
      notes = sanitizedNotes;
    } catch (e) {
      if (e is RecipeValidationError) {
        state = state.copyWith(error: e);
        return;
      }
      rethrow;
    }

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      await repository.updatePersonalNotes(user.id, recipeId, notes);

      // Update local state
      await _updateUserRecipeData(recipeId);
      
      // Clear any previous errors
      state = state.copyWith(error: null);
    } catch (e) {
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: 'updatePersonalNotes',
      );
      state = state.copyWith(error: error);
    }
  }

  /// Add recipe to meal plan for a specific date with validation
  Future<void> addToMealPlan(String recipeId, DateTime date) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      state = state.copyWith(
        error: const RecipePermissionError(
          message: 'User not authenticated',
          operation: 'addToMealPlan',
        ),
      );
      return;
    }

    // Validate meal plan date
    final edgeCaseHandler = ref.read(recipeEdgeCaseHandlerProvider);
    try {
      edgeCaseHandler.validateMealPlanDateSelection(date);
    } catch (e) {
      if (e is RecipeValidationError) {
        state = state.copyWith(error: e);
        return;
      }
      rethrow;
    }

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      await repository.addToMealPlan(user.id, recipeId, date);

      // Update local state optimistically
      final dateKey = DateTime(date.year, date.month, date.day);
      final currentMealPlan = Map<DateTime, List<String>>.from(state.mealPlan);
      final dayRecipes = List<String>.from(currentMealPlan[dateKey] ?? []);

      if (!dayRecipes.contains(recipeId)) {
        dayRecipes.add(recipeId);
        currentMealPlan[dateKey] = dayRecipes;
      }

      state = state.copyWith(
        mealPlan: currentMealPlan,
        error: null, // Clear any previous errors
      );

      // Update user recipe data
      await _updateUserRecipeData(recipeId);
    } catch (e) {
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: 'addToMealPlan',
      );
      
      state = state.copyWith(error: error);
      
      // Revert optimistic update on error
      await _loadUserData();
    }
  }

  /// Remove recipe from meal plan
  Future<void> removeFromMealPlan(String recipeId, DateTime date) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      await repository.removeFromMealPlan(user.id, recipeId);

      // Update local state optimistically
      final dateKey = DateTime(date.year, date.month, date.day);
      final currentMealPlan = Map<DateTime, List<String>>.from(state.mealPlan);
      final dayRecipes = List<String>.from(currentMealPlan[dateKey] ?? []);

      dayRecipes.remove(recipeId);
      if (dayRecipes.isEmpty) {
        currentMealPlan.remove(dateKey);
      } else {
        currentMealPlan[dateKey] = dayRecipes;
      }

      state = state.copyWith(mealPlan: currentMealPlan);

      // Update user recipe data
      await _updateUserRecipeData(recipeId);
    } catch (e) {
      // Revert optimistic update on error
      await _loadUserData();
    }
  }

  /// Increment view count for a recipe
  Future<void> incrementViewCount(String recipeId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      await repository.incrementViewCount(user.id, recipeId);

      // Update user recipe data
      await _updateUserRecipeData(recipeId);
    } catch (e) {
      // Silently fail for view count updates
    }
  }

  /// Get progress statistics
  Map<String, int> getProgressStats() {
    return {
      'totalFavorites': state.favoriteRecipeIds.length,
      'totalTried': state.triedRecipeIds.length,
      'totalWithNotes': state.userRecipeData.values
          .where((data) => data.personalNotes?.isNotEmpty == true)
          .length,
      'totalInMealPlan': state.mealPlan.values
          .expand((recipes) => recipes)
          .toSet()
          .length,
    };
  }

  /// Get meal plan for a date range
  Map<DateTime, List<String>> getMealPlanForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final result = <DateTime, List<String>>{};

    for (final entry in state.mealPlan.entries) {
      if (entry.key.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entry.key.isBefore(endDate.add(const Duration(days: 1)))) {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// Prepare sharing data for a recipe
  Map<String, dynamic> prepareRecipeForSharing(String recipeId) {
    final userData = state.getUserRecipeData(recipeId);

    return {
      'recipeId': recipeId,
      'isFavorite': state.isFavorite(recipeId),
      'hasTried': state.hasTried(recipeId),
      'personalNotes': userData?.personalNotes,
      'viewCount': userData?.viewCount ?? 0,
      'lastViewed': userData?.lastViewed?.toIso8601String(),
      'triedDate': userData?.triedDate?.toIso8601String(),
    };
  }

  /// Refresh all user data
  Future<void> refresh() async {
    await _loadUserData();
  }

  /// Update user recipe data for a specific recipe
  Future<void> _updateUserRecipeData(String recipeId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    try {
      final repository = ref.read(userRecipeRepositoryProvider);
      final userData = await repository.getUserRecipeData(user.id, recipeId);

      if (userData != null) {
        final currentData = Map<String, UserRecipeData>.from(
          state.userRecipeData,
        );
        currentData[recipeId] = userData;
        state = state.copyWith(userRecipeData: currentData);
      }
    } catch (e) {
      // Silently fail for individual updates
    }
  }
}
