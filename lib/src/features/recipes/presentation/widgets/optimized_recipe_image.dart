import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/image_cache_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';

/// Optimized image widget for recipe detail screens with progressive loading
/// and multiple size variants for different screen sizes
class OptimizedRecipeImage extends ConsumerWidget {
  const OptimizedRecipeImage({
    super.key,
    required this.imageUrl,
    this.videoUrl,
    this.width,
    this.height,
    this.aspectRatio = 16 / 9,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.showPlayButton = false,
    this.onVideoTap,
    this.enableHeroAnimation = false,
    this.heroTag,
  });

  final String imageUrl;
  final String? videoUrl;
  final double? width;
  final double? height;
  final double aspectRatio;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool showPlayButton;
  final VoidCallback? onVideoTap;
  final bool enableHeroAnimation;
  final String? heroTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageCacheService = ref.read(imageCacheServiceProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Calculate optimal image dimensions based on screen size
    final imageWidth = width ?? screenWidth;
    final imageHeight = height ?? (imageWidth / aspectRatio);

    Widget imageWidget = imageCacheService.getCachedImage(
      imageUrl: imageUrl,
      width: imageWidth,
      height: imageHeight,
      fit: fit,
      placeholder: _buildProgressivePlaceholder(imageWidth, imageHeight),
      errorWidget: _buildErrorWidget(imageWidth, imageHeight),
    );

    // Apply border radius if specified
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    // Add video overlay if video URL is provided
    if (videoUrl != null && showPlayButton) {
      imageWidget = _buildVideoOverlay(imageWidget);
    }

    // Wrap with hero animation if enabled
    if (enableHeroAnimation && heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: imageWidget,
    );
  }

  Widget _buildProgressivePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          // Shimmer effect background
          _buildShimmerBackground(width, height),
          
          // Loading indicator
          const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBackground(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neutralLight,
            AppColors.neutralLight.withValues(alpha: 0.5),
            AppColors.neutralLight,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColors.neutralLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: ResponsiveUtils.iconSize48,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: ResponsiveUtils.spacing8),
          Text(
            'Image unavailable',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoOverlay(Widget imageWidget) {
    return Stack(
      children: [
        imageWidget,
        
        // Dark overlay
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: borderRadius,
          ),
        ),
        
        // Play button
        Center(
          child: GestureDetector(
            onTap: onVideoTap,
            child: Container(
              width: ResponsiveUtils.iconSize64,
              height: ResponsiveUtils.iconSize64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.play_arrow,
                size: ResponsiveUtils.iconSize32,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        
        // Video indicator badge
        Positioned(
          top: ResponsiveUtils.spacing8,
          right: ResponsiveUtils.spacing8,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.spacing8,
              vertical: ResponsiveUtils.spacing4,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(ResponsiveUtils.radius12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam,
                  size: ResponsiveUtils.iconSize12,
                  color: Colors.white,
                ),
                SizedBox(width: ResponsiveUtils.spacing4),
                Text(
                  'Video',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Specialized hero image widget for recipe detail screens
class RecipeHeroImage extends ConsumerWidget {
  const RecipeHeroImage({
    super.key,
    required this.imageUrl,
    this.videoUrl,
    this.onVideoTap,
    this.height,
  });

  final String imageUrl;
  final String? videoUrl;
  final VoidCallback? onVideoTap;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final heroHeight = height ?? screenSize.height * 0.4;

    return OptimizedRecipeImage(
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      width: screenSize.width,
      height: heroHeight,
      fit: BoxFit.cover,
      showPlayButton: videoUrl != null,
      onVideoTap: onVideoTap,
      enableHeroAnimation: true,
      heroTag: 'recipe_hero_$imageUrl',
    );
  }
}

/// Grid-optimized image widget for recipe lists
class RecipeGridImage extends ConsumerWidget {
  const RecipeGridImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 1.0,
    this.borderRadius,
  });

  final String imageUrl;
  final double aspectRatio;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: OptimizedRecipeImage(
        imageUrl: imageUrl,
        aspectRatio: aspectRatio,
        fit: BoxFit.cover,
        borderRadius: borderRadius ?? BorderRadius.circular(ResponsiveUtils.radius8),
        enableHeroAnimation: true,
        heroTag: 'recipe_grid_$imageUrl',
      ),
    );
  }
}

/// Thumbnail image widget for small recipe previews
class RecipeThumbnail extends ConsumerWidget {
  const RecipeThumbnail({
    super.key,
    required this.imageUrl,
    this.size = 60,
    this.borderRadius,
  });

  final String imageUrl;
  final double size;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptimizedRecipeImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: borderRadius ?? BorderRadius.circular(ResponsiveUtils.radius8),
    );
  }
}