import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cache_service.g.dart';

enum CacheKey {
  appUser,
}

@Riverpod(keepAlive: true)
class CacheService extends _$CacheService {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void set(CacheKey key, dynamic value) {
    state = {...state, key.name: value};
  }

  void resetState() {
    state = {};
  }
}
