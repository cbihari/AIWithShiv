import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/parent_repository.dart';

class FirestoreParentRepository implements ParentRepository {
  const FirestoreParentRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<Map<String, dynamic>> getProgressSummary(String childUid) async {
    final doc =
        await _firestore.collection('user_progress').doc(childUid).get();
    return doc.data() ?? <String, dynamic>{};
  }

  @override
  Future<void> setDailyScreenTimeLimit(String childUid, int minutes) {
    return _firestore.collection('users').doc(childUid).set({
      'screenTimeLimitMinutes': minutes,
    }, SetOptions(merge: true));
  }

  @override
  Future<void> enableWeeklyEmailReports(String childUid, bool enabled) {
    return _firestore.collection('users').doc(childUid).set({
      'weeklyEmailReportsEnabled': enabled,
    }, SetOptions(merge: true));
  }
}
