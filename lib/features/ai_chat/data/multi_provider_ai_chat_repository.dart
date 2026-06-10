import '../../../core/network/api_client.dart';
import '../../../shared/models/age_group.dart';
import '../domain/ai_chat_repository.dart';
import 'ai_safety_guard.dart';

class MultiProviderAiChatRepository implements AiChatRepository {
  MultiProviderAiChatRepository(this._apiClient, this._safetyGuard);

  final ApiClient _apiClient;
  final AiSafetyGuard _safetyGuard;

  @override
  Future<String> askShivBot({
    required String message,
    required AgeGroup ageGroup,
    required String provider,
  }) async {
    _safetyGuard.validatePrompt(message);

    final response = await switch (provider) {
      'openai' => _askOpenAi(message, ageGroup),
      'gemini' => _askGemini(message, ageGroup),
      'bedrock' => _askBedrock(message, ageGroup),
      'local' => Future.value(_localFallback(message, ageGroup)),
      _ => Future.value(_localFallback(message, ageGroup)),
    };
    return _safetyGuard.validateResponse(response);
  }

  Future<String> _askOpenAi(String message, AgeGroup ageGroup) async {
    await _apiClient.postJson(
      '${_apiClient.openAiBaseUrl}/chat/completions',
      data: {
        'model': 'gpt-4.1-mini',
        'messages': [
          {
            'role': 'system',
            'content': _safetyGuard.systemPrompt(ageGroupLabel: ageGroup.label),
          },
          {'role': 'user', 'content': message},
        ],
      },
    );
    return _localFallback(message, ageGroup);
  }

  Future<String> _askGemini(String message, AgeGroup ageGroup) async {
    await _apiClient.postJson(
      '${_apiClient.geminiBaseUrl}/models/gemini-pro:generateContent',
      data: {
        'contents': [
          {
            'parts': [
              {
                'text':
                    '${_safetyGuard.systemPrompt(ageGroupLabel: ageGroup.label)}\n$message',
              },
            ],
          },
        ],
      },
    );
    return _localFallback(message, ageGroup);
  }

  Future<String> _askBedrock(String message, AgeGroup ageGroup) async {
    await _apiClient.postJson(
      '${_apiClient.bedrockProxyBaseUrl}/askShivBot',
      data: {'ageGroup': ageGroup.label, 'message': message},
    );
    return _localFallback(message, ageGroup);
  }

  String _localFallback(String message, AgeGroup ageGroup) {
    return 'Great question! For ${ageGroup.label}, think of AI like a helpful game guide. '
        'It looks for patterns, makes a smart guess, and learns from feedback. '
        'What example should we explore next?';
  }
}
