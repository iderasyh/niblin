import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../l10n/app_localizations.dart';
import '../../l10n/locale_controller.dart';
import '../core/common_widgets.dart/loading_indicator.dart';
import '../core/constants/app_colors.dart';
import '../core/services/cache_service.dart';
import '../core/utils/shared_preferences_provider.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/data/user_repository.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
FutureOr<void> appStartup(Ref ref) async {
  // Functions called despite the user is not logged in or not
  await ref.read(sharedPreferencesProvider.future);
  final localeController = ref.read(localeControllerProvider.notifier);
  await localeController.initialize();

  final user = ref.read(authRepositoryProvider).currentUser;
  if (user == null) {
    return;
  }

  final cacheService = ref.read(cacheServiceProvider.notifier);

  // Functions called if the user is logged in
  final babyProfile = await ref
      .read(userRepositoryProvider)
      .fetchBabyProfile(user.uid);

  if (babyProfile != null) {
    cacheService.set(CacheKey.babyProfile, babyProfile);
  }

  return;
}

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key, required this.onLoaded});
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: appStartupState.when(
        data: (_) => onLoaded(context),
        error: (error, stack) => AppStartupErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(appStartupProvider),
        ),
        loading: () => const AppStartupLoadingWidget(),
      ),
    );
  }
}

class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const LoadingIndicator(),
    );
  }
}

class AppStartupErrorWidget extends StatelessWidget {
  const AppStartupErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(localization.retry)),
          ],
        ),
      ),
    );
  }
}
