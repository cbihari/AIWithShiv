import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../data/firestore_parent_repository.dart';
import '../domain/parent_repository.dart';

final parentRepositoryProvider = Provider<ParentRepository>((ref) {
  return FirestoreParentRepository(ref.watch(firestoreProvider));
});
