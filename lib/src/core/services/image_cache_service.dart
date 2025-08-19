import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../common_widgets.dart/loading_indicator.dart';
import '../constants/app_colors.dart';

part 'image_cache_service.g.dart';

@Riverpod(keepAlive: true)
class ImageCacheService extends _$ImageCacheService {
  @override
  DefaultCacheManager build() {
    return DefaultCacheManager();
  }

  /// Get a cached network image widget
  Widget getCachedImage({
    required String imageUrl,
    required double width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableProgressiveLoading = false,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheManager: state,
      progressIndicatorBuilder: (context, url, progress) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Center(child: LoadingIndicator()),
      ),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget
          : (context, url, error) => Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: Icon(PhosphorIcons.bug(), color: AppColors.error),
            ),
    );
  }

  /// Preload images for better performance
  Future<void> preloadImages(
    List<String> imageUrls,
    BuildContext context,
  ) async {
    for (final imageUrl in imageUrls) {
      try {
        await precacheImage(
          CachedNetworkImageProvider(imageUrl, cacheManager: state),
          context,
        );
      } catch (e) {
        // Silently handle preload errors
        debugPrint('Failed to preload image: $imageUrl, error: $e');
      }
    }
  }

  /// Clear the image cache
  Future<void> clearImageCache() async {
    await state.emptyCache();
  }
}
