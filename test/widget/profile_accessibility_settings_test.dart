import 'package:aiwithshiv/features/auth/presentation/auth_providers.dart';
import 'package:aiwithshiv/features/lessons/presentation/lesson_providers.dart';
import 'package:aiwithshiv/features/profile/presentation/profile_screen.dart';
import 'package:aiwithshiv/features/progress/presentation/progress_providers.dart';
import 'package:aiwithshiv/shared/models/course.dart';
import 'package:aiwithshiv/shared/models/user_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Profile exposes voice, easy reading, data saver, and safety settings', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWith((ref) => 'guest'),
          userProgressProvider('guest').overrideWith((ref) {
            return Stream.value(UserProgress.starter('guest'));
          }),
          coursesProvider.overrideWith((ref) async {
            return const [
              Course(
                id: 'course-1',
                title: 'AI Masti Missions',
                description: 'Fun AI lessons',
                category: 'AI Basics',
                ageGroups: ['kids'],
                lessonIds: ['lesson-1'],
                imageUrl: '',
                xp: 100,
              ),
            ];
          }),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('🔊 Voice Reading'), findsOneWidget);
    expect(find.text('🌟 Easy Reading Mode'), findsOneWidget);
    expect(find.text('📶 Data Saver Mode'), findsOneWidget);
    expect(find.textContaining('🛡️ Safety First'), findsOneWidget);
  });
}
