import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/common_widgets.dart/loading_indicator.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../application/recipe_list_controller.dart';
import '../../domain/category.dart';
import '../../domain/baby_stage.dart';
import '../widgets/recipe_card.dart';

/// Recipe list screen with category tabs, search, filtering, and pull-to-refresh
/// Features engaging empty states, loading indicators, and smooth navigation
class RecipeListScreen extends ConsumerStatefulWidget {
  const RecipeListScreen({
    super.key,
    this.initialCategory,
    this.initialSearch,
  });

  final String? initialCategory;
  final String? initialSearch;

  @override
  ConsumerState<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends ConsumerState<RecipeListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Category.values.length + 1, vsync: this);
    _scrollController = ScrollController();
    
    // Load initial recipes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipeListControllerProvider.notifier).loadRecipes(refresh: true);
    });
    
    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(recipeListControllerProvider.notifier).loadMoreRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(recipeListControllerProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, l10n),
            _buildSearchBar(context, l10n),
            _buildCategoryTabs(context, l10n),
            Expanded(
              child: _buildRecipeList(context, l10n, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final state = ref.watch(recipeListControllerProvider);
    final hasActiveFilters = state.selectedStage != null || state.searchQuery.isNotEmpty;
    
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.spacing16),
      child: Row(
        children: [
          Text(
            'Recipes', // TODO: Add to localization
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                onPressed: () => _showFilterBottomSheet(context, l10n),
                icon: Icon(
                  Icons.filter_list,
                  color: hasActiveFilters ? AppColors.primary : AppColors.textSecondary,
                  size: ResponsiveUtils.iconSize24,
                ),
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing16),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.spacing12),
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search recipes...', // TODO: Add to localization
          hintStyle: TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: ResponsiveUtils.iconSize20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.textSecondary,
                    size: ResponsiveUtils.iconSize20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(recipeListControllerProvider.notifier)
                        .setSearchQuery('');
                  },
                )
              : null,
        ),
        onChanged: (query) {
          ref.read(recipeListControllerProvider.notifier).setSearchQuery(query);
        },
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, AppLocalizations l10n) {
    final state = ref.watch(recipeListControllerProvider);
    
    return Container(
      margin: EdgeInsets.only(top: ResponsiveUtils.spacing16),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        onTap: (index) {
          final category = index == 0 ? null : Category.values[index - 1];
          ref.read(recipeListControllerProvider.notifier).setCategory(category);
        },
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('All'), // TODO: Add to localization
                if (state.selectedStage != null || state.searchQuery.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(left: ResponsiveUtils.spacing4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          ...Category.values.map((category) => 
            Tab(text: l10n.localeName == 'en' 
                ? _getCategoryDisplayName(category)
                : _getCategoryDisplayName(category) // TODO: Use proper localization
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context, AppLocalizations l10n, RecipeListState state) {
    if (state.isLoading && state.recipes.isEmpty) {
      return const Center(child: LoadingIndicator());
    }

    if (state.error != null && state.recipes.isEmpty) {
      return _buildErrorState(context, l10n, state.error!.errorCode);
    }

    if (state.recipes.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(recipeListControllerProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(ResponsiveUtils.spacing16),
        itemCount: state.recipes.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.recipes.length) {
            // Loading indicator for pagination
            return Container(
              padding: EdgeInsets.all(ResponsiveUtils.spacing16),
              child: const Center(child: LoadingIndicator()),
            );
          }

          final recipe = state.recipes[index];
          return Container(
            margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing12),
            child: RecipeCard(
              recipe: recipe,
              onTap: () {
                // TODO: Navigate to recipe detail screen in task 6
                debugPrint('Navigate to recipe: ${recipe.id}');
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Engaging illustration placeholder
            Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
              ),
              child: Icon(
                Icons.restaurant_menu_outlined,
                size: ResponsiveUtils.iconSize48,
                color: AppColors.textSecondary,
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.spacing16),
            
            Text(
              'No recipes found', // TODO: Add to localization
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ResponsiveUtils.spacing8),
            
            Text(
              'Try adjusting your search or filters to find delicious recipes for your little one.', // TODO: Add to localization
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ResponsiveUtils.spacing16),
            
            ElevatedButton(
              onPressed: () {
                ref.read(recipeListControllerProvider.notifier).clearFilters();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing24,
                  vertical: ResponsiveUtils.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                ),
              ),
              child: Text('Clear Filters'), // TODO: Add to localization
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations l10n, String error) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveUtils.iconSize48,
              color: AppColors.error,
            ),
            
            SizedBox(height: ResponsiveUtils.spacing16),
            
            Text(
              'Something went wrong', // TODO: Add to localization
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ResponsiveUtils.spacing8),
            
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: ResponsiveUtils.spacing16),
            
            ElevatedButton(
              onPressed: () {
                ref.read(recipeListControllerProvider.notifier).refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.spacing24,
                  vertical: ResponsiveUtils.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                ),
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDisplayName(Category category) {
    switch (category) {
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

  String _getStageDisplayName(BabyStage stage) {
    switch (stage) {
      case BabyStage.stage1:
        return 'Stage 1 (4-6m)';
      case BabyStage.stage2:
        return 'Stage 2 (6-8m)';
      case BabyStage.stage3:
        return 'Stage 3 (8-12m)';
      case BabyStage.toddler:
        return 'Toddler (12-24m)';
    }
  }

  void _showFilterBottomSheet(BuildContext context, AppLocalizations l10n) {
    final state = ref.read(recipeListControllerProvider);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ResponsiveUtils.radius20),
            topRight: Radius.circular(ResponsiveUtils.radius20),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveUtils.spacing20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.spacing16),
            
            // Title
            Text(
              'Filter Recipes', // TODO: Add to localization
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.spacing20),
            
            // Baby Stage Filter
            Text(
              'Baby Stage', // TODO: Add to localization
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.spacing12),
            
            Wrap(
              spacing: ResponsiveUtils.spacing8,
              runSpacing: ResponsiveUtils.spacing8,
              children: [
                _buildFilterChip(
                  context,
                  'All Stages', // TODO: Add to localization
                  state.selectedStage == null,
                  () => ref.read(recipeListControllerProvider.notifier).setStage(null),
                ),
                ...BabyStage.values.map((stage) => 
                  _buildFilterChip(
                    context,
                    _getStageDisplayName(stage),
                    state.selectedStage == stage,
                    () => ref.read(recipeListControllerProvider.notifier).setStage(stage),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: ResponsiveUtils.spacing20),
            
            // Dietary Restrictions Filter
            Text(
              'Dietary Restrictions', // TODO: Add to localization
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.spacing12),
            
            Text(
              'Filter out recipes containing:', // TODO: Add to localization
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            SizedBox(height: ResponsiveUtils.spacing8),
            
            // TODO: Implement allergen filtering in future iteration
            Wrap(
              spacing: ResponsiveUtils.spacing8,
              runSpacing: ResponsiveUtils.spacing8,
              children: [
                _buildAllergenChip(context, 'Dairy', false, () {}),
                _buildAllergenChip(context, 'Eggs', false, () {}),
                _buildAllergenChip(context, 'Peanuts', false, () {}),
                _buildAllergenChip(context, 'Wheat', false, () {}),
              ],
            ),
            
            SizedBox(height: ResponsiveUtils.spacing24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(recipeListControllerProvider.notifier).clearFilters();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.spacing12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                      ),
                    ),
                    child: Text(
                      'Clear All', // TODO: Add to localization
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                
                SizedBox(width: ResponsiveUtils.spacing12),
                
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.spacing12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
                      ),
                    ),
                    child: Text('Apply Filters'), // TODO: Add to localization
                  ),
                ),
              ],
            ),
            
            // Add bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing16,
          vertical: ResponsiveUtils.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.neutralLight,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutralLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAllergenChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.spacing16,
          vertical: ResponsiveUtils.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.error.withValues(alpha: 0.1) : AppColors.neutralLight,
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius20),
          border: Border.all(
            color: isSelected ? AppColors.error : AppColors.neutralLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.close,
                size: ResponsiveUtils.iconSize16,
                color: AppColors.error,
              ),
            if (isSelected) SizedBox(width: ResponsiveUtils.spacing4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected ? AppColors.error : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}