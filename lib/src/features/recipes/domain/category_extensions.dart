import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import 'category.dart';

/// Extension to provide localized names for Category enum
extension CategoryLocalization on Category {
  /// Get localized display name for the category
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (this) {
      case Category.breakfast:
        return l10n.category_breakfast;
      case Category.lunch:
        return l10n.category_lunch;
      case Category.dinner:
        return l10n.category_dinner;
      case Category.snacks:
        return l10n.category_snacks;
      case Category.desserts:
        return l10n.category_desserts;
      case Category.drinks:
        return l10n.category_drinks;
    }
  }

  /// Get localized display name without context (for use in controllers)
  String getLocalizedNameFromLocale(AppLocalizations l10n) {
    switch (this) {
      case Category.breakfast:
        return l10n.category_breakfast;
      case Category.lunch:
        return l10n.category_lunch;
      case Category.dinner:
        return l10n.category_dinner;
      case Category.snacks:
        return l10n.category_snacks;
      case Category.desserts:
        return l10n.category_desserts;
      case Category.drinks:
        return l10n.category_drinks;
    }
  }
}