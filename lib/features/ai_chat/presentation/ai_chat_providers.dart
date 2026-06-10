import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../shared/models/age_group.dart';
import '../data/ai_safety_guard.dart';
import '../data/multi_provider_ai_chat_repository.dart';
import '../domain/ai_chat_repository.dart';

final aiSafetyGuardProvider = Provider<AiSafetyGuard>((ref) => AiSafetyGuard());

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return MultiProviderAiChatRepository(
    ref.watch(apiClientProvider),
    ref.watch(aiSafetyGuardProvider),
  );
});

final aiChatViewModelProvider =
    StateNotifierProvider<AiChatViewModel, AsyncValue<String?>>((ref) {
  return AiChatViewModel(ref.watch(aiChatRepositoryProvider));
});

class AiChatViewModel extends StateNotifier<AsyncValue<String?>> {
  AiChatViewModel(this._repository) : super(const AsyncData(null));

  final AiChatRepository _repository;

  Future<void> ask({
    required String message,
    required AgeGroup ageGroup,
    String provider = 'local',
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.askShivBot(
        message: message,
        ageGroup: ageGroup,
        provider: provider,
      ),
    );
  }
}
