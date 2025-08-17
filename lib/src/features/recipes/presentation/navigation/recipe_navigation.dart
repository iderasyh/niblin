import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/category.dart';
import '../../../../routing/app_router.dart';

/// Navigation helper for recipe-related screens
class RecipeNavigation {
  /// Navigate to the recipe list screen
  static void toRecipeList(BuildContext context) {
    context.go(AppRoute.recipes.path);
  }

  /// Navigate to the recipe list screen with a specific category
  static void toRecipeListWithCategory(BuildContext context, Category category) {
    context.go('${AppRoute.recipes.path}?category=${category.name}');
  }

  /// Navigate to the recipe list screen with a search query
  static void toRecipeListWithSearch(BuildContext context, String searchQuery) {
    context.go('${AppRoute.recipes.path}?search=${Uri.encodeComponent(searchQuery)}');
  }

  /// Navigate to the recipe list screen with both category and search
  static void toRecipeListWithFilters(
    BuildContext context, {
    Category? category,
    String? searchQuery,
  }) {
    final queryParams = <String, String>{};
    if (category != null) {
      queryParams['category'] = category.name;
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['search'] = Uri.encodeComponent(searchQuery);
    }

    final uri = Uri(
      path: AppRoute.recipes.path,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    context.go(uri.toString());
  }

  /// Navigate to a specific recipe detail screen
  static void toRecipeDetail(BuildContext context, String recipeId) {
    context.go('${AppRoute.recipes.path}/$recipeId');
  }

  /// Push a recipe detail screen (for modal/overlay navigation)
  static void pushRecipeDetail(BuildContext context, String recipeId) {
    context.push('${AppRoute.recipes.path}/$recipeId');
  }

  /// Navigate back from recipe detail to recipe list
  static void backToRecipeList(BuildContext context) {
    // Check if we can pop, otherwise go to recipe list
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoute.recipes.path);
    }
  }

  /// Navigate to recipe detail with replacement (no back navigation)
  static void replaceWithRecipeDetail(BuildContext context, String recipeId) {
    context.pushReplacement('${AppRoute.recipes.path}/$recipeId');
  }

  /// Navigate to recipe list from search results
  static void fromSearchToRecipeList(
    BuildContext context, {
    Category? category,
    String? searchQuery,
  }) {
    toRecipeListWithFilters(
      context,
      category: category,
      searchQuery: searchQuery,
    );
  }

  /// Navigate to recipe detail from recommendations
  static void fromRecommendationToDetail(BuildContext context, String recipeId) {
    // Use push to maintain the recommendation context
    pushRecipeDetail(context, recipeId);
  }

  /// Get the current recipe ID from the route (if on recipe detail screen)
  static String? getCurrentRecipeId(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final recipePathPattern = RegExp(r'/recipes/([^/?]+)');
    final match = recipePathPattern.firstMatch(location);
    return match?.group(1);
  }

  /// Check if currently on recipe list screen
  static bool isOnRecipeList(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return location == AppRoute.recipes.path;
  }

  /// Check if currently on recipe detail screen
  static bool isOnRecipeDetail(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return location.startsWith('${AppRoute.recipes.path}/') && 
           location != AppRoute.recipes.path;
  }

  /// Extract query parameters from current route
  static Map<String, String> getCurrentQueryParams(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }

  /// Get current category from route parameters
  static Category? getCurrentCategory(BuildContext context) {
    final categoryName = getCurrentQueryParams(context)['category'];
    if (categoryName == null) return null;
    
    try {
      return Category.values.firstWhere((c) => c.name == categoryName);
    } catch (e) {
      return null;
    }
  }

  /// Get current search query from route parameters
  static String? getCurrentSearchQuery(BuildContext context) {
    return getCurrentQueryParams(context)['search'];
  }

  // --- Search and Discovery Navigation ---

  /// Navigate to search results with preserved state
  static void toSearchResults(
    BuildContext context, {
    required String searchQuery,
    Category? category,
    bool preserveState = true,
  }) {
    if (preserveState && isOnRecipeList(context)) {
      // Update current route with search parameters
      toRecipeListWithFilters(
        context,
        category: category ?? getCurrentCategory(context),
        searchQuery: searchQuery,
      );
    } else {
      // Navigate to new search results
      toRecipeListWithSearch(context, searchQuery);
    }
  }

  /// Navigate from search results to a specific recipe
  static void fromSearchToRecipeDetail(
    BuildContext context,
    String recipeId, {
    String? searchQuery,
    Category? category,
  }) {
    // Navigate to recipe detail (maintains search context in browser history)
    toRecipeDetail(context, recipeId);
  }

  /// Navigate back to search results from recipe detail
  static void backToSearchResults(
    BuildContext context, {
    String? searchQuery,
    Category? category,
  }) {
    if (context.canPop()) {
      context.pop();
    } else {
      // Fallback to search results
      toRecipeListWithFilters(
        context,
        category: category,
        searchQuery: searchQuery,
      );
    }
  }

  /// Clear search and return to category view
  static void clearSearchAndReturnToCategory(
    BuildContext context,
    Category category,
  ) {
    toRecipeListWithCategory(context, category);
  }

  /// Navigate between categories with state preservation
  static void switchCategory(
    BuildContext context,
    Category newCategory, {
    bool preserveSearch = false,
  }) {
    final currentSearch = preserveSearch ? getCurrentSearchQuery(context) : null;
    
    toRecipeListWithFilters(
      context,
      category: newCategory,
      searchQuery: currentSearch,
    );
  }

  /// Navigate to category with search cleared
  static void toCategoryClean(BuildContext context, Category category) {
    toRecipeListWithCategory(context, category);
  }

  // --- Recommendation Navigation ---

  /// Navigate to recipe detail from recommendation context
  static void fromRecommendationToRecipeDetail(
    BuildContext context,
    String recipeId, {
    String? sourceRecipeId,
    String? recommendationType,
  }) {
    // Use push to maintain recommendation context
    pushRecipeDetail(context, recipeId);
  }

  /// Navigate to more recommendations of the same type
  static void toMoreRecommendations(
    BuildContext context, {
    Category? category,
    String? recommendationType,
  }) {
    toRecipeListWithFilters(
      context,
      category: category,
      searchQuery: null, // Clear search for recommendations
    );
  }

  /// Navigate from recommendation back to original recipe
  static void backToOriginalRecipe(
    BuildContext context,
    String originalRecipeId,
  ) {
    // Replace current recipe with original
    replaceWithRecipeDetail(context, originalRecipeId);
  }

  // --- Advanced Navigation State Management ---

  /// Get navigation breadcrumb for current location
  static List<String> getNavigationBreadcrumb(BuildContext context) {
    final breadcrumb = <String>['Recipes'];
    
    final category = getCurrentCategory(context);
    if (category != null) {
      breadcrumb.add(category.displayName);
    }
    
    final searchQuery = getCurrentSearchQuery(context);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      breadcrumb.add('Search: $searchQuery');
    }
    
    if (isOnRecipeDetail(context)) {
      final recipeId = getCurrentRecipeId(context);
      if (recipeId != null) {
        breadcrumb.add('Recipe');
      }
    }
    
    return breadcrumb;
  }

  /// Check if navigation can go back with preserved state
  static bool canGoBackWithState(BuildContext context) {
    return context.canPop();
  }

  /// Navigate back with intelligent state preservation
  static void smartBack(BuildContext context) {
    if (isOnRecipeDetail(context)) {
      // From recipe detail, go back to list with preserved filters
      backToRecipeList(context);
    } else if (getCurrentSearchQuery(context) != null) {
      // From search results, clear search but keep category
      final category = getCurrentCategory(context);
      if (category != null) {
        clearSearchAndReturnToCategory(context, category);
      } else {
        toRecipeList(context);
      }
    } else {
      // Default back navigation
      if (context.canPop()) {
        context.pop();
      } else {
        toRecipeList(context);
      }
    }
  }

  /// Navigate to recipe list with preserved scroll position
  static void toRecipeListPreserveScroll(
    BuildContext context, {
    Category? category,
    String? searchQuery,
  }) {
    // This would typically work with a scroll controller
    // For now, just navigate normally
    toRecipeListWithFilters(
      context,
      category: category,
      searchQuery: searchQuery,
    );
  }

  /// Check if current route has active filters
  static bool hasActiveFilters(BuildContext context) {
    final params = getCurrentQueryParams(context);
    return params.containsKey('category') || params.containsKey('search');
  }

  /// Clear all filters and return to main recipe list
  static void clearAllFilters(BuildContext context) {
    toRecipeList(context);
  }

  /// Get current navigation context for state restoration
  static Map<String, dynamic> getCurrentNavigationState(BuildContext context) {
    return {
      'isOnRecipeList': isOnRecipeList(context),
      'isOnRecipeDetail': isOnRecipeDetail(context),
      'currentRecipeId': getCurrentRecipeId(context),
      'currentCategory': getCurrentCategory(context)?.name,
      'currentSearchQuery': getCurrentSearchQuery(context),
      'hasActiveFilters': hasActiveFilters(context),
      'canGoBack': canGoBackWithState(context),
    };
  }

  /// Restore navigation state
  static void restoreNavigationState(
    BuildContext context,
    Map<String, dynamic> state,
  ) {
    final recipeId = state['currentRecipeId'] as String?;
    final categoryName = state['currentCategory'] as String?;
    final searchQuery = state['currentSearchQuery'] as String?;
    
    if (recipeId != null && state['isOnRecipeDetail'] == true) {
      toRecipeDetail(context, recipeId);
    } else {
      Category? category;
      if (categoryName != null) {
        try {
          category = Category.values.firstWhere((c) => c.name == categoryName);
        } catch (e) {
          category = null;
        }
      }
      
      toRecipeListWithFilters(
        context,
        category: category,
        searchQuery: searchQuery,
      );
    }
  }
}