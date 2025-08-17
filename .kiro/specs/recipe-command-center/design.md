# Design Document

## Overview

The Recipe Command Center is designed as a comprehensive, multi-layered feature that transforms simple recipe viewing into an engaging, educational, and practical experience. The architecture follows a clean, modular approach using Flutter with Riverpod for state management, Firebase for data storage, and a centralized caching system for optimal performance.

The feature is built around the concept of making parents dependent on the app through emotional engagement, educational content, and practical utility. It provides age-appropriate recipes with detailed nutritional information, personalization features, and intelligent recommendations.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
├─────────────────────────────────────────────────────────────┤
│  Recipe List Screen  │  Recipe Detail Screen  │  Components │
│  - Category Filter   │  - Hero Section        │  - Cards    │
│  - Search & Filter   │  - Nutrition Info       │  - Badges   │
│  - Recipe Cards      │  - Instructions         │  - Buttons  │
│                      │  - Personal Notes       │             │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer                        │
├─────────────────────────────────────────────────────────────┤
│  Recipe Controller   │  User Recipe Controller │  Cache Mgmt │
│  - CRUD Operations   │  - Personal Notes       │  - Strategy │
│  - Search & Filter   │  - Favorites            │  - Policies │
│  - Recommendations   │  - Meal Planning        │             │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                           │
├─────────────────────────────────────────────────────────────┤
│  Recipe Entity       │  User Recipe Data       │  Enums      │
│  - Core Properties   │  - Personal Data        │  - Category │
│  - Nutritional Info  │  - Preferences          │  - Stage    │
│  - Multi-language    │  - Progress Tracking    │  - Units    │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                            │
├─────────────────────────────────────────────────────────────┤
│  Firebase Repository │  Cache Service          │  Local Data │
│  - Recipe CRUD       │  - Performance          │  - Offline  │
│  - User Data         │  - Multi-level Cache    │  - Sync     │
│  - Multi-language    │  - Invalidation         │             │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **Recipe Loading**: Repository → Cache → Controller → UI
2. **User Interactions**: UI → Controller → Repository → Firebase
3. **Personalization**: User Data → Controller → Personalized UI
4. **Offline Support**: Cache → Local Storage → Sync on Connection

## Components and Interfaces

### Core Domain Models

