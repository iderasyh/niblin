import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../src/core/utils/shared_preferences_provider.dart';

part 'locale_controller.g.dart';

@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  String build() {
    return 'en';
  }

  Future<void> initialize() async {
    final sharedPreferences = ref.read(getSharedPreferencesProvider);
    final locale = sharedPreferences.getString(SharedPreferencesKeys.locale.name);
    if (locale != null) {
      state = locale;
    }
  }

  Future<void> setLocale(String locale) async {
    state = locale;
    await ref
        .read(getSharedPreferencesProvider)
        .saveString(SharedPreferencesKeys.locale.name, locale);
  }
}
