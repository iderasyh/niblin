import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';

/// Utility class for getting localized recipe error messages
class RecipeErrorMessages {
  /// Get localized error message for recipe loading failure
  static String getLoadingError(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_error_loading;
  }

  /// Get localized error message for recipe not found
  static String getNotFoundError(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_error_not_found;
  }

  /// Get localized error message for network issues
  static String getNetworkError(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_error_network;
  }

  /// Get localized "try again" message
  static String getTryAgainMessage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_error_try_again;
  }

  /// Get localized offline message
  static String getOfflineMessage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_offline_message;
  }

  /// Get localized empty state title
  static String getEmptyStateTitle(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_empty_state_title;
  }

  /// Get localized empty state message
  static String getEmptyStateMessage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_empty_state_message;
  }

  /// Get localized empty favorites title
  static String getEmptyFavoritesTitle(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_empty_favorites_title;
  }

  /// Get localized empty favorites message
  static String getEmptyFavoritesMessage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_empty_favorites_message;
  }

  /// Get localized loading message
  static String getLoadingMessage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_loading;
  }

  /// Get localized pull to refresh message
  static String getPullToRefreshMessage(BuildContext context) {
    return AppLocalizations.of(context)!.recipe_pull_to_refresh;
  }
}