#### Recipe Model
```dart
class Recipe {
  final String id;
  final Map<String, String> name; // Multi-language support
  final Map<String, String> description;
  final Category category;
  final List<BabyStage> supportedStages;
  final String imageUrl;
  final String? videoUrl;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final double parentRating;
  final NutritionalInfo nutritionalInfo;
  final Map<String, List<Ingredient>> ingredients; // Per language
  final Map<String, List<Instruction>> instructions; // Per language
  final Map<String, String> servingGuidance; // Per language
  final List<Allergen> allergens;
  final Map<String, String> storageInfo; // Per language
  final Map<String, List<String>> troubleshooting; // Per language
  final Map<String, String> whyKidsLoveThis; // Per language
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

#### User Recipe Data Model
```dart
class UserRecipeData {
  final String userId;
  final String recipeId;
  final bool isFavorite;
  final bool hasTried;
  final String? personalNotes;
  final DateTime? lastViewed;
  final DateTime? triedDate;
  final bool isInMealPlan;
  final DateTime? mealPlanDate;
  final int viewCount;
}
```

#### Nutritional Info Model
```dart
class NutritionalInfo {
  final int caloriesPerServing;
  final Map<String, double> vitamins; // Vitamin name -> amount
  final Map<String, double> minerals; // Mineral name -> amount
  final List<DevelopmentBenefit> developmentBenefits;
  final Map<String, String> benefitExplanations; // Per language
  final Map<String, String> funFacts; // Per language
}
```

### Repository Interfaces

#### Recipe Repository
```dart
abstract class RecipeRepository {
  Future<List<Recipe>> getRecipesByCategory(Category category, {String? language});
  Future<List<Recipe>> getRecipesByStage(BabyStage stage, {String? language});
  Future<Recipe?> getRecipeById(String id, {String? language});
  Future<List<Recipe>> searchRecipes(String query, {String? language});
  Future<List<Recipe>> getRecommendedRecipes(String userId, {String? language});
  Stream<List<Recipe>> watchRecipesByCategory(Category category);
}
```

#### User Recipe Repository
```dart
abstract class UserRecipeRepository {
  Future<UserRecipeData?> getUserRecipeData(String userId, String recipeId);
  Future<void> updateUserRecipeData(UserRecipeData data);
  Future<List<String>> getFavoriteRecipeIds(String userId);
  Future<List<String>> getTriedRecipeIds(String userId);
  Future<void> addToMealPlan(String userId, String recipeId, DateTime date);
}
```

### Controller Architecture

#### Recipe Controller
```dart
@riverpod
class RecipeController extends _$RecipeController {
  Future<List<Recipe>> getRecipesByCategory(Category category) async {
    // Check cache first
    final cached = ref.read(cacheServiceProvider).getWithSuffix(
      CacheKey.recipesByCategory, 
      category.name
    );
    
    if (cached != null) return cached;
    
    // Fetch from repository
    final recipes = await ref.read(recipeRepositoryProvider)
        .getRecipesByCategory(category);
    
    // Cache results
    ref.read(cacheServiceProvider.notifier).setWithSuffix(
      CacheKey.recipesByCategory, 
      category.name, 
      recipes
    );
    
    return recipes;
  }
}
```

### UI Component Architecture

#### Recipe Card Component
```dart
class RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          RecipeImageWidget(recipe.imageUrl),
          RecipeInfoSection(recipe),
          RecipeActionsRow(recipe),
        ],
      ),
    );
  }
}
```

#### Recipe Detail Screen Structure
```dart
class RecipeDetailScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          RecipeHeroSection(),
          NutritionalSnapshotSection(),
          ServingGuidanceSection(),
          IngredientsSection(),
          InstructionsSection(),
          PersonalizationSection(),
          RecommendationsSection(),
        ],
      ),
    );
  }
}
```

## Data Models

### Enums and Constants

```dart
enum Category {
  breakfast,
  lunch,
  dinner,
  snacks,
  desserts,
  drinks,
}

// Note: Allergen enum is imported from existing onboarding feature
// lib/src/features/onboarding/domain/allergen.dart

enum BabyStage {
  stage1(4, 6, 'Stage 1: 4-6 months'),
  stage2(6, 8, 'Stage 2: 6-8 months'),
  stage3(8, 12, 'Stage 3: 8-12 months'),
  toddler(12, 24, 'Toddler: 12-24 months');
  
  const BabyStage(this.minMonths, this.maxMonths, this.displayName);
  final int minMonths;
  final int maxMonths;
  final String displayName;
}

enum DevelopmentBenefit {
  brainDevelopment,
  immunity,
  digestiveHealth,
  boneGrowth,
  eyeHealth,
}

enum MeasurementUnit {
  metric,
  imperial,
}
```

### Firebase Data Structure

```
recipes/
├── {recipeId}/
│   ├── id: string
│   ├── name: Map<string, string> // {en: "Banana Oat Porridge", sq: "Tërshërë me Banane"}
│   ├── description: Map<string, string>
│   ├── category: string
│   ├── supportedStages: string[]
│   ├── imageUrl: string
│   ├── videoUrl?: string
│   ├── prepTimeMinutes: number
│   ├── cookTimeMinutes: number
│   ├── servings: number
│   ├── parentRating: number
│   ├── nutritionalInfo: {
│   │   ├── caloriesPerServing: number
│   │   ├── vitamins: Map<string, number>
│   │   ├── minerals: Map<string, number>
│   │   ├── developmentBenefits: string[]
│   │   ├── benefitExplanations: Map<string, string>
│   │   └── funFacts: Map<string, string>
│   │   }
│   ├── ingredients: Map<string, Ingredient[]> // Per language
│   ├── instructions: Map<string, Instruction[]> // Per language
│   ├── servingGuidance: Map<string, string>
│   ├── allergens: string[] // Stored as enum names, converted to Allergen enum
│   ├── storageInfo: Map<string, string>
│   ├── troubleshooting: Map<string, string[]>
│   ├── whyKidsLoveThis: Map<string, string>
│   ├── createdAt: timestamp
│   └── updatedAt: timestamp

