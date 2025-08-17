enum Category {
  breakfast,
  lunch,
  dinner,
  snacks,
  desserts,
  drinks,
}

extension CategoryExtension on Category {
  String get displayNameKey {
    switch (this) {
      case Category.breakfast:
        return 'category_breakfast';
      case Category.lunch:
        return 'category_lunch';
      case Category.dinner:
        return 'category_dinner';
      case Category.snacks:
        return 'category_snacks';
      case Category.desserts:
        return 'category_desserts';
      case Category.drinks:
        return 'category_drinks';
    }
  }

  String get displayName {
    switch (this) {
      case Category.breakfast:
        return 'Breakfast';
      case Category.lunch:
        return 'Lunch';
      case Category.dinner:
        return 'Dinner';
      case Category.snacks:
        return 'Snacks';
      case Category.desserts:
        return 'Desserts';
      case Category.drinks:
        return 'Drinks';
    }
  }
}