import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../../../core/services/cache_service.dart';
import '../../onboarding/domain/baby_profile.dart';
import '../domain/baby_stage.dart';
import '../domain/category.dart';
import '../domain/recipe.dart';
import 'recipe_repository.dart';

part 'firebase_recipe_repository.g.dart';

/// Firebase implementation of RecipeRepository
class FirebaseRecipeRepository implements RecipeRepository {
  FirebaseRecipeRepository(this._firestore, this._cacheService, this._ref);

  final FirebaseFirestore _firestore;
  final CacheService _cacheService;
  final Ref _ref;

  CollectionReference<Map<String, dynamic>> get _recipesCollection =>
      _firestore.collection(FirebaseConsts.recipesCollection);

  @override
  Future<List<Recipe>> getRecipesByCategory(
    Category category, {
    String? language,
  }) async {
    try {
      final recipes = await getRecipesByStage();

      return recipes
          .where((recipe) => recipe.category.name == category.name)
          .toList();
    } catch (e) {
      throw RecipeRepositoryException('Failed to get recipes by category: $e');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByStage({String? language}) async {
    try {
      final stage = _getBabyStage();
      if (stage == null) {
        throw RecipeRepositoryException('Baby stage not found in cache');
      }
      // Check cache first
      final cacheKey = '${stage.name}_${language ?? 'default'}';
      final cached = _cacheService.getWithSuffix(
        CacheKey.recipesByStage,
        cacheKey,
      );
      if (cached != null && cached is List<Recipe>) {
        return cached;
      }

      final querySnapshot = await _recipesCollection
          .where(FirebaseConsts.supportedStagesField, arrayContains: stage.name)
          .orderBy(FirebaseConsts.createdAtField, descending: true)
          .get();

      final recipes = querySnapshot.docs
          .map((doc) => Recipe.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      // Cache the results
      _cacheService.setWithSuffix(CacheKey.recipesByStage, cacheKey, recipes);

      return recipes;
    } catch (e) {
      throw RecipeRepositoryException('Failed to get recipes by stage: $e');
    }
  }

  @override
  Future<List<Recipe>> getRecipesByCategoryAndStage(
    Category category, {
    String? language,
  }) async {
    try {
      final stage = _getBabyStage();
      if (stage == null) {
        throw RecipeRepositoryException('Baby stage not found in cache');
      }

      final recipes = await getRecipesByStage();

      return recipes
          .where((recipe) => recipe.category.name == category.name)
          .where(
            (recipe) => recipe.supportedStages.any(
              (element) => element.name == stage.name,
            ),
          )
          .toList();
    } catch (e) {
      throw RecipeRepositoryException(
        'Failed to get recipes by category and stage: $e',
      );
    }
  }

  @override
  Future<Recipe?> getRecipeById(String id, {String? language}) async {
    try {
      // Check cache first
      final cacheKey = '${id}_${language ?? 'default'}';
      final cached = _cacheService.getWithSuffix(CacheKey.recipeById, cacheKey);
      if (cached != null && cached is Recipe) {
        return cached;
      }

      final docSnapshot = await _recipesCollection.doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final recipe = Recipe.fromMap({
        ...docSnapshot.data()!,
        'id': docSnapshot.id,
      });

      // Cache the result
      _cacheService.setWithSuffix(CacheKey.recipeById, cacheKey, recipe);

      return recipe;
    } catch (e) {
      throw RecipeRepositoryException('Failed to get recipe by ID: $e');
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query, {String? language}) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Get all recipes and filter client-side for better search functionality
      // In a production app, you might want to use Algolia or similar for better search
      final allRecipes = await getRecipesByStage(language: language);

      final searchQuery = query.toLowerCase();
      final filteredRecipes = allRecipes.where((recipe) {
        final name = recipe.getLocalizedName(language ?? 'en').toLowerCase();
        final description = recipe
            .getLocalizedDescription(language ?? 'en')
            .toLowerCase();

        return name.contains(searchQuery) || description.contains(searchQuery);
      }).toList();

      return filteredRecipes;
    } catch (e) {
      throw RecipeRepositoryException('Failed to search recipes: $e');
    }
  }

  @override
  Future<List<Recipe>> getRecommendedRecipes(
    String userId, {
    String? language,
  }) async {
    try {
      // TODO: WILL MAKE A RECOMMENDATION ALGORITHM BEFORE PUBLISHING

      // Simple recommendation algorithm: get highly rated recipes
      // In a production app, this would be more sophisticated
      final querySnapshot = await _recipesCollection
          .where(FirebaseConsts.parentRatingField, isGreaterThanOrEqualTo: 4.0)
          .orderBy(FirebaseConsts.parentRatingField, descending: true)
          .orderBy(FirebaseConsts.createdAtField, descending: true)
          .limit(10)
          .get();

      final recipes = querySnapshot.docs
          .map((doc) => Recipe.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      return recipes;
    } catch (e) {
      throw RecipeRepositoryException('Failed to get recommended recipes: $e');
    }
  }

  @override
  Stream<List<Recipe>> watchRecipesByCategory(
    Category category,
    BabyStage stage,
  ) {
    return _recipesCollection
        .where(FirebaseConsts.categoryField, isEqualTo: category.name)
        .where(FirebaseConsts.supportedStagesField, arrayContains: stage.name)
        .orderBy(FirebaseConsts.createdAtField, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Recipe.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        )
        .handleError((error) {
          throw RecipeRepositoryException(
            'Failed to watch recipes by category: $error',
          );
        });
  }

  @override
  Stream<List<Recipe>> watchRecipesByStage(BabyStage stage) {
    return _recipesCollection
        .where(FirebaseConsts.supportedStagesField, arrayContains: stage.name)
        .orderBy(FirebaseConsts.createdAtField, descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Recipe.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        )
        .handleError((error) {
          throw RecipeRepositoryException(
            'Failed to watch recipes by stage: $error',
          );
        });
  }

  @override
  Stream<Recipe?> watchRecipeById(String id) {
    return _recipesCollection
        .doc(id)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return Recipe.fromMap({...snapshot.data()!, 'id': snapshot.id});
        })
        .handleError((error) {
          throw RecipeRepositoryException(
            'Failed to watch recipe by ID: $error',
          );
        });
  }

  BabyStage? _getBabyStage() {
    // Get cached baby model
    final cachedValues = _ref.read(cacheServiceProvider);
    final baby = cachedValues[CacheKey.babyProfile.name] as BabyProfile?;
    if (baby == null) {
      throw RecipeRepositoryException('Baby not found in cache');
    }
    return baby.currentStage;
  }

  /// Clear all recipe-related cache
  void clearCache() {
    _cacheService.clearByKeyPrefix(CacheKey.recipesByStage);
    _cacheService.clearByKeyPrefix(CacheKey.recipeById);
  }
}

/// Exception thrown by recipe repository operations
class RecipeRepositoryException implements Exception {
  const RecipeRepositoryException(this.message);
  final String message;

  @override
  String toString() => 'RecipeRepositoryException: $message';
}

@riverpod
FirebaseRecipeRepository recipeRepository(Ref ref) {
  return FirebaseRecipeRepository(
    FirebaseFirestore.instance,
    ref.read(cacheServiceProvider.notifier),
    ref,
  );
}
