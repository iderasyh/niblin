import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niblin/src/features/auth/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/firebase_consts.dart';
import '../../auth/data/firebase_auth_repository.dart';
import '../domain/tip_content.dart';

part 'tips_repository.g.dart';

class TipsRepository {
  const TipsRepository(this._firestore, this._ref);

  final FirebaseFirestore _firestore;
  final Ref _ref;

  User? get _user => _ref.read(authRepositoryProvider).currentUser;

  // --- Path Helpers ---

  static String _userPath(String userId) =>
      '${FirebaseConsts.usersCollection}/$userId';
  static String _tipsCollectionPath(String userId) =>
      '${_userPath(userId)}/${FirebaseConsts.tipsCollection}';

  // --- Document Reference Helpers with Converters ---

  DocumentReference<TipContent> _tipDocRef(String userId, String tipId) =>
      _firestore
          .doc('$_tipsCollectionPath($userId)/$tipId')
          .withConverter(
            fromFirestore: (snapshot, options) =>
                TipContent.fromMap(snapshot.data()!),
            toFirestore: (tip, options) => tip.toMap(),
          );

  // --- Create ---

  Future<void> createTip(TipContent tip) async {
    await _tipDocRef(_user!.uid, tip.id).set(tip);
  }

  // --- Read ---

  Future<TipContent?> fetchTip(String tipId) async {
    final snapshot = await _tipDocRef(_user!.uid, tipId).get();
    return snapshot.data();
  }

  // --- Update ---

  Future<void> updateTip(TipContent tip) async {
    await _tipDocRef(_user!.uid, tip.id).set(tip);
  }

  // --- Delete ---

  Future<void> deleteTip(String tipId) async {
    await _tipDocRef(_user!.uid, tipId).delete();
  }

  // --- Delete Collection ---

  Future<void> deleteTipCollection() async {
    await _firestore.collection(_tipsCollectionPath(_user!.uid)).get().then((
      snapshot,
    ) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }
}

@riverpod
TipsRepository tipsRepository(Ref ref) {
  return TipsRepository(FirebaseFirestore.instance, ref);
}
