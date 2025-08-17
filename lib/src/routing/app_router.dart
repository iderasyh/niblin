import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_bootstrap/app_startup.dart';
import '../bottom_nav_bar/explore_screen.dart';
import '../bottom_nav_bar/home_screen.dart';
import '../bottom_nav_bar/plan_screen.dart';
import '../bottom_nav_bar/tracker_screen.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/onboarding/presentation/screens/emotional_hook_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/recipes/presentation/screens/recipe_list_screen.dart';
import '../features/recipes/presentation/screens/recipe_detail_screen.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';
import 'go_router_refresh_stream.dart';

// --- AppRoute Enum ---
enum AppRoute {
  startup('/startup'),

  welcome('/'),
  signIn('/sign-in'),
  signUp('/sign-up'),
  forgotPassword('/forgot-password'),

  // Bottom nav bar routes
  home('/home'),
  explore('/explore'),
  plan('/plan'),
  tracker('/tracker'),

  // Onboarding
  onboarding('/onboarding'),
  paywall('/paywall'),

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

final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
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

      final isSignedIn = authRepository.currentUser != null;
      final currentLocation = state.matchedLocation;

      // --- Define unauthenticated routes/prefixes ---
      final unauthenticatedPaths = {
        AppRoute.onboarding.path,
        AppRoute.signIn.path,
        AppRoute.signUp.path,
        AppRoute.forgotPassword.path,
      };

      // Redirect logic
      if (!isSignedIn &&
          !unauthenticatedPaths
              .where((path) => path != AppRoute.onboarding.path)
              .any((path) => currentLocation.startsWith(path))) {
        // If not signed in and trying to access a path not in unauthenticatedPaths,
        // redirect to onboarding.
        return AppRoute.onboarding.path;
      }

      // Check if signed in and trying to access an unauthenticated path (excluding onboarding '/' and paywall)
      if (isSignedIn &&
          unauthenticatedPaths
              .where(
                (path) =>
                    path != AppRoute.onboarding.path &&
                    path != AppRoute.paywall.path,
              ) // Exclude '/' and paywall
              .any((path) => currentLocation.startsWith(path))) {
        // Check startsWith for others (like /sign-in, /questionnaire)
        // If signed in and trying to access an unauthenticated path (like sign-in, sign-up, questionnaire),
        // redirect to the home screen within the shell.
        // Paywall is allowed for both authenticated and unauthenticated users
        return AppRoute
            .home
            .path; // Redirect to the base path of the ShellRoute
      }

      // Special case: If signed in and at the root onboarding path, redirect to shell base path
      if (isSignedIn && currentLocation == AppRoute.onboarding.path) {
        return AppRoute.home.path;
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home Tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey, // Use shell key for this branch
            routes: [
              GoRoute(
                path: AppRoute.home.path, // Base path for the shell
                name: AppRoute.home.name, // Name for navigation
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 2: Explore Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.explore.path, // Base path for the shell
                name: AppRoute.explore.name, // Name for navigation
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          // Branch 3: Plan Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.plan.path, // Base path for the shell
                name: AppRoute.plan.name, // Name for navigation
                builder: (context, state) => const PlanScreen(),
              ),
            ],
          ),
          // Branch 4: Tracker Tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.tracker.path, // Base path for the shell
                name: AppRoute.tracker.name, // Name for navigation
                builder: (context, state) => const TrackerScreen(),
              ),
            ],
          ),
        ],
      ),
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
