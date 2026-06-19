# Phased Execution Plan

## Purpose

Create a practical phase-by-phase roadmap from current project state to Play Store and App Store launch.

## Phase 1: Content Architecture and Curriculum Cleanup

Goal: Make current local content reliable and validated.

Why it matters: Broken content IDs or weak lessons create app failures and poor learning.

Inputs required:

- Current JSON files.
- Current model schemas.
- Content QA checklist.

Tasks:

- Add content validation script.
- Validate 3 courses, 30 lessons, 30 quizzes.
- Review repeated quiz wording.
- Confirm course XP totals.
- Confirm active game routes.

Files likely affected:

- `assets/data/*.json`
- `scripts/`
- `test/unit/`

Commands:

```bash
flutter analyze
flutter test
```

Done criteria:

- JSON validation passes.
- All tests pass.
- Content QA checklist has no launch blockers.

## Phase 2: Course 2 and Course 3 Content

Goal: Improve Pattern Playground and Teach The Robot content quality and Hindi coverage.

Tasks:

- Review all 20 lessons.
- Improve quiz variety.
- Add Hindi lesson/quiz localization.
- Test UI in Hindi.

Files likely affected:

- `assets/data/lessons.json`
- `assets/data/quizzes.json`
- `lib/core/localization/localized_content.dart`

Done criteria:

- Courses 2 and 3 feel as polished as Course 1.
- Hindi mode does not feel incomplete.

## Phase 3: More Games and Reward Balancing

Goal: Complete or refine AI games and reward loops.

Tasks:

- Decide whether v1 ships with 5 or 9 games.
- Add missing game routes only if time allows.
- Align level thresholds.
- Add replay/reward tests.

Files likely affected:

- `assets/data/games.json`
- `lib/features/games/`
- `lib/core/services/gamification_service.dart`
- `test/unit/game_completion_test.dart`

Done criteria:

- No duplicate rewards.
- All active game routes work.
- Rewards feel balanced.

## Phase 4: Parent/Teacher Support

Goal: Build trust and explain learning value.

Tasks:

- Write parent intro copy.
- Write teacher guide for each course.
- Add privacy explanation.
- Plan certificate copy.

Files likely affected:

- `docs/`
- Future app screens if implemented.

Done criteria:

- Parent can understand app safety and value.
- Teacher can use a course in class.

## Phase 5: Store Assets and Privacy

Goal: Prepare store listing and policy assets.

Tasks:

- Finalize app title.
- Capture screenshots.
- Produce feature graphic.
- Finalize privacy policy and terms.
- Complete data safety notes.

Files likely affected:

- `docs/`
- Store console assets outside repo.

Done criteria:

- Store listing package ready.
- Privacy claims match implementation.

## Phase 6: Real Device QA

Goal: Test on actual Android and iOS devices.

Tasks:

- Android release install test.
- iPhone TestFlight/simulator test.
- Offline test.
- Voice test.
- Hindi test.
- Low-end performance test.

Commands:

```bash
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build ios --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

Done criteria:

- No critical crashes.
- No major overflow.
- App works offline.

## Phase 7: Android Launch

Goal: Submit to Play Console internal/closed testing and then production.

Tasks:

- Build AAB.
- Upload to Play Console.
- Complete Data safety.
- Complete child-directed declarations.
- Run closed testing.

Done criteria:

- Android build approved for testing.
- Critical feedback resolved.

## Phase 8: iOS Launch

Goal: Submit to TestFlight and App Store review.

Tasks:

- Archive in Xcode.
- Upload to App Store Connect.
- Complete privacy labels.
- Run TestFlight.
- Submit for review.

Done criteria:

- iOS build accepted by App Store Connect.
- Review issues resolved.

## Recommended Phase 1 Starting Point

Start with a content validation script and quiz/content QA. This is the best first step because the app is already functional, but launch quality depends on reliable child-safe content.

## Acceptance Criteria

- Every phase has clear inputs, tasks, files, commands, and done criteria.
- Solo founder can execute phases in order.
- Launch work is not mixed with risky feature expansion.

