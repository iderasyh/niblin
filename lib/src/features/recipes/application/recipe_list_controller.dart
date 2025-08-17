import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/firebase_recipe_repository.dart';
import '../domain/baby_stage.dart';
import '../domain/category.dart';
import '../domain/recipe.dart';
import '../domain/recipe_error.dart';
import 'recipe_error_recovery.dart';
import 'recipe_validation_service.dart';

part 'recipe_list_controller.g.dart';

// Sentinel value for copyWith nullable fields
const _undefined = Object();

/// State class for recipe list with filtering and pagination
class RecipeListState {
  final List<Recipe> recipes;
  final bool isLoading;
  final RecipeError? error;
  final Category? selectedCategory;
  final BabyStage? selectedStage;
  final String searchQuery;
  final bool hasMore;
  final int currentPage;
  final bool isUsingCachedData;

  const RecipeListState({
    this.recipes = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.selectedStage,
    this.searchQuery = '',
    this.hasMore = true,
    this.currentPage = 0,
    this.isUsingCachedData = false,
  });

  RecipeListState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    RecipeError? error,
    Object? selectedCategory = _undefined,
    Object? selectedStage = _undefined,
    String? searchQuery,
    bool? hasMore,
    int? currentPage,
    bool? isUsingCachedData,
  }) {
    return RecipeListState(
      recipes: recipes ?? this.recipes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory == _undefined
          ? this.selectedCategory
          : selectedCategory as Category?,
      selectedStage: selectedStage == _undefined
          ? this.selectedStage
          : selectedStage as BabyStage?,
      searchQuery: searchQuery ?? this.searchQuery,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isUsingCachedData: isUsingCachedData ?? this.isUsingCachedData,
    );
  }
}

@riverpod
class RecipeListController extends _$RecipeListController {
  static const int _pageSize = 20;
  Timer? _searchDebounceTimer;

  @override
  RecipeListState build() {
    return const RecipeListState();
  }

  /// Load recipes with current filters
  Future<void> loadRecipes({bool refresh = false}) async {
    if (state.isLoading && !refresh) return;

    // Validate search query if present
    if (state.searchQuery.isNotEmpty && state.searchQuery.length < 2) {
      state = state.copyWith(
        isLoading: false,
        error: const RecipeValidationError(
          field: 'searchQuery',
          message: 'Search query too short',
        ),
      );
      return;
    }

    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 0,
        hasMore: true,
        isUsingCachedData: false,
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final repository = ref.read(recipeRepositoryProvider);
      final errorRecovery = ref.read(recipeErrorRecoveryProvider);

      List<Recipe> newRecipes;

      // Fetch from repository based on current filters with error recovery
      final operation = () async {
        if (state.searchQuery.isNotEmpty) {
          return await repository.searchRecipes(state.searchQuery);
        } else if (state.selectedCategory != null &&
            state.selectedStage != null) {
          return await repository.getRecipesByCategoryAndStage(
            state.selectedCategory!,
          );
        } else if (state.selectedCategory != null) {
          return await repository.getRecipesByCategory(
            state.selectedCategory!,
          );
        } else {
          return await repository.getRecipesByStage();
        }
      };

      newRecipes = await errorRecovery.handleNetworkOperation(
        operation,
        'loadRecipes',
      ) ?? [];

      // Apply pagination
      final startIndex = state.currentPage * _pageSize;
      final endIndex = startIndex + _pageSize;
      final paginatedRecipes = newRecipes
          .skip(startIndex)
          .take(_pageSize)
          .toList();

      final updatedRecipes = refresh || state.currentPage == 0
          ? paginatedRecipes
          : [...state.recipes, ...paginatedRecipes];

      state = state.copyWith(
        recipes: updatedRecipes,
        isLoading: false,
        hasMore: endIndex < newRecipes.length,
        currentPage: refresh ? 0 : state.currentPage,
        isUsingCachedData: false,
      );
    } catch (e) {
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: 'loadRecipes',
      );

      // Try to recover with cached data
      final errorRecovery = ref.read(recipeErrorRecoveryProvider);
      final cacheKey = _getCacheKey();
      
      try {
        final cachedRecipes = await errorRecovery.recoverRecipeList(
          cacheKey,
          error,
          () => throw error, // Don't retry, just use cache
        );

        if (cachedRecipes.isNotEmpty) {
          state = state.copyWith(
            recipes: cachedRecipes,
            isLoading: false,
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

  /// Load more recipes for pagination
  Future<void> loadMoreRecipes() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadRecipes();
  }

  /// Set category filter
  Future<void> setCategory(Category? category) async {
    if (state.selectedCategory == category) return;

    state = state.copyWith(
      selectedCategory: category,
      recipes: [],
      currentPage: 0,
      hasMore: true,
    );

    await loadRecipes(refresh: true);
  }

  /// Set stage filter
  Future<void> setStage(BabyStage? stage) async {
    if (state.selectedStage == stage) return;

    state = state.copyWith(
      selectedStage: stage,
      recipes: [],
      currentPage: 0,
      hasMore: true,
    );

    await loadRecipes(refresh: true);
  }

  /// Set search query with debouncing and validation
  void setSearchQuery(String query) {
    _searchDebounceTimer?.cancel();

    // Validate and sanitize search query
    final validationService = ref.read(recipeValidationServiceProvider);
    final validationError = validationService.validateSearchQuery(query);
    
    if (validationError != null) {
      state = state.copyWith(
        searchQuery: query,
        error: validationError,
      );
      return;
    }

    // Sanitize the query
    final sanitizedQuery = validationService.sanitizeTextInput(query);

    state = state.copyWith(
      searchQuery: sanitizedQuery,
      error: null, // Clear any validation errors
    );

    if (sanitizedQuery.isEmpty) {
      // Clear search immediately
      state = state.copyWith(recipes: [], currentPage: 0, hasMore: true);
      loadRecipes(refresh: true);
      return;
    }

    // Debounce search queries
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(recipes: [], currentPage: 0, hasMore: true);
      loadRecipes(refresh: true);
    });
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    state = state.copyWith(
      selectedCategory: null,
      selectedStage: null,
      searchQuery: '',
      recipes: [],
      currentPage: 0,
      hasMore: true,
    );

    await loadRecipes(refresh: true);
  }

  /// Refresh recipes
  Future<void> refresh() async {
    await loadRecipes(refresh: true);
  }

  /// Get cache key for current filters
  String _getCacheKey() {
    final parts = <String>['recipes'];
    
    if (state.selectedCategory != null) {
      parts.add('category_${state.selectedCategory!.name}');
    }
    
    if (state.selectedStage != null) {
      parts.add('stage_${state.selectedStage!.name}');
    }
    
    if (state.searchQuery.isNotEmpty) {
      parts.add('search_${state.searchQuery}');
    }
    
    return parts.join('_');
  }

  /// Retry loading recipes after error
  Future<void> retryLoadRecipes() async {
    state = state.copyWith(error: null);
    await loadRecipes(refresh: true);
  }

  /// Show cached data if available
  void showCachedData() {
    if (state.error?.shouldShowCachedData == true) {
      // This will be handled by the error recovery service
      loadRecipes(refresh: true);
    }
  }

  void dispose() {
    _searchDebounceTimer?.cancel();
  }
}
