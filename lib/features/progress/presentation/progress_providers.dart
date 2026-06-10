import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/user_progress.dart';
import '../data/firestore_progress_repository.dart';
import '../domain/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return FirestoreProgressRepository(ref.watch(firestoreProvider));
});

final userProgressProvider = StreamProvider.family<UserProgress, String>((
  ref,
  userId,
) {
  return ref.watch(progressRepositoryProvider).watchProgress(userId);
});
