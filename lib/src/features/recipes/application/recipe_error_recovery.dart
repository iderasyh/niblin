import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/cache_service.dart';
import '../domain/baby_stage.dart';
import '../domain/category.dart' as recipe_category;

import '../domain/nutritional_info.dart';
import '../domain/recipe.dart';
import '../domain/recipe_error.dart';

part 'recipe_error_recovery.g.dart';

/// Service for handling recipe error recovery and fallback strategies
@riverpod
RecipeErrorRecovery recipeErrorRecovery(RecipeErrorRecoveryRef ref) {
  return RecipeErrorRecovery(ref);
}

class RecipeErrorRecovery {
  const RecipeErrorRecovery(this.ref);
  
  final RecipeErrorRecoveryRef ref;

  /// Attempt to recover from a recipe loading error
  Future<Recipe?> recoverRecipe(
    String recipeId,
    RecipeError error,
    Future<Recipe?> Function() retryFunction,
  ) async {
    final cacheService = ref.read(cacheServiceProvider.notifier);

    // If error allows cached data, try to get it
    if (error.shouldShowCachedData) {
      final cached = cacheService.getWithSuffix(CacheKey.recipeById, recipeId);

      if (cached != null && cached is Recipe) {
        return cached;
      }
    }

    // If error is retryable, attempt retry with exponential backoff
    if (error.isRetryable) {
      return await _retryWithBackoff<Recipe?>(retryFunction, maxRetries: 3);
    }

    return null;
  }

  /// Attempt to recover from a recipe list loading error
  Future<List<Recipe>> recoverRecipeList(
    String cacheKey,
    RecipeError error,
    Future<List<Recipe>> Function() retryFunction,
  ) async {
    final cacheService = ref.read(cacheServiceProvider.notifier);

    // If error allows cached data, try to get it
    if (error.shouldShowCachedData) {
      final cached = cacheService.get(CacheKey.recipesByStage);

      if (cached != null && cached is List<Recipe>) {
        return cached;
      }
    }

    // If error is retryable, attempt retry with exponential backoff
    if (error.isRetryable) {
      final result = await _retryWithBackoff<List<Recipe>>(retryFunction, maxRetries: 2);
      return result ?? <Recipe>[];
    }

    return <Recipe>[];
  }

  /// Create a fallback recipe for missing content
  Recipe createFallbackRecipe(String recipeId, String languageCode) {
    final now = DateTime.now();
    
    return Recipe(
      id: recipeId,
      name: {
        'en': 'Recipe Unavailable',
        'sq': 'Receta e Padisponueshme',
      },
      description: {
        'en': 'This recipe is temporarily unavailable. Please try again later.',
        'sq': 'Kjo recetë është përkohësisht e padisponueshme. Ju lutemi provoni më vonë.',
      },
      category: recipe_category.Category.breakfast,
      supportedStages: [BabyStage.stage1],
      imageUrl: '',
      prepTimeMinutes: 0,
      cookTimeMinutes: 0,
      servings: 1,
      nutritionalInfo: const NutritionalInfo(
        caloriesPerServing: 0,
        oneWordDescription: {
          'en': 'Recipe Unavailable',
          'sq': 'Receta e Padisponueshme',
        },
        vitamins: {},
        minerals: {},
        developmentBenefits: [],
        benefitExplanations: {},
        funFacts: {},
      ),
      ingredients: {
        'en': [],
        'sq': [],
      },
      instructions: {
        'en': [],
        'sq': [],
      },
      servingGuidance: {
        'en': 'Content unavailable',
        'sq': 'Përmbajtja e padisponueshme',
      },
      storageInfo: {
        'en': 'Information unavailable',
        'sq': 'Informacioni i padisponueshëm',
      },
      troubleshooting: {
        'en': [],
        'sq': [],
      },
      whyKidsLoveThis: {
        'en': 'Information unavailable',
        'sq': 'Informacioni i padisponueshëm',
      },
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Validate and sanitize recipe content
  Recipe validateAndSanitizeRecipe(Recipe recipe) {
    final missingFields = <String>[];
    
    // Check for missing essential content
    if (recipe.name.isEmpty) missingFields.add('name');
    if (recipe.ingredients.isEmpty) missingFields.add('ingredients');
    if (recipe.instructions.isEmpty) missingFields.add('instructions');
    
    // If critical fields are missing, throw content error
    if (missingFields.isNotEmpty) {
      throw RecipeContentError(
        message: 'Recipe is missing essential content',
        missingFields: missingFields,
      );
    }
    
    // Sanitize and provide defaults for optional fields
    return recipe.copyWith(
      description: recipe.description.isNotEmpty 
          ? recipe.description 
          : {'en': 'No description available', 'sq': 'Nuk ka përshkrim'},
      servingGuidance: recipe.servingGuidance.isNotEmpty
          ? recipe.servingGuidance
          : {'en': 'Follow standard serving guidelines', 'sq': 'Ndiqni udhëzimet standarde'},
      storageInfo: recipe.storageInfo.isNotEmpty
          ? recipe.storageInfo
          : {'en': 'Store in refrigerator', 'sq': 'Ruani në frigorifer'},
      troubleshooting: recipe.troubleshooting.isNotEmpty
          ? recipe.troubleshooting
          : {
              'en': ['Contact support if you need help'],
              'sq': ['Kontaktoni mbështetjen nëse keni nevojë për ndihmë'],
            },
      whyKidsLoveThis: recipe.whyKidsLoveThis.isNotEmpty
          ? recipe.whyKidsLoveThis
          : {'en': 'Kids love this recipe!', 'sq': 'Fëmijët e duan këtë recetë!'},
    );
  }

  /// Handle network connectivity issues
  Future<T?> handleNetworkOperation<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    try {
      return await operation();
    } catch (e) {
      // Convert to appropriate RecipeError
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: operationName,
      );
      
      throw error;
    }
  }

