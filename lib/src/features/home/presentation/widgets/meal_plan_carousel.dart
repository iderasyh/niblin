import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../data/mock_data.dart';
import '../../../recipes/domain/category.dart';
import 'empty_meal_plan_state.dart';
import 'meal_plan_card.dart';

class MealPlanCarousel extends StatelessWidget {
  const MealPlanCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final todaysMeals = MockData.getTodaysMeals();

    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.height24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing20,
            ),
            child: Text(
              AppLocalizations.of(context)!.todaysMealPlan,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          SizedBox(height: ResponsiveUtils.height16),

          // Horizontal scrolling meal cards
          SizedBox(
            height: ResponsiveUtils.height400,
            // child: const EmptyMealPlanState(), // TODO: THIS WILL BE SHOWN WHEN THERE IS NO MEAL PLAN
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.spacing20,
              ),
              children: [
                // Breakfast
                _buildMealCard(
                  'Breakfast',
                  todaysMeals[Category.breakfast],
                  context,
                ),

                // Lunch
                _buildMealCard('Lunch', todaysMeals[Category.lunch], context),

                // Dinner
                _buildMealCard('Dinner', todaysMeals[Category.dinner], context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(
    String mealTitle,
    dynamic recipe,
    BuildContext context,
  ) {
    if (recipe == null) {
      return const EmptyMealPlanState();
    }

    return MealPlanCard(mealTitle: mealTitle, recipe: recipe);
  }
}
