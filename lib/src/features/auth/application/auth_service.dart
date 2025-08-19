import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/locale_controller.dart';
import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../routing/app_router.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../data/firebase_auth_repository.dart';
import '../data/user_repository.dart';
import '../domain/user.dart';

part 'auth_service.g.dart';

enum AuthenticationFormType { signIn, register }

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  // Getting necessary providers
  FirebaseAuthRepository get _authRepository =>
      ref.read(authRepositoryProvider);
  AnalyticsService get _analyticsService => ref.read(analyticsServiceProvider);
  UserRepository get _userRepository => ref.read(userRepositoryProvider);
  CacheService get _cacheService => ref.read(cacheServiceProvider.notifier);

  User? get currentUser => _authRepository.currentUser;

  /// Function used to either sign in or sign up using email
  Future<void> authenticate(
    String email,
    String password,
    String? displayName,
    AuthenticationFormType formType,
  ) async {
    switch (formType) {
      case AuthenticationFormType.signIn:
        try {
          await _authRepository.signInWithEmailAndPassword(email, password);
          await _analyticsService.logEvent(
            AnalyticsEvents.login,
            parameters: {'method': 'email'},
          );
          await _onLogin();
        } catch (error) {
          throw Exception(error);
        }
      case AuthenticationFormType.register:
        try {
          await _authRepository.createUserWithEmailAndPassword(email, password);
          await _analyticsService.logEvent(
            AnalyticsEvents.signUp,
            parameters: {'method': 'email'},
          );
          final currentUser = _authRepository.currentUser;
          if (currentUser != null) {
            if (displayName != null) {
              await _authRepository.updateProfile(displayName: displayName);
              ref.invalidate(authRepositoryProvider);
            }
            // _newUserController.setIsNewUser(true);
            // await _createFirestoreUserRecords();
            // await _onLogin();
          }
        } catch (e) {
          throw Exception(e);
        }
    }
  }

  /// Function used to authenticate with google
  Future<void> googleSignIn() async {
    try {
      final googleAuthCredentials = await _authRepository
          .getGoogleAuthCredentials();
      if (googleAuthCredentials != null) {
        await _authRepository.signInWithCredentials(googleAuthCredentials);

        await _analyticsService.logEvent(
          AnalyticsEvents.login,
          parameters: {'method': 'google'},
        );
        final isExistingUser = await _isUserAlreadyRegistered();
        if (isExistingUser != null) {
          await _onLogin();
        } else {
          await signOut();
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Function used to authenticate with apple
  Future<void> appleSignIn() async {
    try {
      final appleAuthCredentials = await _authRepository
          .getAppleAuthCredentials();
      await _authRepository.signInWithCredentials(appleAuthCredentials);

      await _analyticsService.logEvent(
        AnalyticsEvents.login,
        parameters: {'method': 'apple'},
      );
      final isExistingUser = await _isUserAlreadyRegistered();
      if (isExistingUser != null) {
        await _onLogin();
      } else {
        await signOut();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> googleSignUp() async {
    try {
      final googleAuthCredentials = await _authRepository
          .getGoogleAuthCredentials();
      if (googleAuthCredentials != null) {
        await _authRepository.signInWithCredentials(googleAuthCredentials);
        await _analyticsService.logEvent(
          AnalyticsEvents.signUp,
          parameters: {'method': 'google'},
        );
        final user = await _isUserAlreadyRegistered();
        // Checking if user is already registered
        // If user is already registered, we don't need to create new records
        if (user != null) {
          return;
        }
        await _createFirestoreUserRecords();
        await _onLogin();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> appleSignUp() async {
    try {
      final appleAuthCredentials = await _authRepository
          .getAppleAuthCredentials();
      await _authRepository.signInWithCredentials(appleAuthCredentials);
      final user = await _isUserAlreadyRegistered();
      // Checking if user is already registered
      // If user is already registered, we don't need to create new records
      if (user != null) {
        return;
      }
      await _createFirestoreUserRecords();
      await _onLogin();
      await _analyticsService.logEvent(
        AnalyticsEvents.signUp,
        parameters: {'method': 'apple'},
      );
      // Additional sign-up logic can be added here if needed
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Function used to send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      ref.read(cacheServiceProvider.notifier).clear();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Delete the user account
  Future<void> deleteAccount({required String? password}) async {
    final localization = AppLocalizations.of(rootNavigatorKey.currentContext!)!;
    try {
      final user = _authRepository.currentUser;

      if (user == null) {
        throw Exception(localization.noUserIsCurrentlyLoggedIn);
      }

      // Delete the user's firestore records
      await _userRepository.deleteUser(user.uid);

      // Delete the user's authentication account
      await _authRepository.deleteAccount(password: password ?? '');
    } catch (e) {
      throw Exception(localization.failedToDeleteAccount);
    }
  }

  /// HELPER METHODS
  Future<User?> _isUserAlreadyRegistered() async {
    final user = await _userRepository.fetchUser(currentUser?.uid ?? '');
    return user;
  }

  Future<void> _onLogin() async {
    if (currentUser == null) {
      return;
    }
    final userData = await _userRepository.fetchUser(currentUser!.uid);
    if (userData != null) {
      _cacheService.set(CacheKey.appUser, userData);
    }
    final babyProfile = await _userRepository.fetchBabyProfile(
      currentUser!.uid,
    );
    if (babyProfile != null) {
      _cacheService.set(CacheKey.babyProfile, babyProfile);
    }
  }

  Future<void> _createFirestoreUserRecords() async {
    final user = _authRepository.currentUser;
    if (user == null) {
      return;
    }
    final updatedUser = _createUser(user);
    await _userRepository.createUser(updatedUser);
    final babyProfile = ref.read(onboardingControllerProvider).babyProfile;
    await _userRepository.createBabyProfile(user.uid, babyProfile);
  }

  User _createUser(User user) {
    final userSettings = user.userSettings;
    final locale = ref.read(localeControllerProvider);
    final updatedUserSettings = userSettings.copyWith(appLangauge: locale);
    return user.copyWith(userSettings: updatedUserSettings);
  }
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref);
}
