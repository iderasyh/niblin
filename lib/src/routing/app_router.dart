import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_bootstrap/app_startup.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/onboarding/presentation/screens/emotional_hook_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/recipes/presentation/screens/recipe_list_screen.dart';
import '../features/recipes/presentation/screens/recipe_detail_screen.dart';
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
  onboarding('/onboarding'),

  // Recipes
  recipes('/recipes'),
  recipeDetail('/recipes/:recipeId');

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

  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    initialLocation: AppRoute.welcome.path,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) {
      if (appStartupState.isLoading) {
        return AppRoute.startup.path;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.startup.path,
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            // * This is just a placeholder
            // * The loaded route will be managed by GoRouter on state change
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoute.welcome.path,
        name: AppRoute.welcome.name,
        builder: (context, state) => const EmotionalHookScreen(),
      ),

      GoRoute(
        path: AppRoute.signIn.path,
        name: AppRoute.signIn.name,
        builder: (context, state) => const SignInScreen(),
        routes: [
          GoRoute(
            path: AppRoute.forgotPassword.path,
            name: AppRoute.forgotPassword.name,
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        name: AppRoute.signUp.name,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Recipe routes
      GoRoute(
        path: AppRoute.recipes.path,
        name: AppRoute.recipes.name,
        builder: (context, state) {
          // Handle optional query parameters for category and search
          final category = state.uri.queryParameters['category'];
          final search = state.uri.queryParameters['search'];
          return RecipeListScreen(
            initialCategory: category,
            initialSearch: search,
          );
        },
        routes: [
          GoRoute(
            path: '/:recipeId',
            name: AppRoute.recipeDetail.name,
            builder: (context, state) {
              final recipeId = state.pathParameters['recipeId']!;
              return RecipeDetailScreen(recipeId: recipeId);
            },
          ),
        ],
      ),
    ],
  );
});
