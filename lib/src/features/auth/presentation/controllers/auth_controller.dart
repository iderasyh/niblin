import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/auth_service.dart';
import '../../data/firebase_auth_repository.dart' as auth_repo;
import '../../domain/user.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  AuthService get _authService => ref.read(authServiceProvider);

  Future<bool> submit({
    required String email,
    required String password,
    String? displayName,
    required AuthenticationFormType formType,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authService.authenticate(email, password, displayName, formType);
    });

    return !state.hasError;
  }

  /// Sign in with Google
  Future<bool> googleSignIn() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authService.googleSignIn();
    });

    return !state.hasError;
  }

  /// Sign in with Apple
  Future<bool> appleSignIn() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authService.appleSignIn();
    });

    return !state.hasError;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        await _authService.sendPasswordResetEmail(email);
      } catch (e) {
        rethrow;
      }
    });
    return !state.hasError;
  }

  Future<bool> deleteAccount({required String? password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        await _authService.deleteAccount(password: password);
      } catch (e) {
        rethrow;
      }
    });
    return !state.hasError;
  }

  /// Sign out the current user
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        await _authService.signOut();
      } catch (e) {
        rethrow;
      }
    });
  }
}

/// Get the current app user
@riverpod
User? currentUser(Ref ref) {
  return ref.watch(auth_repo.authRepositoryProvider).currentUser;
}
