import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/parent_repository.dart';

final parentRepositoryProvider = Provider<ParentRepository>((ref) {
  return const LocalParentRepository();
});

class LocalParentRepository implements ParentRepository {
  const LocalParentRepository();

  @override
  Future<void> enableWeeklyEmailReports(String childUid, bool enabled) async {}

  @override
  Future<Map<String, dynamic>> getProgressSummary(String childUid) async {
    return const <String, dynamic>{
      'mode': 'local-first',
      'cloudSync': false,
    };
  }

  @override
  Future<void> setDailyScreenTimeLimit(String childUid, int minutes) async {}
}
