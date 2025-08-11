import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/data/firebase_auth_repository.dart';
import '../features/onboarding/presentation/screens/emotional_hook_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import 'go_router_refresh_stream.dart';

// --- AppRoute Enum ---
enum AppRoute {
  startup('/startup'),

  welcome('/'),
  signIn('/sign-in'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),
  changePassword('/change-password'),

  // Onboarding
  onboarding('/onboarding');

  const AppRoute(this.path);
  final String path;
}

// --- Navigator Keys ---
// Use separate keys for the root navigator and the shell navigator
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GoRouter(
    initialLocation: AppRoute.welcome.path,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: AppRoute.welcome.path,
        name: AppRoute.welcome.name,
        builder: (context, state) => const EmotionalHookScreen(),
      ),
      GoRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
});
