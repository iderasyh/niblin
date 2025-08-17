import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/baby_stage.dart';
import '../domain/category.dart' as recipe_category;
import '../domain/ingredient.dart';
import '../domain/instruction.dart';
import '../domain/nutritional_info.dart';
import '../domain/recipe.dart';
import '../domain/recipe_error.dart';
import '../domain/user_recipe_data.dart';

part 'recipe_edge_case_handler.g.dart';

/// Service for handling edge cases in recipe operations
@riverpod
RecipeEdgeCaseHandler recipeEdgeCaseHandler(RecipeEdgeCaseHandlerRef ref) {
  return const RecipeEdgeCaseHandler();
}

class RecipeEdgeCaseHandler {
  const RecipeEdgeCaseHandler();

  /// Handle missing recipe data by providing fallbacks
  Recipe handleMissingRecipeData(Recipe recipe, String languageCode) {
    final missingFields = <String>[];
    
    // Check for missing essential fields and provide fallbacks
    Map<String, String> name = recipe.name;
    if (name.isEmpty || !name.containsKey(languageCode)) {
      name = {
        ...name,
        languageCode: 'Untitled Recipe',
      };
      missingFields.add('name');
    }
    
    Map<String, String> description = recipe.description;
    if (description.isEmpty || !description.containsKey(languageCode)) {
      description = {
        ...description,
        languageCode: languageCode == 'sq' 
            ? 'Përshkrimi nuk është i disponueshëm'
            : 'Description not available',
      };
      missingFields.add('description');
    }
    
    Map<String, List<Ingredient>> ingredients = recipe.ingredients;
    if (ingredients.isEmpty || !ingredients.containsKey(languageCode)) {
      ingredients = {
        ...ingredients,
        languageCode: [],
      };
      missingFields.add('ingredients');
    }
    
    Map<String, List<Instruction>> instructions = recipe.instructions;
    if (instructions.isEmpty || !instructions.containsKey(languageCode)) {
      instructions = {
        ...instructions,
        languageCode: [],
      };
      missingFields.add('instructions');
    }
    
    Map<String, String> servingGuidance = recipe.servingGuidance;
    if (servingGuidance.isEmpty || !servingGuidance.containsKey(languageCode)) {
      servingGuidance = {
        ...servingGuidance,
        languageCode: languageCode == 'sq'
            ? 'Udhëzimet e shërbimit nuk janë të disponueshme'
            : 'Serving guidance not available',
      };
      missingFields.add('servingGuidance');
    }
    
    Map<String, String> storageInfo = recipe.storageInfo;
    if (storageInfo.isEmpty || !storageInfo.containsKey(languageCode)) {
      storageInfo = {
        ...storageInfo,
        languageCode: languageCode == 'sq'
            ? 'Informacioni i ruajtjes nuk është i disponueshëm'
            : 'Storage information not available',
      };
      missingFields.add('storageInfo');
    }
    
    Map<String, List<String>> troubleshooting = recipe.troubleshooting;
    if (troubleshooting.isEmpty || !troubleshooting.containsKey(languageCode)) {
      troubleshooting = {
        ...troubleshooting,
        languageCode: languageCode == 'sq'
            ? ['Këshillat për zgjidhjen e problemeve nuk janë të disponueshme']
            : ['Troubleshooting tips not available'],
      };
      missingFields.add('troubleshooting');
    }
    
    Map<String, String> whyKidsLoveThis = recipe.whyKidsLoveThis;
    if (whyKidsLoveThis.isEmpty || !whyKidsLoveThis.containsKey(languageCode)) {
      whyKidsLoveThis = {
        ...whyKidsLoveThis,
        languageCode: languageCode == 'sq'
            ? 'Informacioni nuk është i disponueshëm'
            : 'Information not available',
      };
      missingFields.add('whyKidsLoveThis');
    }
    
    // Log missing fields for analytics
    if (missingFields.isNotEmpty) {
      // In a real app, you would log this to analytics
      // For now, we'll use debugPrint which is removed in release builds
      assert(() {
        debugPrint('Recipe ${recipe.id} missing fields: ${missingFields.join(', ')}');
        return true;
      }());
    }
    
    return recipe.copyWith(
      name: name,
      description: description,
      ingredients: ingredients,
      instructions: instructions,
      servingGuidance: servingGuidance,
      storageInfo: storageInfo,
      troubleshooting: troubleshooting,
      whyKidsLoveThis: whyKidsLoveThis,
    );
  }