  /// Retry operation with exponential backoff
  Future<T?> _retryWithBackoff<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        
        if (attempt >= maxRetries) {
          rethrow;
        }
        
        // Wait before retrying with exponential backoff
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }
    
    return null;
  }

  /// Check if cached data is still valid
  bool isCachedDataValid(DateTime? cachedAt, Duration maxAge) {
    if (cachedAt == null) return false;
    return DateTime.now().difference(cachedAt) < maxAge;
  }

  /// Get graceful degradation content for missing recipe data
  Map<String, dynamic> getGracefulDegradationContent(
    Recipe recipe,
    String languageCode,
    List<String> missingFields,
  ) {
    final content = <String, dynamic>{};
    
    for (final field in missingFields) {
      switch (field) {
        case 'ingredients':
          content['ingredients'] = {
            'en': 'Ingredients list is temporarily unavailable',
            'sq': 'Lista e përbërësve është përkohësisht e padisponueshme',
          };
          break;
        case 'instructions':
          content['instructions'] = {
            'en': 'Cooking instructions are temporarily unavailable',
            'sq': 'Udhëzimet e gatimit janë përkohësisht të padisponueshme',
          };
          break;
        case 'nutritionalInfo':
          content['nutritionalInfo'] = {
            'en': 'Nutritional information is temporarily unavailable',
            'sq': 'Informacioni ushqyes është përkohësisht i padisponueshëm',
          };
          break;
        case 'servingGuidance':
          content['servingGuidance'] = {
            'en': 'Serving guidance is temporarily unavailable',
            'sq': 'Udhëzimet e shërbimit janë përkohësisht të padisponueshme',
          };
          break;
        default:
          content[field] = {
            'en': 'Content temporarily unavailable',
            'sq': 'Përmbajtja përkohësisht e padisponueshme',
          };
      }
    }
    
    return content;
  }

  /// Create error state with retry options
  Map<String, dynamic> createErrorState(
    RecipeError error,
    String languageCode, {
    VoidCallback? onRetry,
    VoidCallback? onShowCached,
  }) {
    final fallback = RecipeErrorHandler.getFallbackContent(error, languageCode);
    
    return {
      ...fallback,
      'error': error,
      'onRetry': error.isRetryable ? onRetry : null,
      'onShowCached': error.shouldShowCachedData ? onShowCached : null,
      'timestamp': DateTime.now(),
    };
  }
}

/// Extension for adding error recovery to Future operations
extension RecipeErrorRecoveryExtension<T> on Future<T> {
  /// Add automatic error recovery to any Future operation
  Future<T> withRecovery(
    String operationName, {
    T? fallback,
    bool shouldRetry = true,
  }) async {
    try {
      return await this;
    } catch (e) {
      final error = RecipeErrorHandler.fromException(
        e is Exception ? e : Exception(e.toString()),
        context: operationName,
      );
      
      if (shouldRetry && error.isRetryable && fallback != null) {
        return fallback;
      }
      
      throw error;
    }
  }
}