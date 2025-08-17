// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recipeDetailControllerHash() =>
    r'5000378e4256d71ea870e2f0aaac858d98a86f38';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RecipeDetailController
    extends BuildlessAutoDisposeNotifier<RecipeDetailState> {
  late final String recipeId;

  RecipeDetailState build(String recipeId);
}

/// See also [RecipeDetailController].
@ProviderFor(RecipeDetailController)
const recipeDetailControllerProvider = RecipeDetailControllerFamily();

/// See also [RecipeDetailController].
class RecipeDetailControllerFamily extends Family<RecipeDetailState> {
  /// See also [RecipeDetailController].
  const RecipeDetailControllerFamily();

  /// See also [RecipeDetailController].
  RecipeDetailControllerProvider call(String recipeId) {
    return RecipeDetailControllerProvider(recipeId);
  }

  @override
  RecipeDetailControllerProvider getProviderOverride(
    covariant RecipeDetailControllerProvider provider,
  ) {
    return call(provider.recipeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recipeDetailControllerProvider';
}

/// See also [RecipeDetailController].
class RecipeDetailControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RecipeDetailController,
          RecipeDetailState
        > {
  /// See also [RecipeDetailController].
  RecipeDetailControllerProvider(String recipeId)
    : this._internal(
        () => RecipeDetailController()..recipeId = recipeId,
        from: recipeDetailControllerProvider,
        name: r'recipeDetailControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recipeDetailControllerHash,
        dependencies: RecipeDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            RecipeDetailControllerFamily._allTransitiveDependencies,
        recipeId: recipeId,
      );

  RecipeDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.recipeId,
  }) : super.internal();

  final String recipeId;

  @override
  RecipeDetailState runNotifierBuild(
    covariant RecipeDetailController notifier,
  ) {
    return notifier.build(recipeId);
  }

  @override
  Override overrideWith(RecipeDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecipeDetailControllerProvider._internal(
        () => create()..recipeId = recipeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        recipeId: recipeId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RecipeDetailController, RecipeDetailState>
  createElement() {
    return _RecipeDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipeDetailControllerProvider &&
        other.recipeId == recipeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, recipeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecipeDetailControllerRef
    on AutoDisposeNotifierProviderRef<RecipeDetailState> {
  /// The parameter `recipeId` of this provider.
  String get recipeId;
}

class _RecipeDetailControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RecipeDetailController,
          RecipeDetailState
        >
    with RecipeDetailControllerRef {
  _RecipeDetailControllerProviderElement(super.provider);

  @override
  String get recipeId => (origin as RecipeDetailControllerProvider).recipeId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
