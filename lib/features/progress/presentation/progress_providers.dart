import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/user_progress.dart';
import '../data/local_progress_repository.dart';
import '../domain/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return LocalProgressRepository();
});

final userProgressProvider = StreamProvider.family<UserProgress, String>((
  ref,
  userId,
) {
  return ref.watch(progressRepositoryProvider).watchProgress(userId);
});
