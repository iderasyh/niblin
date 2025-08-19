import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../l10n/locale_controller.dart';
import '../domain/recipe.dart';
import '../domain/ingredient.dart';
import '../domain/instruction.dart';
import '../utils/localized_content.dart';
import '../utils/measurement_converter.dart';

part 'recipe_localization_service.g.dart';

/// Service for handling recipe localization and measurement conversion
@riverpod
class RecipeLocalizationService extends _$RecipeLocalizationService {
  @override
  String build() {
    return ref.watch(localeControllerProvider);
  }

  /// Get current locale
  String get currentLocale => state;

  /// Get localized recipe name
  String getLocalizedName(Recipe recipe) {
    return LocalizedContent.getLocalizedText(recipe.name, currentLocale);
  }

  /// Get localized recipe description
  String getLocalizedDescription(Recipe recipe) {
    return LocalizedContent.getLocalizedText(recipe.description, currentLocale);
  }

  /// Get localized ingredients with measurement conversion
  List<Ingredient> getLocalizedIngredients(Recipe recipe) {
    final ingredients = LocalizedContent.getLocalizedList(
      recipe.ingredients,
      currentLocale,
    );

    // Convert measurements based on locale
    return ingredients.map((ingredient) {
      final convertedAmount = MeasurementConverter.formatMeasurement(
        ingredient.amount,
        ingredient.unit,
        currentLocale,
      );

      // Parse the converted amount and unit
      final parts = convertedAmount.split(' ');
      if (parts.length >= 2) {
        final amount = double.tryParse(parts[0]);
        final unit = parts.sublist(1).join(' ');

        return ingredient.copyWith(amount: amount, unit: unit);
      }

      return ingredient;
    }).toList();
  }

  /// Get localized instructions
  List<Instruction> getLocalizedInstructions(Recipe recipe) {
    return LocalizedContent.getLocalizedList(
      recipe.instructions,
      currentLocale,
    );
  }

  /// Get localized serving guidance
  String getLocalizedServingGuidance(Recipe recipe) {
    return LocalizedContent.getLocalizedText(
      recipe.servingGuidance,
      currentLocale,
    );
  }

  /// Get localized storage info
  String getLocalizedStorageInfo(Recipe recipe) {
    return LocalizedContent.getLocalizedText(recipe.storageInfo, currentLocale);
  }

  /// Get localized troubleshooting tips
  List<String> getLocalizedTroubleshooting(Recipe recipe) {
    return LocalizedContent.getLocalizedList(
      recipe.troubleshooting,
      currentLocale,
    );
  }

  /// Get localized "why kids love this"
  String getLocalizedWhyKidsLoveThis(Recipe recipe) {
    return LocalizedContent.getLocalizedText(
      recipe.whyKidsLoveThis,
      currentLocale,
    );
  }

  /// Get localized nutritional benefit explanation
  String getLocalizedBenefitExplanation(Recipe recipe) {
    return recipe.nutritionalInfo.getLocalizedBenefitExplanation(currentLocale);
  }

  /// Get localized fun fact
  String getLocalizedFunFact(Recipe recipe) {
    return recipe.nutritionalInfo.getLocalizedFunFact(currentLocale);
  }

  /// Check if recipe has content for current locale
  bool hasContentForCurrentLocale(Recipe recipe) {
    return LocalizedContent.hasContentForLocale(recipe.name, currentLocale) ||
        LocalizedContent.hasContentForLocale(
          recipe.description,
          currentLocale,
        ) ||
        LocalizedContent.hasContentForLocale(
          recipe.ingredients,
          currentLocale,
        ) ||
        LocalizedContent.hasContentForLocale(
          recipe.instructions,
          currentLocale,
        );
  }

  /// Get all available locales for a recipe
  List<String> getAvailableLocales(Recipe recipe) {
    final locales = <String>{};

    locales.addAll(LocalizedContent.getAvailableLocales(recipe.name));
    locales.addAll(LocalizedContent.getAvailableLocales(recipe.description));
    locales.addAll(LocalizedContent.getAvailableLocales(recipe.ingredients));
    locales.addAll(LocalizedContent.getAvailableLocales(recipe.instructions));
    locales.addAll(
      LocalizedContent.getAvailableLocales(recipe.servingGuidance),
    );
    locales.addAll(LocalizedContent.getAvailableLocales(recipe.storageInfo));
    locales.addAll(
      LocalizedContent.getAvailableLocales(recipe.troubleshooting),
    );
    locales.addAll(
      LocalizedContent.getAvailableLocales(recipe.whyKidsLoveThis),
    );

    return locales.toList()..sort();
  }

  /// Convert measurement for display
  String formatMeasurement(double value, String unit) {
    return MeasurementConverter.formatMeasurement(value, unit, currentLocale);
  }

  /// Check if current locale uses metric system
  bool get isMetricLocale {
    // Most countries use metric, only a few use imperial
    const imperialLocales = ['en_US', 'en_LR', 'en_MM'];
    return !imperialLocales.contains(currentLocale);
  }
}
