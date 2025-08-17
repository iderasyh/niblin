// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_recommendation_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recipeRecommendationServiceHash() =>
    r'189cf328b4471121b8c28bff44e295af11265c27';

/// Service for generating recipe recommendations based on user history and baby stage
///
/// Copied from [RecipeRecommendationService].
@ProviderFor(RecipeRecommendationService)
final recipeRecommendationServiceProvider =
    AutoDisposeAsyncNotifierProvider<
      RecipeRecommendationService,
      List<Recipe>
    >.internal(
      RecipeRecommendationService.new,
      name: r'recipeRecommendationServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recipeRecommendationServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecipeRecommendationService = AutoDisposeAsyncNotifier<List<Recipe>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
