import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../domain/user_recipe_data.dart';
import 'user_recipe_repository.dart';

part 'firebase_user_recipe_repository.g.dart';

/// Firebase implementation of UserRecipeRepository
class FirebaseUserRecipeRepository implements UserRecipeRepository {
  FirebaseUserRecipeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _userRecipeDataCollection =>
      _firestore.collection(FirebaseConsts.userRecipeDataCollection);

  /// Get document reference for user recipe data
  DocumentReference<Map<String, dynamic>> _getUserRecipeDoc(
    String userId,
    String recipeId,
  ) {
    return _userRecipeDataCollection.doc('${userId}_$recipeId');
  }

  @override
  Future<UserRecipeData?> getUserRecipeData(
    String userId,
    String recipeId,
  ) async {
    try {
      final docSnapshot = await _getUserRecipeDoc(userId, recipeId).get();

      if (!docSnapshot.exists) {
        // Return default UserRecipeData if document doesn't exist
        return UserRecipeData(userId: userId, recipeId: recipeId);
      }

      return UserRecipeData.fromMap(docSnapshot.data()!);
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to get user recipe data: $e',
      );
    }
  }

  @override
  Future<void> updateUserRecipeData(UserRecipeData data) async {
    try {
      final docRef = _getUserRecipeDoc(data.userId, data.recipeId);
      
      // Use merge to handle concurrent updates gracefully
      await docRef.set(
        data.toMap(),
        SetOptions(merge: true),
      );
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to update user recipe data: $e',
      );
    }
  }

  @override
  Future<List<String>> getFavoriteRecipeIds(String userId) async {
    try {
      final querySnapshot = await _userRecipeDataCollection
          .where('userId', isEqualTo: userId)
          .where('isFavorite', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['recipeId'] as String)
          .toList();
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to get favorite recipe IDs: $e',
      );
    }
  }

  @override
  Future<List<String>> getTriedRecipeIds(String userId) async {
    try {
      final querySnapshot = await _userRecipeDataCollection
          .where('userId', isEqualTo: userId)
          .where('hasTried', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['recipeId'] as String)
          .toList();
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to get tried recipe IDs: $e',
      );
    }
  }

  @override
  Future<List<UserRecipeData>> getAllUserRecipeData(String userId) async {
    try {
      final querySnapshot = await _userRecipeDataCollection
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => UserRecipeData.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to get all user recipe data: $e',
      );
    }
  }

  @override
  Future<void> addToMealPlan(
    String userId,
    String recipeId,
    DateTime date,
  ) async {
    try {
      final docRef = _getUserRecipeDoc(userId, recipeId);
      
      // Get existing data or create new
      final existingDoc = await docRef.get();
      UserRecipeData data;
      
      if (existingDoc.exists) {
        data = UserRecipeData.fromMap(existingDoc.data()!);
      } else {
        data = UserRecipeData(userId: userId, recipeId: recipeId);
      }

      final updatedData = data.addToMealPlan(date);
      await docRef.set(updatedData.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to add to meal plan: $e',
      );
    }
  }

  @override
  Future<void> removeFromMealPlan(String userId, String recipeId) async {
    try {
      final docRef = _getUserRecipeDoc(userId, recipeId);
      
      // Get existing data
      final existingDoc = await docRef.get();
      if (!existingDoc.exists) return;

      final data = UserRecipeData.fromMap(existingDoc.data()!);
      final updatedData = data.removeFromMealPlan();
      
      await docRef.set(updatedData.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to remove from meal plan: $e',
      );
    }
  }

  @override
  Future<List<String>> getMealPlanRecipeIds(
    String userId,
    DateTime date,
  ) async {
    try {
      // Normalize date to start of day for consistent querying
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _userRecipeDataCollection
          .where('userId', isEqualTo: userId)
          .where('isInMealPlan', isEqualTo: true)
          .where('mealPlanDate', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('mealPlanDate', isLessThan: endOfDay.toIso8601String())
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['recipeId'] as String)
          .toList();
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to get meal plan recipe IDs: $e',
      );
    }
  }

  @override
  Future<Map<DateTime, List<String>>> getMealPlanRecipeIdsForDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Normalize dates
      final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day)
          .add(const Duration(days: 1));

      final querySnapshot = await _userRecipeDataCollection
          .where('userId', isEqualTo: userId)
          .where('isInMealPlan', isEqualTo: true)
          .where('mealPlanDate', isGreaterThanOrEqualTo: normalizedStartDate.toIso8601String())
          .where('mealPlanDate', isLessThan: normalizedEndDate.toIso8601String())
          .get();

      final Map<DateTime, List<String>> mealPlanMap = {};

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final recipeId = data['recipeId'] as String;
        final mealPlanDateStr = data['mealPlanDate'] as String?;
        
        if (mealPlanDateStr != null) {
          final mealPlanDate = DateTime.parse(mealPlanDateStr);
          final normalizedDate = DateTime(
            mealPlanDate.year,
            mealPlanDate.month,
            mealPlanDate.day,
          );
          
          mealPlanMap.putIfAbsent(normalizedDate, () => []).add(recipeId);
        }
      }

      return mealPlanMap;
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to get meal plan recipe IDs for date range: $e',
      );
    }
  }

  @override
  Future<void> toggleFavorite(String userId, String recipeId) async {
    try {
      final docRef = _getUserRecipeDoc(userId, recipeId);
      
      // Get existing data or create new
      final existingDoc = await docRef.get();
      UserRecipeData data;
      
      if (existingDoc.exists) {
        data = UserRecipeData.fromMap(existingDoc.data()!);
      } else {
        data = UserRecipeData(userId: userId, recipeId: recipeId);
      }

      final updatedData = data.toggleFavorite();
      await docRef.set(updatedData.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to toggle favorite: $e',
      );
    }
  }

  @override
  Future<void> markAsTried(String userId, String recipeId) async {
    try {
      final docRef = _getUserRecipeDoc(userId, recipeId);
      
      // Get existing data or create new
      final existingDoc = await docRef.get();
      UserRecipeData data;
      
      if (existingDoc.exists) {
        data = UserRecipeData.fromMap(existingDoc.data()!);
      } else {
        data = UserRecipeData(userId: userId, recipeId: recipeId);
      }

      final updatedData = data.markAsTried();
      await docRef.set(updatedData.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to mark as tried: $e',
      );
    }
  }

  @override
  Future<void> updatePersonalNotes(
    String userId,
    String recipeId,
    String? notes,
  ) async {
    try {
      final docRef = _getUserRecipeDoc(userId, recipeId);
      
      // Get existing data or create new
      final existingDoc = await docRef.get();
      UserRecipeData data;
      
      if (existingDoc.exists) {
        data = UserRecipeData.fromMap(existingDoc.data()!);
      } else {
        data = UserRecipeData(userId: userId, recipeId: recipeId);
      }

      final updatedData = data.updateNotes(notes);
      await docRef.set(updatedData.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to update personal notes: $e',
      );
    }
  }

  @override
  Future<void> incrementViewCount(String userId, String recipeId) async {
    try {
      final docRef = _getUserRecipeDoc(userId, recipeId);
      
      // Use transaction to handle concurrent updates
      await _firestore.runTransaction((transaction) async {
        final docSnapshot = await transaction.get(docRef);
        
        UserRecipeData data;
        if (docSnapshot.exists) {
          data = UserRecipeData.fromMap(docSnapshot.data()!);
        } else {
          data = UserRecipeData(userId: userId, recipeId: recipeId);
        }

        final updatedData = data.incrementViewCount();
        transaction.set(docRef, updatedData.toMap(), SetOptions(merge: true));
      });
    } catch (e) {
      throw UserRecipeRepositoryException(
        'Failed to increment view count: $e',
      );
    }
  }

  @override
  Stream<UserRecipeData?> watchUserRecipeData(
    String userId,
    String recipeId,
  ) {
    return _getUserRecipeDoc(userId, recipeId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) {
            return UserRecipeData(userId: userId, recipeId: recipeId);
          }
          return UserRecipeData.fromMap(snapshot.data()!);
        })
        .handleError((error) {
      throw UserRecipeRepositoryException(
        'Failed to watch user recipe data: $error',
      );
    });
  }

  @override
  Stream<List<UserRecipeData>> watchAllUserRecipeData(String userId) {
    return _userRecipeDataCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserRecipeData.fromMap(doc.data()))
            .toList())
        .handleError((error) {
      throw UserRecipeRepositoryException(
        'Failed to watch all user recipe data: $error',
      );
    });
  }

  @override
  Stream<List<String>> watchFavoriteRecipeIds(String userId) {
    return _userRecipeDataCollection
        .where('userId', isEqualTo: userId)
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data()['recipeId'] as String)
            .toList())
        .handleError((error) {
      throw UserRecipeRepositoryException(
        'Failed to watch favorite recipe IDs: $error',
      );
    });
  }
}

/// Exception thrown by user recipe repository operations
class UserRecipeRepositoryException implements Exception {
  const UserRecipeRepositoryException(this.message);
  final String message;

  @override
  String toString() => 'UserRecipeRepositoryException: $message';
}

@riverpod
FirebaseUserRecipeRepository userRecipeRepository(Ref ref) {
  return FirebaseUserRecipeRepository(FirebaseFirestore.instance);
}