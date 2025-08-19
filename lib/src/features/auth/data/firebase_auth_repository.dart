import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/user.dart';

part 'firebase_auth_repository.g.dart';

class FirebaseAuthRepository {
  FirebaseAuthRepository(this._auth, this._googleSignIn);
  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _mapFirebaseUser(_auth.currentUser);

  User? _mapFirebaseUser(firebase_auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      authProvider: user.providerData
          .map((userInfo) => userInfo.providerId)
          .toList(),
    );
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().map(_mapFirebaseUser);
  }

  Stream<User?> idTokenChanges() {
    return _auth.idTokenChanges().map(_mapFirebaseUser);
  }

  Future<User?> getCurrentUser() async {
    return _mapFirebaseUser(_auth.currentUser);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithCredentials(firebase_auth.AuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> deleteAccount({required String password}) async {
    try {
      if (currentUser == null) {
        throw Exception("No user is currently logged in");
      }

      final providers = getProviderData();

      if (providers.contains('password')) {
        final credential = firebase_auth.EmailAuthProvider.credential(
          email: currentUser!.email,
          password: password,
        );

        await _auth.currentUser!.reauthenticateWithCredential(credential);
      } else if (providers.contains('google.com')) {
        final googleCredential = await getGoogleAuthCredentials();
        if (googleCredential == null) {
          throw Exception(
            "Failed to get Google credentials for reauthentication",
          );
        }
        await _auth.currentUser!.reauthenticateWithCredential(googleCredential);
      } else if (providers.contains('apple.com')) {
        final appleCredential = await getAppleAuthCredentials();
        await _auth.currentUser!.reauthenticateWithCredential(appleCredential);
      } else {
        throw Exception("Unsupported authentication provider");
      }

      await _auth.currentUser!.delete();
    } catch (e) {
      throw Exception("Failed to delete account: $e");
    }
  }

  Future<void> resetPassword(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (currentUser == null) {
        throw "No user is currently logged in.";
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: currentUser!.email,
        password: oldPassword,
      );

      await _auth.currentUser!.reauthenticateWithCredential(credential);
      await _auth.currentUser!.updatePassword(newPassword);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<firebase_auth.AuthCredential> getAppleAuthCredentials() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
    return oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
  }

  Future<firebase_auth.AuthCredential?> getGoogleAuthCredentials() async {
    final googleSignInAuth = await _authenticateWithGoogle();
    if (googleSignInAuth != null) {
      return firebase_auth.GoogleAuthProvider.credential(
        idToken: googleSignInAuth.idToken,
      );
    }
    return null;
  }

  List<String> _getGoogleSignInScopes() {
    return [
      'email',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ];
  }

  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    await _googleSignIn.initialize(
      clientId:
          '852554518025-h05dk58e118kmjp9eb3uc3jm6fgbj4a8.apps.googleusercontent.com',
    );
    return _googleSignIn.authenticate(scopeHint: _getGoogleSignInScopes());
  }

  Future<GoogleSignInAuthentication?> _authenticateWithGoogle() async {
    final signInAccount = await _signInWithGoogle();
    return signInAccount?.authentication;
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      if (_auth.currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      if (displayName != null && displayName.isNotEmpty) {
        await _auth.currentUser!.updateDisplayName(displayName);
      }

      if (photoUrl != null && photoUrl.isNotEmpty) {
        await _auth.currentUser!.updatePhotoURL(photoUrl);
      }

      await _auth.currentUser!.reload();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  List<String> getProviderData() {
    final user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    return user.providerData.map((userInfo) => userInfo.providerId).toList();
  }

  bool canChangePassword() {
    final providers = getProviderData();
    return providers.contains('password') &&
        !providers.contains('google.com') &&
        !providers.contains('apple.com');
  }
}

@riverpod
FirebaseAuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(
    firebase_auth.FirebaseAuth.instance,
    GoogleSignIn.instance,
  );
}

@riverpod
Stream<User?> idTokenChanges(Ref ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.idTokenChanges();
}
