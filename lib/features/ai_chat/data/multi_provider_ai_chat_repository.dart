import '../../../core/network/api_client.dart';
import '../../../shared/models/age_group.dart';
import '../domain/ai_chat_repository.dart';
import 'ai_safety_guard.dart';

class MultiProviderAiChatRepository implements AiChatRepository {
  MultiProviderAiChatRepository(
    this._apiClient,
    this._safetyGuard,
  );

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
    final response = await _apiClient.postJson(
      '${_apiClient.openAiBaseUrl}/chat/completions',
      data: {
        'model': 'gpt-4.1-mini',
        'max_tokens': 150,
        'temperature': 0.8,
        'messages': [
          {
            'role': 'system',
            'content': _safetyGuard.systemPrompt(ageGroupLabel: ageGroup.label),
          },
          {'role': 'user', 'content': message},
        ],
      },
    );
    return _extractText(response.data) ?? _localFallback(message, ageGroup);
  }

  Future<String> _askGemini(String message, AgeGroup ageGroup) async {
    final response = await _apiClient.postJson(
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
    return _extractText(response.data) ?? _localFallback(message, ageGroup);
  }

  Future<String> _askBedrock(String message, AgeGroup ageGroup) async {
    final response = await _apiClient.postJson(
      '${_apiClient.bedrockProxyBaseUrl}/askShivBot',
      data: {'ageGroup': ageGroup.label, 'message': message},
    );
    return _extractText(response.data) ?? _localFallback(message, ageGroup);
  }

  String? _extractText(Map<String, dynamic>? data) {
    if (data == null) return null;
    final direct = data['reply'] ?? data['text'] ?? data['content'];
    if (direct is String && direct.trim().isNotEmpty) return direct.trim();

    final choices = data['choices'];
    if (choices is List && choices.isNotEmpty) {
      final first = choices.first;
      if (first is Map<String, dynamic>) {
        final message = first['message'];
        if (message is Map<String, dynamic>) {
          final content = message['content'];
          if (content is String && content.trim().isNotEmpty) {
            return content.trim();
          }
        }
        final text = first['text'];
        if (text is String && text.trim().isNotEmpty) return text.trim();
      }
    }

    final candidates = data['candidates'];
    if (candidates is List && candidates.isNotEmpty) {
      final first = candidates.first;
      if (first is Map<String, dynamic>) {
        final content = first['content'];
        if (content is Map<String, dynamic>) {
          final parts = content['parts'];
          if (parts is List && parts.isNotEmpty) {
            final part = parts.first;
            if (part is Map<String, dynamic>) {
              final text = part['text'];
              if (text is String && text.trim().isNotEmpty) {
                return text.trim();
              }
            }
          }
        }
      }
    }
    return null;
  }

  String _localFallback(String message, AgeGroup ageGroup) {
    return 'Great question! For ${ageGroup.label}, think of AI like a helpful game guide. '
        'It looks for patterns, makes a smart guess, and learns from feedback. '
        'What example should we explore next?';
  }
}
