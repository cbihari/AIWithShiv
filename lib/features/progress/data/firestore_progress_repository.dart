import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/user_progress.dart';
import '../domain/progress_repository.dart';

class FirestoreProgressRepository implements ProgressRepository {
  const FirestoreProgressRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<UserProgress> get _progressCollection =>
      _firestore.collection('user_progress').withConverter<UserProgress>(
            fromFirestore: (snapshot, _) {
              final data = snapshot.data();
              if (data == null) return UserProgress.starter(snapshot.id);
              return UserProgress.fromJson(snapshot.id, data);
            },
            toFirestore: (progress, _) => progress.toJson(),
          );

  @override
  Stream<UserProgress> watchProgress(String userId) {
    return _progressCollection
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data() ?? UserProgress.starter(userId));
  }

  @override
  Future<UserProgress> getProgress(String userId) async {
    final doc = await _progressCollection.doc(userId).get();
    return doc.data() ?? UserProgress.starter(userId);
  }

  @override
  Future<void> saveProgress(UserProgress progress) {
    return _progressCollection
        .doc(progress.userId)
        .set(progress, SetOptions(merge: true));
  }
}
