import '../../../shared/models/age_group.dart';

abstract interface class AiChatRepository {
  Future<String> askShivBot({
    required String message,
    required AgeGroup ageGroup,
    required String provider,
  });
}
