abstract interface class ParentRepository {
  Future<Map<String, dynamic>> getProgressSummary(String childUid);
  Future<void> setDailyScreenTimeLimit(String childUid, int minutes);
  Future<void> enableWeeklyEmailReports(String childUid, bool enabled);
}
