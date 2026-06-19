import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../services/analytics_service.dart';
import '../services/gamification_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return const AnalyticsService();
});

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return const GamificationService();
});
