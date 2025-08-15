import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../routing/app_router.dart';
import '../data/firebase_auth_repository.dart';

part 'auth_service.g.dart';

enum AuthenticationFormType { signIn, register }

class AuthService {
  final Ref ref;

  AuthService(this.ref);

  // Getting necessary providers
  FirebaseAuthRepository get _authRepository =>
      ref.read(authRepositoryProvider);
  AnalyticsService get _analyticsService => ref.read(analyticsServiceProvider);

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
          final currentUser = _authRepository.currentUser;
          if (currentUser != null) {
            // final appUser = await _userRepository.fetchUser(currentUser.id);
            // if (appUser != null) {
            //   await _onLogin();
            // }
          }
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
        // await _onLogin();
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
      // await _onLogin();
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
      ref.read(cacheServiceProvider.notifier).resetState();
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

      // Delete the user's authentication account
      await _authRepository.deleteAccount(password: password ?? '');
    } catch (e) {
      throw Exception(localization.failedToDeleteAccount);
    }
  }
}

@riverpod
AuthService authService(Ref ref) {
  return AuthService(ref);
}
