class Ingredient {
  const Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
    this.category,
    this.substitutionTips = const <String, String>{},
  });

  final String name;
  final double amount;
  final String unit;
  final String? category; // e.g., "Produce", "Pantry", "Dairy"
  final Map<String, String> substitutionTips; // Language code -> substitution tip

  Ingredient copyWith({
    String? name,
    double? amount,
    String? unit,
    String? category,
    Map<String, String>? substitutionTips,
  }) {
    return Ingredient(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      substitutionTips: substitutionTips ?? this.substitutionTips,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'amount': amount,
      'unit': unit,
      'category': category,
      'substitutionTips': substitutionTips,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] as String? ?? '',
      category: map['category'] as String?,
      substitutionTips: Map<String, String>.from(
        map['substitutionTips'] as Map? ?? <String, String>{},
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ingredient &&
        other.name == name &&
        other.amount == amount &&
        other.unit == unit &&
        other.category == category &&
        _mapEquals(other.substitutionTips, substitutionTips);
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      amount,
      unit,
      category,
      Object.hashAll(substitutionTips.entries.map((e) => Object.hash(e.key, e.value))),
    );
  }

  @override
  String toString() {
    return 'Ingredient(name: $name, amount: $amount, unit: $unit, '
        'category: $category, substitutionTips: $substitutionTips)';
  }
}

bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}