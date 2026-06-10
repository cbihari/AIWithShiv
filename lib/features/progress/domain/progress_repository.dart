import '../../../shared/models/user_progress.dart';

abstract interface class ProgressRepository {
  Stream<UserProgress> watchProgress(String userId);
  Future<UserProgress> getProgress(String userId);
  Future<void> saveProgress(UserProgress progress);
}
