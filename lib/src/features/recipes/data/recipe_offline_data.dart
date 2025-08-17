import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/shared_preferences_provider.dart';
import '../domain/recipe.dart';
import '../domain/user_recipe_data.dart';

part 'recipe_offline_data.g.dart';

class RecipeOfflineData {
  const RecipeOfflineData(this.ref);

  final Ref ref;

  SharedPreferencesProvider get _sharedPreferences =>
      ref.read(getSharedPreferencesProvider);

  Future<void> storeRecipesOffline(List<Recipe> recipes) async {
    final recipesJson = recipes.map((recipe) => recipe.toMap()).toList();
    final jsonString = jsonEncode(recipesJson);

    await _sharedPreferences.saveString(
      SharedPreferencesKeys.recipes.name,
      jsonString,
    );
  }

  List<Recipe> getRecipes() {
    final jsonString = _sharedPreferences.getString(
      SharedPreferencesKeys.recipes.name,
    );

    if (jsonString == null) {
      return [];
    }

    final recipesJson = jsonDecode(jsonString) as List<dynamic>;
    final recipes = recipesJson.map((json) => Recipe.fromMap(json)).toList();

    return recipes;
  }

  Future<void> storeUserRecipesOffline(UserRecipeData userRecipe) async {
    final userRecipes = getUserRecipes();
    userRecipes.add(userRecipe);
    await _storeUserRecipesOffline(userRecipes);
  }

  Future<void> _storeUserRecipesOffline(
    List<UserRecipeData> userRecipes,
  ) async {
    final userRecipesJson = userRecipes
        .map((userRecipe) => userRecipe.toMap())
        .toList();
    final jsonString = jsonEncode(userRecipesJson);

    await _sharedPreferences.saveString(
      SharedPreferencesKeys.userRecipesData.name,
      jsonString,
    );
  }

  List<UserRecipeData> getUserRecipes() {
    final jsonString = _sharedPreferences.getString(
      SharedPreferencesKeys.userRecipesData.name,
    );

    if (jsonString == null) {
      return [];
    }

    final userRecipesJson = jsonDecode(jsonString) as List<dynamic>;
    final userRecipes = userRecipesJson
        .map((json) => UserRecipeData.fromMap(json))
        .toList();

    return userRecipes;
  }
}

@riverpod
RecipeOfflineData recipeOfflineData(Ref ref) {
  return RecipeOfflineData(ref);
}
