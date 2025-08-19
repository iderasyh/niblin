import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../widgets/dynamic_tip_card.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/meal_plan_carousel.dart';
import '../widgets/premium_upgrade_banner.dart';
import '../widgets/weekly_progress_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Section
            const SliverToBoxAdapter(
              child: HomeHeaderWidget(),
            ),
            
            // Main Meal Plan Section
            const SliverToBoxAdapter(
              child: MealPlanCarousel(),
            ),
            
            // Progress Tracker Section
            const SliverToBoxAdapter(
              child: WeeklyProgressWidget(),
            ),
            
            // Tips Section
            const SliverToBoxAdapter(
              child: DynamicTipCard(),
            ),
            
            // Premium Banner (for free users)
            const SliverToBoxAdapter(
              child: PremiumUpgradeBanner(),
            ),
            
            // Bottom padding for navigation bar
            SliverToBoxAdapter(
              child: SizedBox(height: ResponsiveUtils.height20),
            ),
          ],
        ),
      ),
    );
  }
}