userRecipeData/
├── {userId}/
│   └── {recipeId}/
│       ├── isFavorite: boolean
│       ├── hasTried: boolean
│       ├── personalNotes?: string
│       ├── lastViewed?: timestamp
│       ├── triedDate?: timestamp
│       ├── isInMealPlan: boolean
│       ├── mealPlanDate?: timestamp
│       └── viewCount: number
```

## Error Handling

### Error Types and Handling Strategy

```dart
sealed class RecipeError {
  const RecipeError();
}

class NetworkError extends RecipeError {
  final String message;
  const NetworkError(this.message);
}

class CacheError extends RecipeError {
  final String message;
  const CacheError(this.message);
}

class ValidationError extends RecipeError {
  final String field;
  final String message;
  const ValidationError(this.field, this.message);
}
```

### Error Recovery Mechanisms

1. **Network Failures**: Fallback to cached data with user notification
2. **Cache Misses**: Graceful degradation with loading states
3. **Data Validation**: User-friendly error messages with retry options
4. **Image Loading**: Progressive loading with placeholders and retry

### Offline Support Strategy

1. **Critical Data Caching**: Recently viewed recipes, favorites, personal notes
2. **Image Caching**: Progressive caching of recipe images
3. **Sync Strategy**: Background sync when connection restored
4. **Conflict Resolution**: Last-write-wins for user data, merge for favorites

## Testing Strategy

### Unit Testing

1. **Domain Models**: Serialization, validation, business logic
2. **Repositories**: Data fetching, caching, error handling
3. **Controllers**: State management, user interactions
4. **Utilities**: Helper functions, formatters, validators

### Integration Testing

1. **Repository Integration**: Firebase operations, cache integration
2. **Controller Integration**: End-to-end data flow
3. **UI Integration**: User interactions, navigation flow

### Widget Testing

1. **Recipe Cards**: Display, interactions, state changes
2. **Recipe Detail Screen**: Sections, scrolling, user actions
3. **Search and Filter**: Input handling, results display

### Performance Testing

1. **Cache Performance**: Hit rates, memory usage
2. **Image Loading**: Load times, memory management
3. **List Performance**: Scrolling, large datasets
4. **Offline Performance**: Data availability, sync efficiency

## Localization Strategy

### Multi-language Content Storage

1. **Database Structure**: Language-keyed maps for all text content
2. **Fallback Strategy**: Default to English if translation unavailable
3. **Dynamic Loading**: Load content based on user's locale setting
4. **Content Management**: Structured approach for adding new languages

### Implementation Approach

```dart
class LocalizedContent {
  static String getLocalizedText(
    Map<String, String> content, 
    String locale, 
    {String fallback = 'en'}
  ) {
    return content[locale] ?? content[fallback] ?? content.values.first;
  }
}
```

## Performance Optimization

### Caching Strategy

1. **Multi-level Caching**: Memory cache → Local storage → Network
2. **Cache Invalidation**: Time-based and event-based invalidation
3. **Preloading**: Intelligent preloading of likely-needed content
4. **Memory Management**: LRU eviction, size limits

### Image Optimization

1. **Progressive Loading**: Placeholder → Low-res → High-res
2. **Format Optimization**: WebP with fallbacks
3. **Lazy Loading**: Load images as they enter viewport
4. **Caching**: Persistent image cache with size management

### List Performance

1. **Pagination**: Load recipes in chunks
2. **Virtual Scrolling**: For large recipe lists
3. **Optimistic Updates**: Immediate UI updates with background sync
4. **Debounced Search**: Reduce API calls during search

This design provides a comprehensive, scalable foundation for the Recipe Command Center feature that aligns with the existing app architecture while delivering the engaging, educational experience described in the requirements.