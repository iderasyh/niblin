# Implementation Plan

- [x] 1. Set up core domain models and enums

  - Create Recipe domain model with multi-language support and nutritional information using traditional class approach (no freezed package)
  - Create UserRecipeData model for personalization features following existing User/BabyProfile pattern with manual copyWith, toMap, fromMap methods
  - Create NutritionalInfo and related models for health benefits tracking using traditional class structure
  - Create Category and BabyStage enums with localized display names
  - Write unit tests for all domain models including serialization and validation
  - _Requirements: 1.1, 1.2, 1.3, 7.1, 7.2_

- [x] 2. Implement Firebase repository layer

  - [x] 2.1 Create recipe repository interface and Firebase implementation

    - Define RecipeRepository abstract class with all CRUD operations
    - Implement FirebaseRecipeRepository with Firestore integration
    - Add multi-language content fetching with fallback logic
    - Implement caching integration using existing CacheService
    - Write unit tests for repository operations and error handling
    - _Requirements: 1.1, 7.1, 7.2, 8.1, 8.2_

  - [x] 2.2 Create user recipe data repository
    - Define UserRecipeRepository interface for personal data management
    - Implement Firebase operations for favorites, notes, and meal planning
    - Add conflict resolution for concurrent updates
    - Write unit tests for user data operations
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [x] 3. Create recipe controllers with Riverpod

  - [x] 3.1 Implement recipe list controller

    - Create RecipeListController with category and stage filtering
    - Implement search functionality with debounced queries
    - Add pagination support for large recipe collections
    - Integrate with CacheService for performance optimization
    - Write unit tests for controller state management
    - _Requirements: 6.1, 6.2, 6.3, 8.1, 8.3_

  - [x] 3.2 Implement recipe detail controller

    - Create RecipeDetailController for single recipe management
    - Add stage-based variation switching logic
    - Implement recommendation engine integration
    - Add offline support with cached data fallback
    - Write unit tests for recipe detail operations
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 6.1, 8.2_

  - [x] 3.3 Create user recipe interaction controller
    - Implement UserRecipeController for favorites and notes management
    - Add meal planning functionality with date scheduling
    - Implement progress tracking for tried recipes
    - Add sharing functionality preparation
    - Write unit tests for user interaction features
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 6.3_

- [x] 4. Build core UI components

  - [x] 4.1 Create recipe card component

    - Build RecipeCard widget with image, title, and quick info
    - Add stage badges with color-coded styling using AppColors
    - Implement favorite button with heart animation
    - Add responsive design using ResponsiveUtils
    - Write widget tests for recipe card interactions
    - _Requirements: 1.1, 6.2, 8.3_

  - [x] 4.2 Create nutritional info components

    - Build NutritionalSnapshotWidget with vitamins and minerals display
    - Create DevelopmentBenefitIcons with educational tooltips
    - Add "Why It's Good" explanation section with localization
    - Implement fun facts display with engaging animations
    - Write widget tests for nutritional information display
    - _Requirements: 1.2, 9.1, 9.2, 9.4_

  - [x] 4.3 Build serving guidance components
    - Create ServingGuidanceWidget with texture consistency guide
    - Implement allergy warning badges with clear visual indicators
    - Add age-appropriate serving size calculator
    - Create texture progression visual guide
    - Write widget tests for serving guidance functionality
    - _Requirements: 1.3, 1.4, 9.3_

- [x] 5. Implement recipe list screen

  - [x] 5.1 Create recipe list screen structure

    - Build RecipeListScreen with category tabs and search bar
    - Implement pull-to-refresh functionality
    - Add loading states with LoadingIndicator from common widgets
    - Create empty state handling with engaging illustrations
    - Write widget tests for list screen navigation and interactions
    - _Requirements: 6.2, 6.3, 8.3_

  - [x] 5.2 Add filtering and search functionality
    - Implement category filter chips with active state styling
    - Add stage-based filtering with baby age integration
    - Create search functionality with real-time results
    - Add dietary restriction filtering using allergen data
    - Write widget tests for filtering and search operations
    - _Requirements: 6.2, 6.3, 1.4_

- [x] 6. Build recipe detail screen

  - [x] 6.1 Create hero section and basic layout

    - Build RecipeDetailScreen with CustomScrollView structure
    - Implement hero section with full-screen image and video support
    - Add recipe name, stage badge, and quick info row
    - Create parent rating display with star visualization
    - Write widget tests for hero section interactions
    - _Requirements: 1.1, 4.4_

  - [x] 6.2 Implement ingredients and instructions sections

    - Create IngredientsSection with category grouping
    - Add measurement unit toggle (US/Metric) functionality
    - Build substitution tips display with expandable cards
    - Implement InstructionsSection with step-by-step layout
    - Add cooking action icons and baby-specific note highlighting
    - Write widget tests for ingredients and instructions display
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 7.3_

  - [x] 6.3 Add stage variation and personalization features
    - Implement stage tabs for texture variations
    - Create personal notes section with text input and save functionality
    - Add storage and leftover information display
    - Build troubleshooting section with expandable tips
    - Write widget tests for personalization features
    - _Requirements: 4.1, 4.2, 4.3, 3.1, 3.2, 5.1, 5.2, 5.3_

