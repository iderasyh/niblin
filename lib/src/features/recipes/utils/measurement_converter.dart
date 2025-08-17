import 'dart:math';

/// Utility class for converting measurements between metric and imperial units
class MeasurementConverter {
  /// Convert volume measurements
  static double convertVolume(
    double value,
    VolumeUnit from,
    VolumeUnit to,
  ) {
    if (from == to) return value;
    
    // Convert to milliliters first
    final milliliters = _toMilliliters(value, from);
    
    // Convert from milliliters to target unit
    return _fromMilliliters(milliliters, to);
  }

  /// Convert weight measurements
  static double convertWeight(
    double value,
    WeightUnit from,
    WeightUnit to,
  ) {
    if (from == to) return value;
    
    // Convert to grams first
    final grams = _toGrams(value, from);
    
    // Convert from grams to target unit
    return _fromGrams(grams, to);
  }

  /// Convert temperature measurements
  static double convertTemperature(
    double value,
    TemperatureUnit from,
    TemperatureUnit to,
  ) {
    if (from == to) return value;
    
    switch (from) {
      case TemperatureUnit.celsius:
        switch (to) {
          case TemperatureUnit.fahrenheit:
            return (value * 9 / 5) + 32;
          case TemperatureUnit.celsius:
            return value;
        }
      case TemperatureUnit.fahrenheit:
        switch (to) {
          case TemperatureUnit.celsius:
            return (value - 32) * 5 / 9;
          case TemperatureUnit.fahrenheit:
            return value;
        }
    }
  }

  /// Format measurement with appropriate unit based on locale
  static String formatMeasurement(
    double value,
    String unit,
    String locale, {
    int decimalPlaces = 1,
  }) {
    final isMetric = _isMetricLocale(locale);
    final convertedValue = _convertBasedOnLocale(value, unit, isMetric);
    final convertedUnit = _getUnitForLocale(unit, isMetric);
    
    // Round to specified decimal places
    final rounded = (convertedValue * pow(10, decimalPlaces)).round() / pow(10, decimalPlaces);
    
    // Format number to avoid unnecessary decimals
    final formatted = rounded == rounded.toInt() 
        ? rounded.toInt().toString() 
        : rounded.toStringAsFixed(decimalPlaces);
    
    return '$formatted $convertedUnit';
  }

  /// Check if locale uses metric system
  static bool _isMetricLocale(String locale) {
    // Most countries use metric, only a few use imperial
    const imperialLocales = ['en_US', 'en_LR', 'en_MM'];
    return !imperialLocales.contains(locale);
  }

  /// Convert measurement based on locale preference
  static double _convertBasedOnLocale(double value, String unit, bool isMetric) {
    final lowerUnit = unit.toLowerCase();
    
    // Volume conversions
    if (lowerUnit.contains('ml') || lowerUnit.contains('milliliter')) {
      return isMetric ? value : convertVolume(value, VolumeUnit.milliliter, VolumeUnit.fluidOunce);
    }
    if (lowerUnit.contains('l') || lowerUnit.contains('liter')) {
      return isMetric ? value : convertVolume(value, VolumeUnit.liter, VolumeUnit.cup);
    }
    if (lowerUnit.contains('cup')) {
      return isMetric ? convertVolume(value, VolumeUnit.cup, VolumeUnit.milliliter) : value;
    }
    if (lowerUnit.contains('fl oz') || lowerUnit.contains('fluid ounce')) {
      return isMetric ? convertVolume(value, VolumeUnit.fluidOunce, VolumeUnit.milliliter) : value;
    }
    
    // Weight conversions
    if (lowerUnit.contains('g') || lowerUnit.contains('gram')) {
      return isMetric ? value : convertWeight(value, WeightUnit.gram, WeightUnit.ounce);
    }
    if (lowerUnit.contains('kg') || lowerUnit.contains('kilogram')) {
      return isMetric ? value : convertWeight(value, WeightUnit.kilogram, WeightUnit.pound);
    }
    if (lowerUnit.contains('oz') || lowerUnit.contains('ounce')) {
      return isMetric ? convertWeight(value, WeightUnit.ounce, WeightUnit.gram) : value;
    }
    if (lowerUnit.contains('lb') || lowerUnit.contains('pound')) {
      return isMetric ? convertWeight(value, WeightUnit.pound, WeightUnit.kilogram) : value;
    }
    
    return value;
  }

  /// Get appropriate unit for locale
  static String _getUnitForLocale(String unit, bool isMetric) {
    final lowerUnit = unit.toLowerCase();
    
    // Volume unit conversions
    if (lowerUnit.contains('ml') || lowerUnit.contains('milliliter')) {
      return isMetric ? 'ml' : 'fl oz';
    }
    if (lowerUnit.contains('l') || lowerUnit.contains('liter')) {
      return isMetric ? 'L' : 'cups';
    }
    if (lowerUnit.contains('cup')) {
      return isMetric ? 'ml' : 'cups';
    }
    if (lowerUnit.contains('fl oz') || lowerUnit.contains('fluid ounce')) {
      return isMetric ? 'ml' : 'fl oz';
    }
    
    // Weight unit conversions
    if (lowerUnit.contains('g') || lowerUnit.contains('gram')) {
      return isMetric ? 'g' : 'oz';
    }
    if (lowerUnit.contains('kg') || lowerUnit.contains('kilogram')) {
      return isMetric ? 'kg' : 'lbs';
    }
    if (lowerUnit.contains('oz') || lowerUnit.contains('ounce')) {
      return isMetric ? 'g' : 'oz';
    }
    if (lowerUnit.contains('lb') || lowerUnit.contains('pound')) {
      return isMetric ? 'kg' : 'lbs';
    }
    
    return unit; // Return original if no conversion needed
  }

  static double _toMilliliters(double value, VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.milliliter:
        return value;
      case VolumeUnit.liter:
        return value * 1000;
      case VolumeUnit.cup:
        return value * 236.588; // US cup
      case VolumeUnit.tablespoon:
        return value * 14.7868;
      case VolumeUnit.teaspoon:
        return value * 4.92892;
      case VolumeUnit.fluidOunce:
        return value * 29.5735;
    }
  }

  static double _fromMilliliters(double milliliters, VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.milliliter:
        return milliliters;
      case VolumeUnit.liter:
        return milliliters / 1000;
      case VolumeUnit.cup:
        return milliliters / 236.588;
      case VolumeUnit.tablespoon:
        return milliliters / 14.7868;
      case VolumeUnit.teaspoon:
        return milliliters / 4.92892;
      case VolumeUnit.fluidOunce:
        return milliliters / 29.5735;
    }
  }

  static double _toGrams(double value, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.gram:
        return value;
      case WeightUnit.kilogram:
        return value * 1000;
      case WeightUnit.ounce:
        return value * 28.3495;
      case WeightUnit.pound:
        return value * 453.592;
    }
  }

  static double _fromGrams(double grams, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.gram:
        return grams;
      case WeightUnit.kilogram:
        return grams / 1000;
      case WeightUnit.ounce:
        return grams / 28.3495;
      case WeightUnit.pound:
        return grams / 453.592;
    }
  }
}

enum VolumeUnit {
  milliliter,
  liter,
  cup,
  tablespoon,
  teaspoon,
  fluidOunce,
}

enum WeightUnit {
  gram,
  kilogram,
  ounce,
  pound,
}

enum TemperatureUnit {
  celsius,
  fahrenheit,
}