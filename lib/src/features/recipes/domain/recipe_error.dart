/// Recipe-specific error types and handling
sealed class RecipeError implements Exception {
  const RecipeError();
  
  /// Get user-friendly error message
  String getMessage(String languageCode);
  
  /// Get error code for analytics/debugging
  String get errorCode;
  
  /// Whether this error should be retried
  bool get isRetryable;
  
  /// Whether to show cached data if available
  bool get shouldShowCachedData;
}

/// Network-related errors
class RecipeNetworkError extends RecipeError {
  const RecipeNetworkError({
    this.message = 'Network connection failed',
    this.statusCode,
  });
  
  final String message;
  final int? statusCode;
  
  @override
  String getMessage(String languageCode) {
    switch (languageCode) {
      case 'sq':
        return 'Gabim rrjeti. Ju lutemi kontrolloni lidhjen tuaj.';
      default:
        return 'Network error. Please check your connection.';
    }
  }
  
  @override
  String get errorCode => 'RECIPE_NETWORK_ERROR';
  
  @override
  bool get isRetryable => true;
  
  @override
  bool get shouldShowCachedData => true;
  
  @override
  String toString() => 'RecipeNetworkError: $message (status: $statusCode)';
}

/// Recipe not found error
class RecipeNotFoundError extends RecipeError {
  const RecipeNotFoundError({
    required this.recipeId,
    this.message = 'Recipe not found',
  });
  
  final String recipeId;
  final String message;
  
  @override
  String getMessage(String languageCode) {
    switch (languageCode) {
      case 'sq':
        return 'Receta nuk u gjet';
      default:
        return 'Recipe not found';
    }
  }
  
  @override
  String get errorCode => 'RECIPE_NOT_FOUND';
  
  @override
  bool get isRetryable => false;
  
  @override
  bool get shouldShowCachedData => false;
  
  @override
  String toString() => 'RecipeNotFoundError: $message (id: $recipeId)';
}

/// Cache-related errors
class RecipeCacheError extends RecipeError {
  const RecipeCacheError({
    this.message = 'Cache operation failed',
    this.operation = 'unknown',
  });
  
  final String message;
  final String operation;
  
  @override
  String getMessage(String languageCode) {
    switch (languageCode) {
      case 'sq':
        return 'Gabim në ruajtjen e të dhënave. Provo përsëri.';
      default:
        return 'Data storage error. Please try again.';
    }
  }
  
  @override
  String get errorCode => 'RECIPE_CACHE_ERROR';
  
  @override
  bool get isRetryable => true;
  
  @override
  bool get shouldShowCachedData => false;
  
  @override
  String toString() => 'RecipeCacheError: $message (operation: $operation)';
}

/// Validation errors for user input
class RecipeValidationError extends RecipeError {
  const RecipeValidationError({
    required this.field,
    required this.message,
    this.value,
  });
  
  final String field;
  final String message;
  final dynamic value;
  
  @override
  String getMessage(String languageCode) {
    switch (field) {
      case 'personalNotes':
        switch (languageCode) {
          case 'sq':
            return 'Shënimi është shumë i gjatë (maksimumi 500 karaktere)';
          default:
            return 'Note is too long (maximum 500 characters)';
        }
      case 'searchQuery':
        switch (languageCode) {
          case 'sq':
            return 'Kërkimi duhet të ketë të paktën 2 karaktere';
          default:
            return 'Search must be at least 2 characters';
        }
      case 'mealPlanDate':
        switch (languageCode) {
          case 'sq':
            return 'Data e planit të vakteve nuk është e vlefshme';
          default:
            return 'Meal plan date is not valid';
        }
      default:
        return message;
    }
  }
  
  @override
  String get errorCode => 'RECIPE_VALIDATION_ERROR';
  
  @override
  bool get isRetryable => false;
  
  @override
  bool get shouldShowCachedData => false;
  
  @override
  String toString() => 'RecipeValidationError: $message (field: $field, value: $value)';
}

/// Data parsing/serialization errors
class RecipeDataError extends RecipeError {
  const RecipeDataError({
    this.message = 'Data format error',
    this.field,
  });
  
  final String message;
  final String? field;
  
  @override
  String getMessage(String languageCode) {
    switch (languageCode) {
      case 'sq':
        return 'Gabim në formatimin e të dhënave. Provo përsëri.';
      default:
        return 'Data format error. Please try again.';
    }
  }
  
  @override
  String get errorCode => 'RECIPE_DATA_ERROR';
  
  @override
  bool get isRetryable => true;
  
  @override
  bool get shouldShowCachedData => true;
  
  @override
  String toString() => 'RecipeDataError: $message (field: $field)';
}

/// Permission/authentication errors
class RecipePermissionError extends RecipeError {
  const RecipePermissionError({
    this.message = 'Permission denied',
    this.operation = 'unknown',
  });
  
  final String message;
  final String operation;
  
