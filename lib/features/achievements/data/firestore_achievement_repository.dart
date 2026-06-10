import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/achievement.dart';
import '../domain/achievement_repository.dart';

class FirestoreAchievementRepository implements AchievementRepository {
  const FirestoreAchievementRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<Achievement>> getAchievements() async {
    final snapshot =
        await _firestore.collection('achievements').orderBy('requiredXp').get();
    return snapshot.docs
        .map((doc) => Achievement.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }
}
