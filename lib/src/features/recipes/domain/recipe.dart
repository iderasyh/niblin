import '../../../features/onboarding/domain/allergen.dart';
import 'baby_stage.dart';
import 'category.dart';
import 'ingredient.dart';
import 'instruction.dart';
import 'nutritional_info.dart';

class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.supportedStages,
    required this.imageUrl,
    this.videoUrl,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    this.parentRating = 0.0,
    required this.nutritionalInfo,
    required this.ingredients,
    required this.instructions,
    required this.servingGuidance,
    this.allergens = const <Allergen>[],
    required this.storageInfo,
    required this.troubleshooting,
    required this.whyKidsLoveThis,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final Map<String, String> name; // Language code -> name
  final Map<String, String> description; // Language code -> description
  final Category category;
  final List<BabyStage> supportedStages;
  final String imageUrl;
  final String? videoUrl;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final double parentRating;
  final NutritionalInfo nutritionalInfo;
  final Map<String, List<Ingredient>> ingredients; // Language code -> ingredients
  final Map<String, List<Instruction>> instructions; // Language code -> instructions
  final Map<String, String> servingGuidance; // Language code -> serving guidance
  final List<Allergen> allergens;
  final Map<String, String> storageInfo; // Language code -> storage info
  final Map<String, List<String>> troubleshooting; // Language code -> troubleshooting tips
  final Map<String, String> whyKidsLoveThis; // Language code -> why kids love this
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe copyWith({
    String? id,
    Map<String, String>? name,
    Map<String, String>? description,
    Category? category,
    List<BabyStage>? supportedStages,
    String? imageUrl,
    String? videoUrl,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    int? servings,
    double? parentRating,
    NutritionalInfo? nutritionalInfo,
    Map<String, List<Ingredient>>? ingredients,
    Map<String, List<Instruction>>? instructions,
    Map<String, String>? servingGuidance,
    List<Allergen>? allergens,
    Map<String, String>? storageInfo,
    Map<String, List<String>>? troubleshooting,
    Map<String, String>? whyKidsLoveThis,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      supportedStages: supportedStages ?? this.supportedStages,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      servings: servings ?? this.servings,
      parentRating: parentRating ?? this.parentRating,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      servingGuidance: servingGuidance ?? this.servingGuidance,
      allergens: allergens ?? this.allergens,
      storageInfo: storageInfo ?? this.storageInfo,
      troubleshooting: troubleshooting ?? this.troubleshooting,
      whyKidsLoveThis: whyKidsLoveThis ?? this.whyKidsLoveThis,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'category': category.name,
      'supportedStages': supportedStages.map((s) => s.name).toList(),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'servings': servings,
      'parentRating': parentRating,
      'nutritionalInfo': nutritionalInfo.toMap(),
      'ingredients': ingredients.map((key, value) => 
          MapEntry(key, value.map((i) => i.toMap()).toList())),
      'instructions': instructions.map((key, value) => 
          MapEntry(key, value.map((i) => i.toMap()).toList())),
      'servingGuidance': servingGuidance,
      'allergens': allergens.map((a) => a.name).toList(),
      'storageInfo': storageInfo,
      'troubleshooting': troubleshooting,
      'whyKidsLoveThis': whyKidsLoveThis,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String? ?? '',
      name: Map<String, String>.from(map['name'] as Map? ?? <String, String>{}),
      description: Map<String, String>.from(map['description'] as Map? ?? <String, String>{}),
      category: Category.values.firstWhere(
        (c) => c.name == (map['category'] as String?),
        orElse: () => Category.breakfast,
      ),
      supportedStages: (map['supportedStages'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => BabyStage.values.firstWhere(
                (s) => s.name == (e as String?),
                orElse: () => BabyStage.stage1,
              ))
          .toList(),
      imageUrl: map['imageUrl'] as String? ?? '',
      videoUrl: map['videoUrl'] as String?,
      prepTimeMinutes: map['prepTimeMinutes'] as int? ?? 0,
      cookTimeMinutes: map['cookTimeMinutes'] as int? ?? 0,
      servings: map['servings'] as int? ?? 1,
      parentRating: (map['parentRating'] as num?)?.toDouble() ?? 0.0,
      nutritionalInfo: NutritionalInfo.fromMap(
        ((map['nutritionalInfo'] as Map?) ?? <String, dynamic>{}).cast<String, dynamic>(),
      ),
      ingredients: ((map['ingredients'] as Map?) ?? <String, dynamic>{})
          .cast<String, dynamic>()
          .map((key, value) => MapEntry(
                key,
                (value as List<dynamic>? ?? <dynamic>[])
                    .map((i) => Ingredient.fromMap((i as Map).cast<String, dynamic>()))
                    .toList(),
              )),
      instructions: ((map['instructions'] as Map?) ?? <String, dynamic>{})
          .cast<String, dynamic>()
          .map((key, value) => MapEntry(
                key,
                (value as List<dynamic>? ?? <dynamic>[])
                    .map((i) => Instruction.fromMap((i as Map).cast<String, dynamic>()))
                    .toList(),
              )),
      servingGuidance: Map<String, String>.from(
        map['servingGuidance'] as Map? ?? <String, String>{},
      ),
      allergens: (map['allergens'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => Allergen.values.firstWhere(
                (a) => a.name == (e as String?),
                orElse: () => Allergen.other,
              ))
          .toList(),
      storageInfo: Map<String, String>.from(
        map['storageInfo'] as Map? ?? <String, String>{},
      ),
      troubleshooting: ((map['troubleshooting'] as Map?) ?? <String, dynamic>{})
          .cast<String, dynamic>()
          .map((key, value) => MapEntry(
                key,
                (value as List<dynamic>? ?? <dynamic>[])
                    .map((e) => e as String)
                    .toList(),
              )),
      whyKidsLoveThis: Map<String, String>.from(
        map['whyKidsLoveThis'] as Map? ?? <String, String>{},
      ),
      createdAt: DateTime.parse(map['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  /// Get localized name with fallback to English
  String getLocalizedName(String languageCode, {String fallback = 'en'}) {
    return name[languageCode] ?? name[fallback] ?? (name.values.isNotEmpty ? name.values.first : '');
  }

  /// Get localized description with fallback to English
  String getLocalizedDescription(String languageCode, {String fallback = 'en'}) {
    return description[languageCode] ?? description[fallback] ?? (description.values.isNotEmpty ? description.values.first : '');
  }

  /// Get localized ingredients with fallback to English
  List<Ingredient> getLocalizedIngredients(String languageCode, {String fallback = 'en'}) {
    return ingredients[languageCode] ?? ingredients[fallback] ?? (ingredients.values.isNotEmpty ? ingredients.values.first : <Ingredient>[]);
  }

  /// Get localized instructions with fallback to English
  List<Instruction> getLocalizedInstructions(String languageCode, {String fallback = 'en'}) {
    return instructions[languageCode] ?? instructions[fallback] ?? (instructions.values.isNotEmpty ? instructions.values.first : <Instruction>[]);
  }

  /// Get localized serving guidance with fallback to English
  String getLocalizedServingGuidance(String languageCode, {String fallback = 'en'}) {
    return servingGuidance[languageCode] ?? servingGuidance[fallback] ?? (servingGuidance.values.isNotEmpty ? servingGuidance.values.first : '');
  }

  /// Get localized storage info with fallback to English
  String getLocalizedStorageInfo(String languageCode, {String fallback = 'en'}) {
    return storageInfo[languageCode] ?? storageInfo[fallback] ?? (storageInfo.values.isNotEmpty ? storageInfo.values.first : '');
  }

  /// Get localized troubleshooting tips with fallback to English
  List<String> getLocalizedTroubleshooting(String languageCode, {String fallback = 'en'}) {
    return troubleshooting[languageCode] ?? troubleshooting[fallback] ?? (troubleshooting.values.isNotEmpty ? troubleshooting.values.first : <String>[]);
  }

  /// Get localized "why kids love this" with fallback to English
  String getLocalizedWhyKidsLoveThis(String languageCode, {String fallback = 'en'}) {
    return whyKidsLoveThis[languageCode] ?? whyKidsLoveThis[fallback] ?? (whyKidsLoveThis.values.isNotEmpty ? whyKidsLoveThis.values.first : '');
  }

  /// Check if recipe is appropriate for given baby age in months
  bool isAppropriateForAge(int ageInMonths) {
    return supportedStages.any((stage) => stage.isAppropriateForAge(ageInMonths));
  }

  /// Get total cooking time (prep + cook)
  int get totalTimeMinutes => prepTimeMinutes + cookTimeMinutes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe &&
        other.id == id &&
        _mapEquals(other.name, name) &&
        _mapEquals(other.description, description) &&
        other.category == category &&
        _listEquals(other.supportedStages, supportedStages) &&
        other.imageUrl == imageUrl &&
        other.videoUrl == videoUrl &&
        other.prepTimeMinutes == prepTimeMinutes &&
        other.cookTimeMinutes == cookTimeMinutes &&
        other.servings == servings &&
        other.parentRating == parentRating &&
        other.nutritionalInfo == nutritionalInfo &&
        _deepMapEquals(other.ingredients, ingredients) &&
        _deepMapEquals(other.instructions, instructions) &&
        _mapEquals(other.servingGuidance, servingGuidance) &&
        _listEquals(other.allergens, allergens) &&
        _mapEquals(other.storageInfo, storageInfo) &&
        _deepMapListEquals(other.troubleshooting, troubleshooting) &&
        _mapEquals(other.whyKidsLoveThis, whyKidsLoveThis) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      Object.hashAll(name.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(description.entries.map((e) => Object.hash(e.key, e.value))),
      category,
      Object.hashAll(supportedStages),
      imageUrl,
      videoUrl,
      prepTimeMinutes,
      cookTimeMinutes,
      servings,
      parentRating,
      nutritionalInfo,
      Object.hashAll(ingredients.entries.map((e) => Object.hash(e.key, Object.hashAll(e.value)))),
      Object.hashAll(instructions.entries.map((e) => Object.hash(e.key, Object.hashAll(e.value)))),
      Object.hashAll(servingGuidance.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(allergens),
      Object.hashAll(storageInfo.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(troubleshooting.entries.map((e) => Object.hash(e.key, Object.hashAll(e.value)))),
      Object.hashAll(whyKidsLoveThis.entries.map((e) => Object.hash(e.key, e.value))),
      createdAt,
      updatedAt,
    ]);
  }

  @override
  String toString() {
    return 'Recipe(id: $id, name: $name, category: $category, '
        'supportedStages: $supportedStages, prepTimeMinutes: $prepTimeMinutes, '
        'cookTimeMinutes: $cookTimeMinutes, servings: $servings, '
        'parentRating: $parentRating, allergens: $allergens)';
  }
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

bool _deepMapEquals<K, V>(Map<K, List<V>> a, Map<K, List<V>> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || !_listEquals(a[key]!, b[key]!)) return false;
  }
  return true;
}

bool _deepMapListEquals<K>(Map<K, List<String>> a, Map<K, List<String>> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || !_listEquals(a[key]!, b[key]!)) return false;
  }
  return true;
}