  /// Validate recipe completeness and return missing fields
  List<String> validateRecipeCompleteness(Recipe recipe, String languageCode) {
    final missingFields = <String>[];
    
    // Check essential fields
    if (recipe.name.isEmpty || !recipe.name.containsKey(languageCode)) {
      missingFields.add('name');
    }
    
    if (recipe.ingredients.isEmpty || !recipe.ingredients.containsKey(languageCode)) {
      missingFields.add('ingredients');
    }
    
    if (recipe.instructions.isEmpty || !recipe.instructions.containsKey(languageCode)) {
      missingFields.add('instructions');
    }
    
    // Check optional but important fields
    if (recipe.description.isEmpty || !recipe.description.containsKey(languageCode)) {
      missingFields.add('description');
    }
    
    if (recipe.servingGuidance.isEmpty || !recipe.servingGuidance.containsKey(languageCode)) {
      missingFields.add('servingGuidance');
    }
    
    if (recipe.nutritionalInfo.caloriesPerServing <= 0) {
      missingFields.add('nutritionalInfo');
    }
    
    if (recipe.imageUrl.isEmpty) {
      missingFields.add('imageUrl');
    }
    
    return missingFields;
  }

  /// Handle invalid user recipe data
  UserRecipeData sanitizeUserRecipeData(UserRecipeData data) {
    // Sanitize personal notes
    String? sanitizedNotes = data.personalNotes;
    if (sanitizedNotes != null) {
      // Remove potentially harmful content
      sanitizedNotes = sanitizedNotes
          .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
          .replaceAll(RegExp(r'javascript:', caseSensitive: false), '') // Remove javascript:
          .replaceAll(RegExp(r'data:', caseSensitive: false), '') // Remove data:
          .trim();
      
      // Limit length
      if (sanitizedNotes.length > 500) {
        sanitizedNotes = sanitizedNotes.substring(0, 500);
      }
      
      // If empty after sanitization, set to null
      if (sanitizedNotes.isEmpty) {
        sanitizedNotes = null;
      }
    }
    
    // Validate dates
    DateTime? validatedLastViewed = data.lastViewed;
    DateTime? validatedTriedDate = data.triedDate;
    DateTime? validatedMealPlanDate = data.mealPlanDate;
    
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365));
    final oneYearFromNow = now.add(const Duration(days: 365));
    
    // Validate lastViewed is not in the future
    if (validatedLastViewed != null && validatedLastViewed.isAfter(now)) {
      validatedLastViewed = now;
    }
    
    // Validate triedDate is reasonable
    if (validatedTriedDate != null) {
      if (validatedTriedDate.isBefore(oneYearAgo) || validatedTriedDate.isAfter(now)) {
        validatedTriedDate = null; // Reset invalid date
      }
    }
    
    // Validate mealPlanDate is within reasonable range
    if (validatedMealPlanDate != null) {
      if (validatedMealPlanDate.isBefore(oneYearAgo) || validatedMealPlanDate.isAfter(oneYearFromNow)) {
        validatedMealPlanDate = null; // Reset invalid date
      }
    }
    
    // Validate view count
    int validatedViewCount = data.viewCount;
    if (validatedViewCount < 0) {
      validatedViewCount = 0;
    } else if (validatedViewCount > 10000) {
      // Cap at reasonable maximum
      validatedViewCount = 10000;
    }
    
    return data.copyWith(
      personalNotes: sanitizedNotes,
      lastViewed: validatedLastViewed,
      triedDate: validatedTriedDate,
      mealPlanDate: validatedMealPlanDate,
      viewCount: validatedViewCount,
    );
  }

  /// Handle empty recipe lists with appropriate fallbacks
  List<Recipe> handleEmptyRecipeList(
    List<Recipe> recipes,
    String context,
    String languageCode,
  ) {
    if (recipes.isNotEmpty) {
      return recipes;
    }
    
    // For search results, return empty list
    if (context.contains('search')) {
      return recipes;
    }
    
    // For category/stage filters, could provide suggestions
    // In a real app, you might return popular recipes or recommendations
    return recipes;
  }

  /// Validate recipe ID format and sanitize
  String? validateAndSanitizeRecipeId(String? recipeId) {
    if (recipeId == null || recipeId.isEmpty) {
      return null;
    }
    
    // Remove whitespace
    recipeId = recipeId.trim();
    
    // Check length
    if (recipeId.length > 50) {
      throw const RecipeValidationError(
        field: 'recipeId',
        message: 'Recipe ID is too long',
      );
    }
    
    // Check format (alphanumeric, hyphens, underscores only)
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(recipeId)) {
      throw const RecipeValidationError(
        field: 'recipeId',
        message: 'Recipe ID contains invalid characters',
      );
    }
    
    return recipeId;
  }

  /// Handle concurrent modification conflicts
  UserRecipeData resolveUserDataConflict(
    UserRecipeData local,
    UserRecipeData remote,
  ) {
    // Use last-write-wins strategy with some intelligence
    
    // Use the most recent lastViewed
    DateTime? lastViewed = local.lastViewed;
    if (remote.lastViewed != null) {
      if (lastViewed == null || remote.lastViewed!.isAfter(lastViewed)) {
        lastViewed = remote.lastViewed;
      }
    }
    
    // Use higher view count
    final viewCount = local.viewCount > remote.viewCount 
        ? local.viewCount 
        : remote.viewCount;
    
    // For boolean flags, use OR logic (if either is true, result is true)
    final isFavorite = local.isFavorite || remote.isFavorite;
    final hasTried = local.hasTried || remote.hasTried;
    final isInMealPlan = local.isInMealPlan || remote.isInMealPlan;
    
    // For notes, use the non-empty one, or the most recent if both exist
    String? personalNotes = local.personalNotes;
    if (remote.personalNotes != null && remote.personalNotes!.isNotEmpty) {
      if (personalNotes == null || personalNotes.isEmpty) {
        personalNotes = remote.personalNotes;
      } else {
        // Both have notes, use the one from the most recent lastViewed
        if (remote.lastViewed != null && 
            (local.lastViewed == null || remote.lastViewed!.isAfter(local.lastViewed!))) {
          personalNotes = remote.personalNotes;
        }
      }
    }
    
    // For dates, use the most recent non-null value
    DateTime? triedDate = local.triedDate;
    if (remote.triedDate != null) {
      if (triedDate == null || remote.triedDate!.isAfter(triedDate)) {
        triedDate = remote.triedDate;
      }
    }
    
    DateTime? mealPlanDate = local.mealPlanDate;
    if (remote.mealPlanDate != null) {
      if (mealPlanDate == null || remote.mealPlanDate!.isAfter(mealPlanDate)) {
        mealPlanDate = remote.mealPlanDate;
      }
    }
    
    return UserRecipeData(
      userId: local.userId,
      recipeId: local.recipeId,
      isFavorite: isFavorite,
      hasTried: hasTried,
      personalNotes: personalNotes,
      lastViewed: lastViewed,
      triedDate: triedDate,
      isInMealPlan: isInMealPlan,
      mealPlanDate: mealPlanDate,
      viewCount: viewCount,
    );
  }

  /// Create fallback content for completely missing recipes
  Recipe createMinimalFallbackRecipe(String recipeId, String languageCode) {
    final now = DateTime.now();
    
    return Recipe(
      id: recipeId,
      name: {
        'en': 'Recipe Unavailable',
        'sq': 'Receta e Padisponueshme',
      },
      description: {
        'en': 'This recipe is temporarily unavailable. Please try again later or contact support.',
        'sq': 'Kjo recetë është përkohësisht e padisponueshme. Ju lutemi provoni më vonë ose kontaktoni mbështetjen.',
      },
      category: recipe_category.Category.breakfast,
      supportedStages: [BabyStage.stage1],
      imageUrl: '', // Will show placeholder
      prepTimeMinutes: 0,
      cookTimeMinutes: 0,
      servings: 1,
      nutritionalInfo: const NutritionalInfo(
        caloriesPerServing: 0,
        vitamins: {},
        minerals: {},
        developmentBenefits: [],
        benefitExplanations: {
          'en': 'Nutritional information unavailable',
          'sq': 'Informacioni ushqyes i padisponueshëm',
        },
        funFacts: {
          'en': 'Information unavailable',
          'sq': 'Informacioni i padisponueshëm',
        },
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
        'en': 'Serving guidance unavailable',
        'sq': 'Udhëzimet e shërbimit të padisponueshme',
      },
      storageInfo: {
        'en': 'Storage information unavailable',
        'sq': 'Informacioni i ruajtjes i padisponueshëm',
      },
      troubleshooting: {
        'en': ['Please contact support for assistance'],
        'sq': ['Ju lutemi kontaktoni mbështetjen për ndihmë'],
      },
      whyKidsLoveThis: {
        'en': 'Information unavailable',
        'sq': 'Informacioni i padisponueshëm',
      },
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Validate meal plan date selection
  void validateMealPlanDateSelection(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    
    // Don't allow dates more than 7 days in the past
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    if (selectedDay.isBefore(sevenDaysAgo)) {
      throw RecipeValidationError(
        field: 'mealPlanDate',
        message: 'Cannot plan meals more than 7 days in the past',
        value: selectedDate,
      );
    }
    
    // Don't allow dates more than 1 year in the future
    final oneYearFromNow = today.add(const Duration(days: 365));
    if (selectedDay.isAfter(oneYearFromNow)) {
      throw RecipeValidationError(
        field: 'mealPlanDate',
        message: 'Cannot plan meals more than 1 year in advance',
        value: selectedDate,
      );
    }
  }

  /// Handle network timeout scenarios
  Duration getTimeoutDuration(String operation) {
    switch (operation) {
      case 'search':
        return const Duration(seconds: 10); // Shorter for search
      case 'loadRecipe':
        return const Duration(seconds: 15); // Medium for single recipe
      case 'loadRecipeList':
        return const Duration(seconds: 20); // Longer for lists
      case 'userOperation':
        return const Duration(seconds: 8); // Quick for user actions
      default:
        return const Duration(seconds: 15); // Default timeout
    }
  }

  /// Determine if an error should trigger a retry
  bool shouldRetryOperation(Exception error, int attemptCount) {
    // Don't retry more than 3 times
    if (attemptCount >= 3) {
      return false;
    }
    
    final errorString = error.toString().toLowerCase();
    
    // Retry network errors
    if (errorString.contains('socket') || 
        errorString.contains('timeout') ||
        errorString.contains('network')) {
      return true;
    }
    
    // Don't retry validation errors
    if (error is RecipeValidationError) {
      return false;
    }
    
    // Don't retry permission errors
    if (error is RecipePermissionError) {
      return false;
    }
    
    // Don't retry not found errors
    if (error is RecipeNotFoundError) {
      return false;
    }
    
    // Retry other errors
    return true;
  }
}