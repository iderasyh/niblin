import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../../auth/data/firebase_auth_repository.dart';
import '../domain/meal_plan.dart';

part 'meal_plan_repository.g.dart';

class MealPlanRepository {
  const MealPlanRepository(this._firestore, this.ref);
  final FirebaseFirestore _firestore;
  final Ref ref;

  // --- Path Helpers ---

  static String _userPath(String userId) =>
      '${FirebaseConsts.usersCollection}/$userId';
  static String _mealPlanCollectionPath(String userId) =>
      '${_userPath(userId)}/${FirebaseConsts.mealPlan}';
  static String _mealPlanPath(String userId, String mealPlanId) =>
      '$_mealPlanCollectionPath($userId)/$mealPlanId';

  // --- Document and Collection Reference Helpers with Converters ---

  DocumentReference<MealPlan> _mealPlanDocRef(
    String userId,
    String mealPlanId,
  ) => _firestore
      .doc(_mealPlanPath(userId, mealPlanId))
      .withConverter(
        fromFirestore: (snapshot, options) =>
            MealPlan.fromMap(snapshot.data()!),
        toFirestore: (mealPlan, _) => mealPlan.toMap(),
      );
  CollectionReference<MealPlan> _mealPlansCollectionRef(String userId) =>
      _firestore
          .collection(_mealPlanCollectionPath(userId))
          .withConverter(
            fromFirestore: (snapshot, options) =>
                MealPlan.fromMap(snapshot.data()!),
            toFirestore: (mealPlan, _) => mealPlan.toMap(),
          );

  // --- Create ---

  Future<void> createMealPlan(MealPlan mealPlan) async {
    await _mealPlanDocRef(mealPlan.uid, mealPlan.id).set(mealPlan);
  }

  // --- Read ---

  Future<MealPlan?> fetchMealPlan(String userId, String mealPlanId) async {
    final snapshot = await _mealPlanDocRef(userId, mealPlanId).get();
    return snapshot.data();
  }

  // --- Update ---

  Future<void> updateMealPlan(MealPlan mealPlan) async {
    await _mealPlanDocRef(mealPlan.uid, mealPlan.id).set(mealPlan);
  }

  // --- Delete ---

  Future<void> deleteMealPlanCollection(String userId) async {
    await _firestore.collection(_mealPlanCollectionPath(userId)).get().then((
      snapshot,
    ) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  Future<void> deleteMealPlan(String userId, String mealPlanId) async {
    await _mealPlanDocRef(userId, mealPlanId).delete();
  }

  // --- Watch ---

  Stream<MealPlan?> watchMealPlan(String userId, String mealPlanId) =>
      _mealPlanDocRef(
        userId,
        mealPlanId,
      ).snapshots().map((snapshot) => snapshot.data());

  Stream<MealPlan?> watchMealPlanForCurrentWeek() {
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) {
      return Stream.value(null);
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeekday = today.weekday;
    final startOfWeek = today.subtract(Duration(days: currentWeekday - 1));

    return _mealPlansCollectionRef(userId)
        .where('startDate', isEqualTo: startOfWeek.millisecondsSinceEpoch)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.data();
          }
          return null;
        });
  }
}

@riverpod
MealPlanRepository mealPlanRepository(Ref ref) {
  return MealPlanRepository(FirebaseFirestore.instance, ref);
}

@riverpod
Stream<MealPlan?> watchCurrentWeekMealPlan(Ref ref) {
  final mealPlanRepository = ref.watch(mealPlanRepositoryProvider);
  return mealPlanRepository.watchMealPlanForCurrentWeek();
}
