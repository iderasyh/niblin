import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../../auth/data/firebase_auth_repository.dart';
import '../../auth/domain/user.dart';
import '../domain/baby_profile.dart';

part 'onboarding_repository.g.dart';

class OnboardingRepository {
  const OnboardingRepository(this._firestore, this.ref);

  final FirebaseFirestore _firestore;
  final Ref ref;

  static String _usersPath() => FirebaseConsts.usersCollection;
  static String _onboardingCollectionPath(String userId) =>
      '${_usersPath()}/$userId/${FirebaseConsts.onboardingCollection}';
  static String _babyProfileDocPath(String userId) =>
      '${_onboardingCollectionPath(userId)}/${FirebaseConsts.babyProfileDoc}';
  static String _metaDocPath(String userId) =>
      '${_onboardingCollectionPath(userId)}/${FirebaseConsts.metaDoc}';

  DocumentReference<BabyProfile> _babyProfileDocRef(String userId) =>
      _firestore.doc(_babyProfileDocPath(userId)).withConverter(
            fromFirestore: (snapshot, _) =>
                BabyProfile.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap(),
          );

  DocumentReference<Map<String, dynamic>> _metaDocRef(String userId) =>
      _firestore.doc(_metaDocPath(userId));

  User? get _currentUser => ref.read(authRepositoryProvider).currentUser;

  String get _currentUserId {
    final user = _currentUser;
    if (user == null) {
      throw StateError('No authenticated user found');
    }
    return user.id;
    
  }

  Future<void> saveBabyProfile(BabyProfile profile) async {
    final uid = _currentUserId;
    await _babyProfileDocRef(uid).set(profile);
  }

  Future<BabyProfile?> fetchBabyProfile() async {
    final uid = _currentUserId;
    final snapshot = await _babyProfileDocRef(uid).get();
    return snapshot.data();
  }

  Stream<BabyProfile?> watchBabyProfile() {
    final uid = _currentUserId;
    return _babyProfileDocRef(uid).snapshots().map((s) => s.data());
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final uid = _currentUserId;
    await _metaDocRef(uid).set(
      <String, dynamic>{
        FirebaseConsts.completedField: completed,
        FirebaseConsts.updatedAtField: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<bool> fetchOnboardingCompleted() async {
    final uid = _currentUserId;
    final snapshot = await _metaDocRef(uid).get();
    return (snapshot.data()?[FirebaseConsts.completedField] as bool?) ?? false;
  }

  Stream<bool> watchOnboardingCompleted() {
    final uid = _currentUserId;
    return _metaDocRef(uid)
        .snapshots()
        .map((s) => (s.data()?[FirebaseConsts.completedField] as bool?) ?? false);
  }
}

@riverpod
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepository(FirebaseFirestore.instance, ref);
}

@riverpod
Stream<BabyProfile?> watchBabyProfile(Ref ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return repository.watchBabyProfile();
}


