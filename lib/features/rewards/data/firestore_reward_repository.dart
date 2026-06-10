import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/reward.dart';
import '../domain/reward_repository.dart';

class FirestoreRewardRepository implements RewardRepository {
  const FirestoreRewardRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<Reward>> getRewards() async {
    final snapshot =
        await _firestore.collection('rewards').orderBy('coins').get();
    return snapshot.docs
        .map((doc) => Reward.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }
}
