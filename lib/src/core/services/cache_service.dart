import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_service.g.dart';

enum CacheKey {
  appUser,
  babyProfile,
  // Recipe keys
  recipesByStage,
  recipeById,
  userFavorites,
}

@Riverpod(keepAlive: true)
class CacheService extends _$CacheService {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  /// Set cache entry
  void set(CacheKey key, dynamic value) {
    final newState = Map<String, dynamic>.from(state);
    newState[key.name] = value;
    state = newState;
  }

  /// Set cache entry with suffix (for parameterized caching)
  void setWithSuffix(CacheKey key, String suffix, dynamic value) {
    final cacheKey = '${key.name}_$suffix';
    final newState = Map<String, dynamic>.from(state);
    newState[cacheKey] = value;
    state = newState;
  }

  /// Get cache entry
  T? get<T>(CacheKey key) {
    return state[key.name] as T?;
  }

  /// Get cache entry with suffix
  T? getWithSuffix<T>(CacheKey key, String suffix) {
    final cacheKey = '${key.name}_$suffix';
    return state[cacheKey] as T?;
  }

  /// Remove cache entry
  void remove(CacheKey key) {
    final newState = Map<String, dynamic>.from(state);
    newState.remove(key.name);
    state = newState;
  }

  /// Remove cache entry with suffix
  void removeWithSuffix(CacheKey key, String suffix) {
    final cacheKey = '${key.name}_$suffix';
    final newState = Map<String, dynamic>.from(state);
    newState.remove(cacheKey);
    state = newState;
  }

  /// Clear all entries for a cache key prefix
  void clearByKeyPrefix(CacheKey key) {
    final prefix = key.name;
    final newState = Map<String, dynamic>.from(state);
    final keysToRemove = newState.keys
        .where((k) => k.startsWith(prefix))
        .toList();

    for (final keyToRemove in keysToRemove) {
      newState.remove(keyToRemove);
    }

    state = newState;
  }

  /// Clear all cache
  void clear() {
    state = {};
  }
}
