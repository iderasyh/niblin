import 'development_benefit.dart';
import '../utils/localized_content.dart';

class NutritionalInfo {
  const NutritionalInfo({
    required this.caloriesPerServing,
    this.vitamins = const <String, double>{},
    this.minerals = const <String, double>{},
    this.developmentBenefits = const <DevelopmentBenefit>[],
    this.benefitExplanations = const <String, String>{},
    this.funFacts = const <String, String>{},
  });

  final int caloriesPerServing;
  final Map<String, double> vitamins;
  final Map<String, double> minerals;
  final List<DevelopmentBenefit> developmentBenefits;
  final Map<String, String> benefitExplanations; // Language code -> explanation
  final Map<String, String> funFacts; // Language code -> fun fact

  NutritionalInfo copyWith({
    int? caloriesPerServing,
    Map<String, double>? vitamins,
    Map<String, double>? minerals,
    List<DevelopmentBenefit>? developmentBenefits,
    Map<String, String>? benefitExplanations,
    Map<String, String>? funFacts,
  }) {
    return NutritionalInfo(
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      vitamins: vitamins ?? this.vitamins,
      minerals: minerals ?? this.minerals,
      developmentBenefits: developmentBenefits ?? this.developmentBenefits,
      benefitExplanations: benefitExplanations ?? this.benefitExplanations,
      funFacts: funFacts ?? this.funFacts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caloriesPerServing': caloriesPerServing,
      'vitamins': vitamins,
      'minerals': minerals,
      'developmentBenefits': developmentBenefits.map((b) => b.name).toList(),
      'benefitExplanations': benefitExplanations,
      'funFacts': funFacts,
    };
  }

  factory NutritionalInfo.fromMap(Map<String, dynamic> map) {
    return NutritionalInfo(
      caloriesPerServing: map['caloriesPerServing'] as int? ?? 0,
      vitamins: Map<String, double>.from(map['vitamins'] as Map? ?? <String, double>{}),
      minerals: Map<String, double>.from(map['minerals'] as Map? ?? <String, double>{}),
      developmentBenefits: (map['developmentBenefits'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => DevelopmentBenefit.values.firstWhere(
                (b) => b.name == (e as String),
                orElse: () => DevelopmentBenefit.brainDevelopment,
              ))
          .toList(),
      benefitExplanations: Map<String, String>.from(
        map['benefitExplanations'] as Map? ?? <String, String>{},
      ),
      funFacts: Map<String, String>.from(
        map['funFacts'] as Map? ?? <String, String>{},
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NutritionalInfo &&
        other.caloriesPerServing == caloriesPerServing &&
        _mapEquals(other.vitamins, vitamins) &&
        _mapEquals(other.minerals, minerals) &&
        _listEquals(other.developmentBenefits, developmentBenefits) &&
        _mapEquals(other.benefitExplanations, benefitExplanations) &&
        _mapEquals(other.funFacts, funFacts);
  }

  @override
  int get hashCode {
    return Object.hash(
      caloriesPerServing,
      Object.hashAll(vitamins.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(minerals.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(developmentBenefits),
      Object.hashAll(benefitExplanations.entries.map((e) => Object.hash(e.key, e.value))),
      Object.hashAll(funFacts.entries.map((e) => Object.hash(e.key, e.value))),
    );
  }

  /// Get localized benefit explanation with fallback to English
  String getLocalizedBenefitExplanation(String languageCode, {String fallback = 'en'}) {
    return LocalizedContent.getLocalizedText(benefitExplanations, languageCode, fallback: fallback);
  }

  /// Get localized fun fact with fallback to English
  String getLocalizedFunFact(String languageCode, {String fallback = 'en'}) {
    return LocalizedContent.getLocalizedText(funFacts, languageCode, fallback: fallback);
  }

  /// Check if nutritional info has content for given language
  bool hasContentForLanguage(String languageCode) {
    return LocalizedContent.hasContentForLocale(benefitExplanations, languageCode) ||
           LocalizedContent.hasContentForLocale(funFacts, languageCode);
  }

  @override
  String toString() {
    return 'NutritionalInfo(caloriesPerServing: $caloriesPerServing, '
        'vitamins: $vitamins, minerals: $minerals, '
        'developmentBenefits: $developmentBenefits, '
        'benefitExplanations: $benefitExplanations, funFacts: $funFacts)';
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