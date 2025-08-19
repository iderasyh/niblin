import '../../meal_plan/domain/meal_plan.dart';
import '../../progress/domain/progress_tracker.dart';
import '../../recipes/domain/baby_stage.dart';
import '../../recipes/domain/category.dart';

import '../../recipes/domain/nutritional_info.dart';
import '../../recipes/domain/recipe.dart';
import '../../tips/domain/tip_content.dart';

class MockData {
  // Mock Recipes for meal plan
  static final List<Recipe> mockRecipes = [
    Recipe(
      id: 'recipe_001',
      name: {'en': 'Banana Oat Porridge'},
      description: {
        'en': 'Creamy and nutritious porridge perfect for breakfast',
      },
      imageUrl:
          'https://www.chiquita.com/wp-content/uploads/2020/03/Banana-oatmeal-with-honey-walnuts-and-cinnamon-1.jpg',
      prepTimeMinutes: 10,
      cookTimeMinutes: 5,
      servings: 1,
      category: Category.breakfast,
      supportedStages: [BabyStage.stage1],
      allergens: const [],
      ingredients: {'en': []},
      instructions: {'en': []},
      nutritionalInfo: const NutritionalInfo(
        caloriesPerServing: 120,
        oneWordDescription: {
          'en': 'Sweet',
        },
      ),
      servingGuidance: {'en': '2-3 tablespoons for 6+ months'},
      storageInfo: {'en': 'Store in refrigerator for up to 2 days'},
      troubleshooting: {
        'en': [
          'Add more liquid if too thick',
          'Mash bananas well for smooth texture',
        ],
      },
      whyKidsLoveThis: {'en': 'Sweet banana flavor with creamy texture'},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Recipe(
      id: 'recipe_002',
      name: {'en': 'Sweet Potato & Carrot Mash'},
      description: {'en': 'Colorful and vitamin-rich lunch option'},
      imageUrl:
          'https://d2mkh7ukbp9xav.cloudfront.net/recipeimage/w0jq37l9-86a25-902836-cfcd2-ycc0mlat/9430bc3c-dbef-40c5-a588-9ef6f666f514/large/mashed-sweet-potato-and-carrot.jpg',
      prepTimeMinutes: 15,
      cookTimeMinutes: 20,
      servings: 1,
      category: Category.lunch,
      supportedStages: [BabyStage.stage1, BabyStage.stage2],
      allergens: const [],
      ingredients: {'en': []},
      instructions: {'en': []},
      nutritionalInfo: const NutritionalInfo(
        caloriesPerServing: 80,
        oneWordDescription: {
          'en': 'Healthy',
        },
      ),
      servingGuidance: {'en': '3-4 tablespoons for 6+ months'},
      storageInfo: {'en': 'Store in refrigerator for up to 3 days'},
      troubleshooting: {
        'en': [
          'Steam longer if too firm',
          'Add breast milk for smoother consistency',
        ],
      },
      whyKidsLoveThis: {'en': 'Naturally sweet and vibrant orange color'},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Recipe(
      id: 'recipe_003',
      name: {'en': 'Broccoli & Cheese Puree'},
      description: {'en': 'Gentle introduction to green vegetables'},
      imageUrl:
          'https://weelicious.com/wp-content/uploads/2010/04/Broccoli-Potato-Cheese-Puree-1.jpg',
      prepTimeMinutes: 10,
      cookTimeMinutes: 15,
      servings: 1,
      category: Category.dinner,
      supportedStages: [BabyStage.stage2],
      allergens: const [],
      ingredients: {'en': []},
      instructions: {'en': []},
      nutritionalInfo: const NutritionalInfo(
        caloriesPerServing: 90,
        oneWordDescription: {
          'en': 'Nutritious',
        },
      ),
      servingGuidance: {'en': '2-3 tablespoons for 6+ months'},
      storageInfo: {'en': 'Store in refrigerator for up to 2 days'},
      troubleshooting: {
        'en': [
          'Mix cheese gradually to avoid lumps',
          'Steam broccoli until very tender',
        ],
      },
      whyKidsLoveThis: {
        'en': 'Mild cheese flavor makes vegetables more appealing',
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  // Mock Today's Meal Plan
  static final MealPlan mockTodaysMealPlan = MealPlan(
    id: 'meal_plan_001',
    uid: 'user_001',
    babyId: 'baby_001',
    startDate: DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    ),
    endDate: DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)),
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
    status: 'active',
    days: {
      Days.values[DateTime.now().weekday - 1]: {
        Category.breakfast: 'recipe_001',
        Category.lunch: 'recipe_002',
        Category.dinner: 'recipe_003',
      },
    },
  );

  // Mock Progress Tracker
  static final ProgressTracker mockProgressTracker = ProgressTracker(
    id: 'progress_001',
    userId: 'user_001',
    babyId: 'baby_001',
    weekStartDate: DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1),
    ),
    weekEndDate: DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)),
    newFoodsIntroduced: ['avocado', 'carrot', 'sweetPotato'], // Food IDs
    totalMealsLogged: 18,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  );

  // Mock Tips Content
  static final List<TipContent> mockTips = [
    TipContent(
      id: 'tip_001',
      title: 'Is My Baby Ready for Finger Foods?',
      description:
          'Learn the signs that indicate your baby is ready to start exploring finger foods and self-feeding.',
      contentType: TipContentType.article,
      targetAgeMinMonths: 6,
      targetAgeMaxMonths: 9,
      category: TipCategory.feeding,
      priority: 5,
      imageUrl: 'https://example.com/finger-foods.jpg',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TipContent(
      id: 'tip_002',
      title: 'When introducing eggs, start small',
      description:
          'Start with a small amount and watch for reactions for two hours. Eggs are a common allergen but also a great source of protein.',
      contentType: TipContentType.safety,
      targetAgeMinMonths: 6,
      targetAgeMaxMonths: 12,
      category: TipCategory.safety,
      priority: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    TipContent(
      id: 'tip_003',
      title: 'Baby Gagging vs Choking',
      description:
          'Understanding the difference between normal gagging and dangerous choking can help you stay calm during meals.',
      contentType: TipContentType.safety,
      targetAgeMinMonths: 6,
      targetAgeMaxMonths: 24,
      category: TipCategory.safety,
      priority: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now(),
    ),
  ];

  // Helper methods to get appropriate mock data
  static TipContent? getTipForAge(int ageInMonths) {
    return mockTips
        .where((tip) => tip.isAppropriateForAge(ageInMonths))
        .fold<TipContent?>(null, (current, tip) {
          if (current == null || tip.priority > current.priority) {
            return tip;
          }
          return current;
        });
  }

  static Recipe? getRecipeById(String recipeId) {
    try {
      return mockRecipes.firstWhere((recipe) => recipe.id == recipeId);
    } catch (e) {
      return null;
    }
  }

  static Map<Category, Recipe?> getTodaysMeals() {
    final today = Days.values[DateTime.now().weekday - 1];
    final todaysMeals = mockTodaysMealPlan.days[today] ?? {};

    return {
      Category.breakfast: todaysMeals[Category.breakfast] != null
          ? getRecipeById(todaysMeals[Category.breakfast]!)
          : null,
      Category.lunch: todaysMeals[Category.lunch] != null
          ? getRecipeById(todaysMeals[Category.lunch]!)
          : null,
      Category.dinner: todaysMeals[Category.dinner] != null
          ? getRecipeById(todaysMeals[Category.dinner]!)
          : null,
    };
  }
}
