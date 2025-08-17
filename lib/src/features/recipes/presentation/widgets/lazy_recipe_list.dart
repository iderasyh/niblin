import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/image_cache_service.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/recipe.dart';
import 'recipe_card.dart';

/// A lazy loading list widget optimized for large recipe collections
/// Features viewport-based image preloading and memory-efficient scrolling
class LazyRecipeList extends ConsumerStatefulWidget {
  const LazyRecipeList({
    super.key,
    required this.recipes,
    required this.onRecipeTap,
    this.onLoadMore,
    this.isLoading = false,
    this.hasMore = false,
    this.padding,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  final List<Recipe> recipes;
  final Function(Recipe) onRecipeTap;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final EdgeInsetsGeometry? padding;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  ConsumerState<LazyRecipeList> createState() => _LazyRecipeListState();
}

class _LazyRecipeListState extends ConsumerState<LazyRecipeList> {
  final ScrollController _scrollController = ScrollController();
  final Set<int> _preloadedIndices = {};
  static const int _preloadThreshold = 5; // Preload images 5 items ahead

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Preload initial visible images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadVisibleImages();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more data when near the end
    if (widget.hasMore && 
        !widget.isLoading && 
        _scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore?.call();
    }

    // Preload images for upcoming items
    _preloadUpcomingImages();
  }

  void _preloadVisibleImages() {
    if (!mounted) return;
    
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportHeight = renderBox.size.height;
    final itemHeight = viewportHeight / (widget.crossAxisCount * widget.childAspectRatio);
    final visibleItemCount = (viewportHeight / itemHeight).ceil() * widget.crossAxisCount;
    
    _preloadImagesInRange(0, visibleItemCount + _preloadThreshold);
  }

  void _preloadUpcomingImages() {
    if (!mounted || widget.recipes.isEmpty) return;

    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final itemHeight = viewportHeight / (widget.crossAxisCount * widget.childAspectRatio);
    
    final firstVisibleIndex = (scrollOffset / itemHeight).floor() * widget.crossAxisCount;
    final lastVisibleIndex = ((scrollOffset + viewportHeight) / itemHeight).ceil() * widget.crossAxisCount;
    
    // Preload images for visible items plus threshold
    final startIndex = (firstVisibleIndex - _preloadThreshold).clamp(0, widget.recipes.length);
    final endIndex = (lastVisibleIndex + _preloadThreshold).clamp(0, widget.recipes.length);
    
    _preloadImagesInRange(startIndex, endIndex);
  }

  void _preloadImagesInRange(int startIndex, int endIndex) {
    final imageCacheService = ref.read(imageCacheServiceProvider.notifier);
    final imageUrls = <String>[];
    
    for (int i = startIndex; i < endIndex && i < widget.recipes.length; i++) {
      if (!_preloadedIndices.contains(i)) {
        _preloadedIndices.add(i);
        imageUrls.add(widget.recipes[i].imageUrl);
      }
    }
    
    if (imageUrls.isNotEmpty && mounted) {
      imageCacheService.preloadImages(imageUrls, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recipes.isEmpty && !widget.isLoading) {
      return _buildEmptyState();
    }

    return GridView.builder(
      controller: _scrollController,
      padding: widget.padding ?? EdgeInsets.all(ResponsiveUtils.spacing16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: ResponsiveUtils.spacing12,
        mainAxisSpacing: ResponsiveUtils.spacing12,
      ),
      itemCount: widget.recipes.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end if there are more items
        if (index >= widget.recipes.length) {
          return _buildLoadingItem();
        }

        final recipe = widget.recipes[index];
        return _LazyRecipeCard(
          recipe: recipe,
          onTap: () => widget.onRecipeTap(recipe),
          index: index,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: ResponsiveUtils.iconSize64,
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveUtils.spacing16),
          Text(
            'No recipes found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing8),
          Text(
            'Try adjusting your filters or search terms',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
          color: Colors.grey[100],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

/// Optimized recipe card with lazy loading and memory management
class _LazyRecipeCard extends ConsumerWidget {
  const _LazyRecipeCard({
    required this.recipe,
    required this.onTap,
    required this.index,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: RecipeCard(
        recipe: recipe,
        onTap: onTap,
        key: ValueKey('recipe_${recipe.id}_$index'),
      ),
    );
  }
}

/// Sliver version of the lazy recipe list for use in CustomScrollView
class SliverLazyRecipeList extends ConsumerStatefulWidget {
  const SliverLazyRecipeList({
    super.key,
    required this.recipes,
    required this.onRecipeTap,
    this.onLoadMore,
    this.isLoading = false,
    this.hasMore = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  final List<Recipe> recipes;
  final Function(Recipe) onRecipeTap;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  ConsumerState<SliverLazyRecipeList> createState() => _SliverLazyRecipeListState();
}

class _SliverLazyRecipeListState extends ConsumerState<SliverLazyRecipeList> {
  final Set<int> _preloadedIndices = {};
  static const int _preloadThreshold = 5;

  @override
  Widget build(BuildContext context) {
    if (widget.recipes.isEmpty && !widget.isLoading) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: ResponsiveUtils.spacing12,
        mainAxisSpacing: ResponsiveUtils.spacing12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= widget.recipes.length) {
            return _buildLoadingItem();
          }

          final recipe = widget.recipes[index];
          
          // Preload image if not already done
          _preloadImageIfNeeded(index);
          
          return _LazyRecipeCard(
            recipe: recipe,
            onTap: () => widget.onRecipeTap(recipe),
            index: index,
          );
        },
        childCount: widget.recipes.length + (widget.hasMore ? 1 : 0),
      ),
    );
  }

  void _preloadImageIfNeeded(int index) {
    if (_preloadedIndices.contains(index)) return;
    
    _preloadedIndices.add(index);
    final imageCacheService = ref.read(imageCacheServiceProvider.notifier);
    
    // Preload current image and a few ahead
    final imagesToPreload = <String>[];
    for (int i = index; i < (index + _preloadThreshold) && i < widget.recipes.length; i++) {
      if (!_preloadedIndices.contains(i)) {
        _preloadedIndices.add(i);
        imagesToPreload.add(widget.recipes[i].imageUrl);
      }
    }
    
    if (imagesToPreload.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          imageCacheService.preloadImages(imagesToPreload, context);
        }
      });
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_outlined,
            size: ResponsiveUtils.iconSize64,
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveUtils.spacing16),
          Text(
            'No recipes found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.radius16),
          color: Colors.grey[100],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}