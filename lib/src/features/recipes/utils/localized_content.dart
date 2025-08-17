/// Utility class for handling localized content with fallback logic
class LocalizedContent {
  /// Get localized text from a map with fallback to default language
  static String getLocalizedText(
    Map<String, String> content,
    String locale, {
    String fallback = 'en',
  }) {
    // Try to get content for the requested locale
    if (content.containsKey(locale) && content[locale]!.isNotEmpty) {
      return content[locale]!;
    }
    
    // Fallback to default language
    if (content.containsKey(fallback) && content[fallback]!.isNotEmpty) {
      return content[fallback]!;
    }
    
    // Last resort: return first available content
    if (content.values.isNotEmpty) {
      return content.values.first;
    }
    
    return '';
  }

  /// Get localized list from a map with fallback logic
  static List<T> getLocalizedList<T>(
    Map<String, List<T>> content,
    String locale, {
    String fallback = 'en',
  }) {
    // Try to get content for the requested locale
    if (content.containsKey(locale) && content[locale]!.isNotEmpty) {
      return content[locale]!;
    }
    
    // Fallback to default language
    if (content.containsKey(fallback) && content[fallback]!.isNotEmpty) {
      return content[fallback]!;
    }
    
    // Last resort: return first available content
    if (content.values.isNotEmpty) {
      return content.values.first;
    }
    
    return <T>[];
  }

  /// Check if content is available for a specific locale
  static bool hasContentForLocale(
    Map<String, dynamic> content,
    String locale,
  ) {
    return content.containsKey(locale) && 
           content[locale] != null && 
           (content[locale] is String ? (content[locale] as String).isNotEmpty : 
            content[locale] is List ? (content[locale] as List).isNotEmpty : 
            true);
  }

  /// Get all available locales from content map
  static List<String> getAvailableLocales(Map<String, dynamic> content) {
    return content.keys.where((key) => hasContentForLocale(content, key)).toList();
  }

  /// Merge localized content maps, with priority given to the first map
  static Map<String, String> mergeLocalizedContent(
    Map<String, String> primary,
    Map<String, String> secondary,
  ) {
    final merged = Map<String, String>.from(secondary);
    merged.addAll(primary);
    return merged;
  }
}