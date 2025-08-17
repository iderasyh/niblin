import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';

/// Utility class for getting localized recipe user feedback messages
class RecipeFeedbackMessages {
  /// Get localized success message for adding to meal plan
  static String getMealPlanSuccess(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_meal_plan_success;
  }

  /// Get localized success message for adding to favorites
  static String getFavoriteAdded(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_favorite_added;
  }

  /// Get localized success message for removing from favorites
  static String getFavoriteRemoved(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_favorite_removed;
  }

  /// Get localized success message for marking as tried
  static String getTriedMarked(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_tried_marked;
  }

  /// Get localized success message for saving note
  static String getNoteSaved(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_note_saved;
  }

  /// Get localized add to favorites text
  static String getAddToFavorites(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_add_to_favorites;
  }

  /// Get localized remove from favorites text
  static String getRemoveFromFavorites(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_remove_from_favorites;
  }

  /// Get localized add to meal plan text
  static String getAddToMealPlan(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_add_to_meal_plan;
  }

  /// Get localized mark as tried text
  static String getMarkAsTried(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_mark_as_tried;
  }

  /// Get localized share recipe text
  static String getShareRecipe(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_share;
  }

  /// Get localized personal notes text
  static String getPersonalNotes(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_personal_notes;
  }

  /// Get localized add note placeholder text
  static String getAddNotePlaceholder(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_add_note;
  }

  /// Get localized save note text
  static String getSaveNote(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_save_note;
  }
}