  @override
  String getMessage(String languageCode) {
    switch (languageCode) {
      case 'sq':
        return 'Nuk keni leje për këtë veprim. Ju lutemi identifikohuni përsëri.';
      default:
        return 'Permission denied. Please sign in again.';
    }
  }
  
  @override
  String get errorCode => 'RECIPE_PERMISSION_ERROR';
  
  @override
  bool get isRetryable => false;
  
  @override
  bool get shouldShowCachedData => true;
  
  @override
  String toString() => 'RecipePermissionError: $message (operation: $operation)';
}

/// Content missing/incomplete errors
class RecipeContentError extends RecipeError {
  const RecipeContentError({
    this.message = 'Recipe content is incomplete',
    this.missingFields = const [],
  });
  
  final String message;
  final List<String> missingFields;
  
  @override
  String getMessage(String languageCode) {
    switch (languageCode) {
      case 'sq':
        return 'Përmbajtja e recetës është e paplotë. Po shfaqet ajo që është e disponueshme.';
      default:
        return 'Recipe content is incomplete. Showing available information.';
    }
  }
  
  @override
  String get errorCode => 'RECIPE_CONTENT_ERROR';
  
  @override
  bool get isRetryable => true;
  
  @override
  bool get shouldShowCachedData => true;
  
  @override
  String toString() => 'RecipeContentError: $message (missing: ${missingFields.join(', ')})';
}

/// Generic recipe operation errors
class RecipeOperationError extends RecipeError {
  const RecipeOperationError({
    required this.operation,
    this.message = 'Operation failed',
    this.originalError,
  });
  
  final String operation;
  final String message;
  final Object? originalError;
  
  @override
  String getMessage(String languageCode) {
    switch (operation) {
      case 'favorite':
        switch (languageCode) {
          case 'sq':
            return 'Gabim në ruajtjen e të preferuarës. Provo përsëri.';
          default:
            return 'Failed to save favorite. Please try again.';
        }
      case 'mealPlan':
        switch (languageCode) {
          case 'sq':
            return 'Gabim në shtimin në planin e vakteve. Provo përsëri.';
          default:
            return 'Failed to add to meal plan. Please try again.';
        }
      case 'notes':
        switch (languageCode) {
          case 'sq':
            return 'Gabim në ruajtjen e shënimit. Provo përsëri.';
          default:
            return 'Failed to save note. Please try again.';
        }
      default:
        switch (languageCode) {
          case 'sq':
            return 'Diçka shkoi gabim. Provo përsëri.';
          default:
            return 'Something went wrong. Please try again.';
        }
    }
  }
  
  @override
  String get errorCode => 'RECIPE_OPERATION_ERROR';
  
  @override
  bool get isRetryable => true;
  
  @override
  bool get shouldShowCachedData => false;
  
  @override
  String toString() => 'RecipeOperationError: $message (operation: $operation, original: $originalError)';
}

/// Utility class for error handling
class RecipeErrorHandler {
  /// Convert generic exceptions to RecipeError
  static RecipeError fromException(Exception exception, {String? context}) {
    if (exception is RecipeError) {
      return exception;
    }
    
    final message = exception.toString();
    
    // Network-related errors
    if (message.contains('SocketException') || 
        message.contains('TimeoutException') ||
        message.contains('NetworkException')) {
      return RecipeNetworkError(message: message);
    }
    
    // Firebase-specific errors
    if (message.contains('permission-denied')) {
      return RecipePermissionError(
        message: message,
        operation: context ?? 'unknown',
      );
    }
    
    if (message.contains('not-found')) {
      return RecipeNotFoundError(
        recipeId: context ?? 'unknown',
        message: message,
      );
    }
    
    // Data format errors
    if (message.contains('FormatException') || 
        message.contains('type') ||
        message.contains('cast')) {
      return RecipeDataError(message: message);
    }
    
    // Default to operation error
    return RecipeOperationError(
      operation: context ?? 'unknown',
      message: message,
      originalError: exception,
    );
  }
  
  /// Get appropriate fallback content for errors
  static Map<String, dynamic> getFallbackContent(RecipeError error, String languageCode) {
    switch (error) {
      case RecipeNotFoundError _:
        return {
          'title': languageCode == 'sq' ? 'Receta nuk u gjet' : 'Recipe not found',
          'message': error.getMessage(languageCode),
          'showRetry': false,
          'showCached': false,
        };
      case RecipeNetworkError _:
        return {
          'title': languageCode == 'sq' ? 'Gabim rrjeti' : 'Network Error',
          'message': error.getMessage(languageCode),
          'showRetry': true,
          'showCached': error.shouldShowCachedData,
        };
      case RecipeValidationError _:
        return {
          'title': languageCode == 'sq' ? 'Gabim validimi' : 'Validation Error',
          'message': error.getMessage(languageCode),
          'showRetry': false,
          'showCached': false,
        };
      default:
        return {
          'title': languageCode == 'sq' ? 'Gabim' : 'Error',
          'message': error.getMessage(languageCode),
          'showRetry': error.isRetryable,
          'showCached': error.shouldShowCachedData,
        };
    }
  }
}