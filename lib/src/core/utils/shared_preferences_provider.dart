// ignore_for_file: constant_identifier_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

// Enum class for type safety while saving in local storage
// and getting from it
enum SharedPreferencesKeys { locale, recipes, userRecipesData }

class SharedPreferencesProvider {
  const SharedPreferencesProvider(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;

  Future<void> saveString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  String? getString(String key) => _sharedPreferences.getString(key);

  Future<void> saveInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);

  int? getInt(String key) => _sharedPreferences.getInt(key);

  Future<void> saveBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  bool? getBool(String key) => _sharedPreferences.getBool(key);

  Future<void> saveDouble(String key, double value) =>
      _sharedPreferences.setDouble(key, value);

  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  Future<void> saveStringList(String key, List<String> value) =>
      _sharedPreferences.setStringList(key, value);

  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  Future<void> removeData(String key) => _sharedPreferences.remove(key);

  Future<void> clearAllData() => _sharedPreferences.clear();
}

@Riverpod(keepAlive: true)
FutureOr<SharedPreferencesProvider> sharedPreferences(Ref ref) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  return SharedPreferencesProvider(sharedPreferences);
}

@Riverpod(keepAlive: true)
SharedPreferencesProvider getSharedPreferences(Ref ref) {
  // Getting shared preferences provider
  final sharedPreferences = ref.read(sharedPreferencesProvider);
  // Checking if shared preferences has started
  if (!sharedPreferences.hasValue) {
    ref.invalidate(sharedPreferencesProvider);
  }
  // Returning the value of shared preferences
  return sharedPreferences.requireValue;
}
