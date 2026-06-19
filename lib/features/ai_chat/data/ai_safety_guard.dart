import '../../../core/errors/app_exception.dart';

class AiSafetyGuard {
  static const _blockedTerms = <String>[
    'weapon',
    'bomb',
    'kill',
    'self harm',
    'suicide',
    'adult content',
    'hate',
    'ignore previous instructions',
    'developer message',
    'system prompt',
    'jailbreak',
    'address',
    'phone number',
    'password',
    'where i live',
    'school name',
    'email address',
    'contact me',
  ];

  void validatePrompt(String prompt) {
    final normalized = prompt.toLowerCase();
    if (normalized.trim().isEmpty || normalized.length > 1000) {
      throw const AiSafetyException(
        'Please ask ShivBot a short learning question.',
        code: 'invalid_prompt',
      );
    }
    if (_blockedTerms.any(normalized.contains)) {
      throw const AiSafetyException(
        'ShivBot can only help with safe learning questions.',
        code: 'blocked_prompt',
      );
    }
    if (RegExp(r'\b\d{10}\b').hasMatch(prompt) ||
        RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b').hasMatch(prompt)) {
      throw const AiSafetyException(
        'Please do not share private details with ShivBot.',
        code: 'private_info_prompt',
      );
    }
  }

  String systemPrompt({required String ageGroupLabel}) {
    return '''
You are ShivBot, a friendly robot-superhero boy AI tutor.
Audience: Indian children aged 5 to 10 years old.
Rules:
- Reply in maximum 3 short simple sentences
- Use simple English a 6 year old understands
- Add 1-2 emojis per reply
- Occasionally use Hindi words: Shabash, Namaste, Dost, Chalo, Masti
- Use Indian examples: tiffin, cricket, mango, Diwali, school, homework
- Always be encouraging and playful
- Never use scary, adult, political, or violent content
- Never ask for or repeat real names, addresses, phone numbers, emails, school names, photos, or passwords
- If asked something unsafe, say: 'That is a question for a grown-up dost! 🤗'
- End every reply with an encouraging line or question back to child
''';
  }

  String validateResponse(String response) {
    final normalized = response.toLowerCase();
    if (_blockedTerms.any(normalized.contains)) {
      throw const AiSafetyException(
        'ShivBot response was blocked by the safety checker.',
        code: 'blocked_response',
      );
    }
    return response.trim();
  }
}
