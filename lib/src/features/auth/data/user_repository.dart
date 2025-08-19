import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../../meal_plan/data/meal_plan_repository.dart';
import '../../onboarding/domain/baby_profile.dart';
import '../../progress/data/progress_repository.dart';
import '../domain/user.dart';

part 'user_repository.g.dart';

class UserRepository {
  const UserRepository(this._firestore, this._ref);
  final FirebaseFirestore _firestore;
  final Ref _ref;

  // --- Path Helpers ---

  static String _userPath(String userId) =>
      '${FirebaseConsts.usersCollection}/$userId';
  static String _babyProfilePath(String userId) =>
      '${_userPath(userId)}/${FirebaseConsts.babyProfile}/${FirebaseConsts.dataDoc}';

  // --- Document Reference Helpers with Converters ---

  DocumentReference<User> _userDocRef(String userId) => _firestore
      .doc(_userPath(userId))
      .withConverter(
        fromFirestore: (snapshot, options) => User.fromMap(snapshot.data()!),
        toFirestore: (user, _) => user.toMap(),
      );

  DocumentReference<BabyProfile> _babyProfileDocRef(String userId) => _firestore
      .doc(_babyProfilePath(userId))
      .withConverter(
        fromFirestore: (snapshot, _) => BabyProfile.fromMap(snapshot.data()!),
        toFirestore: (model, _) => model.toMap(),
      );

  // --- CRUD OPERATIONS ---

  // --- USER ---
  Future<void> createUser(User user) => _userDocRef(user.uid).set(user);

  Stream<User?> watchUser(String userId) =>
      _userDocRef(userId).snapshots().map((snapshot) => snapshot.data());

  Future<User?> fetchUser(String userId) async {
    final snapshot = await _userDocRef(userId).get();
    return snapshot.data();
  }

  Future<void> updateUser(User user) =>
      _userDocRef(user.uid).set(user, SetOptions(merge: true));

  // --- BABY PROFILE ---
  Future<void> createBabyProfile(String uid, BabyProfile babyProfile) =>
      _babyProfileDocRef(uid).set(babyProfile);

  Stream<BabyProfile?> watchBabyProfile(String userId) =>
      _babyProfileDocRef(userId).snapshots().map((snapshot) => snapshot.data());

  Future<BabyProfile?> fetchBabyProfile(String userId) async {
    final snapshot = await _babyProfileDocRef(userId).get();
    return snapshot.data();
  }

  Future<void> updateBabyProfile(String uid, BabyProfile babyProfile) =>
      _babyProfileDocRef(uid).set(babyProfile, SetOptions(merge: true));

  // --- DELETE USER AND ALL ITS SUBCOLLECTIONS ---
  Future<void> deleteUser(String userId) async {
    await _babyProfileDocRef(userId).delete();
    await _userDocRef(userId).delete();
    await _ref
        .read(mealPlanRepositoryProvider)
        .deleteMealPlanCollection(userId);
    await _ref
        .read(progressRepositoryProvider)
        .deleteProgressCollection();
  }
}

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance, ref);
}
