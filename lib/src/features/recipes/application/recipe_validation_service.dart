import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/recipe_error.dart';

part 'recipe_validation_service.g.dart';

/// Service for validating recipe-related user input
@riverpod
RecipeValidationService recipeValidationService(RecipeValidationServiceRef ref) {
  return const RecipeValidationService();
}

class RecipeValidationService {
  const RecipeValidationService();

  /// Validate search query input
  RecipeValidationError? validateSearchQuery(String query) {
    if (query.isEmpty) {
      return null; // Empty is valid (clears search)
    }
    
    if (query.length < 2) {
      return const RecipeValidationError(
        field: 'searchQuery',
        message: 'Search must be at least 2 characters',
      );
    }
    
    if (query.length > 100) {
      return const RecipeValidationError(
        field: 'searchQuery',
        message: 'Search query is too long (maximum 100 characters)',
      );
    }
    
    // Check for potentially harmful characters
    if (query.contains(RegExp(r'[<>"\\/]'))) {
      return const RecipeValidationError(
        field: 'searchQuery',
        message: 'Search contains invalid characters',
      );
    }
    
    return null;
  }

  /// Validate personal notes input
  RecipeValidationError? validatePersonalNotes(String? notes) {
    if (notes == null || notes.isEmpty) {
      return null; // Empty notes are valid
    }
    
    if (notes.length > 500) {
      return RecipeValidationError(
        field: 'personalNotes',
        message: 'Note is too long (maximum 500 characters)',
        value: notes,
      );
    }
    
    // Check for potentially harmful content
    if (notes.contains(RegExp(r'<script|javascript:|data:', caseSensitive: false))) {
      return const RecipeValidationError(
        field: 'personalNotes',
        message: 'Note contains invalid content',
      );
    }
    
    return null;
  }

  /// Validate meal plan date
  RecipeValidationError? validateMealPlanDate(DateTime date) {
    final now = DateTime.now();
    final daysDifference = date.difference(now).inDays;
    
    // Allow dates from 7 days ago to 1 year in the future
    if (daysDifference < -7) {
      return RecipeValidationError(
        field: 'mealPlanDate',
        message: 'Date cannot be more than 7 days in the past',
        value: date,
      );
    }
    
    if (daysDifference > 365) {
      return RecipeValidationError(
        field: 'mealPlanDate',
        message: 'Date cannot be more than 1 year in the future',
        value: date,
      );
    }
    
    return null;
  }

  /// Validate recipe ID format
  RecipeValidationError? validateRecipeId(String recipeId) {
    if (recipeId.isEmpty) {
      return const RecipeValidationError(
        field: 'recipeId',
        message: 'Recipe ID cannot be empty',
      );
    }
    
    if (recipeId.length > 50) {
      return const RecipeValidationError(
        field: 'recipeId',
        message: 'Recipe ID is too long',
      );
    }
    
    // Check for valid ID format (alphanumeric, hyphens, underscores)
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(recipeId)) {
      return const RecipeValidationError(
        field: 'recipeId',
        message: 'Recipe ID contains invalid characters',
      );
    }
    
    return null;
  }

  /// Validate user ID format
  RecipeValidationError? validateUserId(String userId) {
    if (userId.isEmpty) {
      return const RecipeValidationError(
        field: 'userId',
        message: 'User ID cannot be empty',
      );
    }
    
    if (userId.length > 100) {
      return const RecipeValidationError(
        field: 'userId',
        message: 'User ID is too long',
      );
    }
    
    return null;
  }

  /// Sanitize text input to prevent XSS and other issues
  String sanitizeTextInput(String input) {
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'javascript:', caseSensitive: false), '') // Remove javascript:
        .replaceAll(RegExp(r'data:', caseSensitive: false), '') // Remove data:
        .trim();
  }

  /// Validate and sanitize search query
  String? validateAndSanitizeSearchQuery(String query) {
    final error = validateSearchQuery(query);
    if (error != null) {
      throw error;
    }
    
    return sanitizeTextInput(query);
  }

  /// Validate and sanitize personal notes
  String? validateAndSanitizePersonalNotes(String? notes) {
    if (notes == null) return null;
    
    final error = validatePersonalNotes(notes);
    if (error != null) {
      throw error;
    }
    
    return sanitizeTextInput(notes);
  }

  /// Check if a date is valid for meal planning
  bool isValidMealPlanDate(DateTime date) {
    return validateMealPlanDate(date) == null;
  }

  /// Get suggested date range for meal planning
  DateRange getValidMealPlanDateRange() {
    final now = DateTime.now();
    return DateRange(
      start: now.subtract(const Duration(days: 7)),
      end: now.add(const Duration(days: 365)),
    );
  }

  /// Validate batch operations
  List<RecipeValidationError> validateBatchOperation(
    List<String> recipeIds,
    String operation,
  ) {
    final errors = <RecipeValidationError>[];
    
    if (recipeIds.isEmpty) {
      errors.add(RecipeValidationError(
        field: 'recipeIds',
        message: 'No recipes provided for $operation',
      ));
      return errors;
    }
    
    if (recipeIds.length > 50) {
      errors.add(RecipeValidationError(
        field: 'recipeIds',
        message: 'Too many recipes for batch operation (maximum 50)',
        value: recipeIds.length,
      ));
    }
    
    for (int i = 0; i < recipeIds.length; i++) {
      final error = validateRecipeId(recipeIds[i]);
      if (error != null) {
        errors.add(RecipeValidationError(
          field: 'recipeIds[$i]',
          message: error.message,
          value: recipeIds[i],
        ));
      }
    }
    
    return errors;
  }
}

/// Date range class for validation
class DateRange {
  final DateTime start;
  final DateTime end;
  
  const DateRange({
    required this.start,
    required this.end,
  });
  
  bool contains(DateTime date) {
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
           date.isBefore(end.add(const Duration(days: 1)));
  }
  
  Duration get duration => end.difference(start);
}