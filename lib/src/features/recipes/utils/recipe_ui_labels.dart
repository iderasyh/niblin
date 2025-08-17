import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';

/// Utility class for getting localized recipe UI labels
class RecipeUILabels {
  /// Get localized prep time label
  static String getPrepTime(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_prep_time;
  }

  /// Get localized cook time label
  static String getCookTime(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_cook_time;
  }

  /// Get localized total time label
  static String getTotalTime(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_total_time;
  }

  /// Get localized servings label
  static String getServings(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_servings;
  }

  /// Get localized rating label
  static String getRating(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_rating;
  }

  /// Get localized minutes abbreviation
  static String getMinutes(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_minutes;
  }

  /// Get localized portions label
  static String getPortions(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_portions;
  }

  /// Get localized ingredients label
  static String getIngredients(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_ingredients;
  }

  /// Get localized instructions label
  static String getInstructions(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_instructions;
  }

  /// Get localized serving guidance label
  static String getServingGuidance(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_serving_guidance;
  }

  /// Get localized storage info label
  static String getStorageInfo(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_storage_info;
  }

  /// Get localized troubleshooting label
  static String getTroubleshooting(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_troubleshooting;
  }

  /// Get localized "why kids love this" label
  static String getWhyKidsLoveThis(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_why_kids_love_this;
  }

  /// Get localized nutritional info label
  static String getNutritionalInfo(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_nutritional_info;
  }

  /// Get localized development benefits label
  static String getDevelopmentBenefits(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_development_benefits;
  }

  /// Get localized fun facts label
  static String getFunFacts(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_fun_facts;
  }

  /// Get localized search hint
  static String getSearchHint(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_search_hint;
  }

  /// Get localized filter by category label
  static String getFilterByCategory(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_filter_by_category;
  }

  /// Get localized filter by stage label
  static String getFilterByStage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_filter_by_stage;
  }

  /// Get localized filter by allergens label
  static String getFilterByAllergens(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_filter_by_allergens;
  }

  /// Get localized clear filters label
  static String getClearFilters(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_clear_filters;
  }

  /// Get localized next suggested recipe label
  static String getNextSuggested(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_next_suggested;
  }

  /// Get localized related recipes label
  static String getRelatedRecipes(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_related_recipes;
  }

  /// Get localized recommended for you label
  static String getRecommendedForYou(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_recommended_for_you;
  }

  /// Get localized calories per serving label
  static String getCaloriesPerServing(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_calories_per_serving;
  }

  /// Get localized vitamins label
  static String getVitamins(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_vitamins;
  }

  /// Get localized minerals label
  static String getMinerals(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_minerals;
  }

  /// Get localized stage variations label
  static String getStageVariations(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_stage_variations;
  }

  /// Get localized texture guide label
  static String getTextureGuide(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_texture_guide;
  }

  /// Get localized allergy warning label
  static String getAllergyWarning(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_allergy_warning;
  }

  /// Get localized substitutions label
  static String getSubstitutions(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_substitutions;
  }

  /// Get localized unit toggle label
  static String getUnitToggle(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_unit_toggle;
  }

  /// Get localized metric units label
  static String getMetricUnits(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_metric_units;
  }

  /// Get localized imperial units label
  static String getImperialUnits(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_imperial_units;
  }
}