- [x] 7. Implement user interaction features

  - [x] 7.1 Add favorite and meal planning functionality

    - Create favorite button with animation and state persistence
    - Implement "Add to Meal Plan" with date picker integration
    - Add "Mark as Tried" functionality with progress tracking
    - Create sharing preparation for partner/caregiver features
    - Write widget tests for user interaction buttons
    - _Requirements: 3.3, 3.4, 3.5, 6.3_

  - [x] 7.2 Build recommendation system
    - Implement "Next Suggested Recipe" section
    - Create recommendation algorithm based on stage and history
    - Add "Why Kids Love This" emotional trigger section
    - Build related recipes carousel with smooth scrolling
    - Write unit tests for recommendation logic
    - _Requirements: 6.1, 9.4_

- [x] 8. Add localization and multi-language support

  - [x] 8.1 Implement recipe content localization

    - Add recipe content translation support using existing l10n system
    - Implement language fallback logic for missing translations
    - Create localized content helper utilities
    - Add measurement unit conversion based on locale
    - Write unit tests for localization functionality
    - _Requirements: 7.1, 7.2, 7.3, 7.4_

  - [x] 8.2 Add UI text localization
    - Add all recipe-related strings to app_en.arb and app_sq.arb
    - Implement localized category and stage names
    - Add nutritional benefit descriptions in multiple languages
    - Create localized error messages and user feedback
    - Write tests for UI text localization
    - _Requirements: 7.1, 7.2, 7.4_

- [ ] 9. Implement caching and performance optimization

  - [x] 9.1 Add comprehensive caching strategy

    - Integrate recipe caching with existing CacheService
    - Implement multi-level caching for images and content
    - Add cache invalidation policies for data freshness
    - Create offline data persistence for critical recipes
    - Write unit tests for caching functionality
    - _Requirements: 8.1, 8.2, 8.3_

  - [x] 9.2 Optimize image loading and performance
    - Implement progressive image loading with placeholders
    - Add image caching with size management
    - Create lazy loading for recipe lists
    - Optimize memory usage for large image collections
    - Write performance tests for image loading
    - _Requirements: 8.3, 8.4_

- [ ] 10. Add navigation and routing integration

  - [x] 10.1 Integrate with existing app router

    - Add recipe routes to existing GoRouter configuration
    - Implement deep linking for individual recipes
    - Add navigation between recipe list and detail screens
    - Create proper route parameter handling for recipe IDs
    - Write integration tests for navigation flow
    - _Requirements: 6.1, 6.2, 6.3_

  - [x] 10.2 Add search and discovery navigation
    - Implement search results navigation
    - Add category-based navigation with proper state management
    - Create recommendation navigation flow
    - Add back navigation with proper state preservation
    - Write widget tests for navigation interactions
    - _Requirements: 6.2, 6.3_

- [x] 11. Implement error handling and edge cases

  - [x] 11.1 Add comprehensive error handling

    - Create recipe-specific error types and handling
    - Implement network error recovery with cached fallbacks
    - Add user-friendly error messages with retry options
    - Create graceful degradation for missing content
    - Use flutter analyze to check linter errors
    - _Requirements: 8.1, 8.2, 8.4_

  - [x] 11.2 Handle edge cases and validation
    - Add input validation for personal notes and search
    - Implement proper handling of missing recipe data
    - Add validation for meal planning date selection
    - Create fallback content for incomplete recipes
    - Use flutter analyze to check linter errors
    - _Requirements: 3.1, 3.2, 5.1, 7.2_

- [ ] 12. Write comprehensive tests and documentation

  - [ ] 12.1 Complete unit test coverage

    - Write unit tests for all domain models and business logic
    - Add unit tests for repository implementations
    - Create unit tests for controller state management
    - Add unit tests for utility functions and helpers
    - Achieve minimum 90% code coverage for recipe feature
    - _Requirements: All requirements_

  - [ ] 12.2 Add integration and widget tests
    - Write integration tests for complete user flows
    - Add widget tests for all custom components
    - Create integration tests for Firebase operations
    - Add performance tests for caching and image loading
    - Write end-to-end tests for critical user journeys
    - _Requirements: All requirements_
