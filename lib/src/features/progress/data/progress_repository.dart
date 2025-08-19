import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../../auth/data/firebase_auth_repository.dart';
import '../../auth/domain/user.dart';
import '../domain/progress_tracker.dart';

part 'progress_repository.g.dart';

class ProgressRepository {
  const ProgressRepository(this._firestore, this._ref);

  final FirebaseFirestore _firestore;
  final Ref _ref;

  User? get _user => _ref.read(authRepositoryProvider).currentUser;

  // --- Path Helpers ---

  static String _userPath(String userId) =>
      '${FirebaseConsts.usersCollection}/$userId';
  static String _progressCollectionPath(String userId) =>
      '${_userPath(userId)}/${FirebaseConsts.progressCollection}';

  // --- Document Reference Helpers with Converters ---

  DocumentReference<ProgressTracker> _progressDocRef(
    String userId,
    String progressId,
  ) => _firestore
      .doc('$_progressCollectionPath($userId)/$progressId')
      .withConverter(
        fromFirestore: (snapshot, options) =>
            ProgressTracker.fromMap(snapshot.data()!),
        toFirestore: (progress, options) => progress.toMap(),
      );

  // --- Create ---

  Future<void> createProgress(ProgressTracker progress) async {
    await _progressDocRef(progress.userId, progress.id).set(progress);
  }

  // --- Read ---

  Future<ProgressTracker?> fetchProgress(String progressId) async {
    final snapshot = await _progressDocRef(_user!.uid, progressId).get();
    return snapshot.data();
  }

  // --- Update ---

  Future<void> updateProgress(ProgressTracker progress) async {
    await _progressDocRef(progress.userId, progress.id).set(progress);
  }

  // --- Delete ---

  Future<void> deleteProgress(String progressId) async {
    await _progressDocRef(_user!.uid, progressId).delete();
  }

  Future<void> deleteProgressCollection() async {
    await _firestore.collection(_progressCollectionPath(_user!.uid)).get().then(
      (snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      },
    );
  }
}

@riverpod
ProgressRepository progressRepository(Ref ref) {
  return ProgressRepository(FirebaseFirestore.instance, ref);
}
