# Content Architecture

## Purpose

Define how AIWithShiv stores, validates, localizes, unlocks, and versions learning content.

## Current Project Understanding

Content is local-first and loaded from JSON files under `assets/data/`. Repositories parse these files into model objects. Progress is stored separately in SharedPreferences.

## Current Data Files

| File | Role |
| --- | --- |
| `assets/data/courses.json` | Course metadata and ordered lesson IDs |
| `assets/data/lessons.json` | Story lessons, concepts, duration, XP |
| `assets/data/quizzes.json` | One quiz per lesson |
| `assets/data/games.json` | Game cards and routes |
| `assets/data/achievements.json` | Badge/trophy metadata |
| `assets/data/rewards.json` | Reward metadata |

## Current Repositories

| Repository | Path | Storage |
| --- | --- | --- |
| Lessons | `lib/features/lessons/data/asset_lesson_repository.dart` | JSON/cache |
| Quizzes | `lib/features/quizzes/data/asset_quiz_repository.dart` | JSON/cache |
| Games | `lib/features/games/data/asset_game_repository.dart` | JSON |
| Achievements | `lib/features/achievements/data/asset_achievement_repository.dart` | JSON/cache |
| Rewards | `lib/features/rewards/data/asset_reward_repository.dart` | JSON/cache |
| Progress | `lib/features/progress/data/local_progress_repository.dart` | SharedPreferences |
| Game progress | `lib/features/games/data/local_game_progress_repository.dart` | SharedPreferences |

## ID Naming Conventions

Use lowercase kebab-case for course and lesson IDs.

Examples:

- Course: `ai-masti-missions`
- Lesson: `ai-masti-missions-lesson-01`
- Quiz: `ai-masti-missions-lesson-01-quiz`
- Question: `ai-masti-missions-lesson-01-q1`

Game IDs currently use snake_case, matching existing implementation:

- `train_robot`
- `ai_detective`
- `sort_like_ai`

Do not rename existing game IDs without migration.

## Course Schema

```json
{
  "id": "ai-masti-missions",
  "title": "AI Masti Missions",
  "description": "Short child-friendly course description.",
  "category": "AI Basics",
  "ageGroups": ["kids"],
  "lessonIds": ["ai-masti-missions-lesson-01"],
  "imageUrl": "",
  "xp": 290
}
```

## Lesson Schema

```json
{
  "id": "ai-masti-missions-lesson-01",
  "courseId": "ai-masti-missions",
  "title": "Meet Shiv the AI Hero",
  "story": "Short comic-style story.",
  "concepts": ["AI helper", "Human choice", "Shiv"],
  "durationMinutes": 5,
  "xp": 25,
  "order": 1
}
```

## Quiz Schema

```json
{
  "id": "ai-masti-missions-lesson-01-quiz",
  "lessonId": "ai-masti-missions-lesson-01",
  "title": "Meet Shiv the AI Hero Checkpoint",
  "questions": [
    {
      "id": "ai-masti-missions-lesson-01-q1",
      "prompt": "What helps Shiv learn better?",
      "options": ["Clear examples", "Secret passwords", "No clues", "Angry words"],
      "answerIndex": 0,
      "correctAnswerIndexes": [0],
      "explanation": "Clear examples help Shiv learn safely."
    }
  ]
}
```

## Game Schema

```json
{
  "id": "train_robot",
  "title": "Train the Robot",
  "concept": "Machine Learning",
  "description": "Teach ShivBot by giving correct examples.",
  "ageGroup": "5-10",
  "durationMinutes": 4,
  "xpReward": 20,
  "coinReward": 10,
  "route": "/games/train-robot",
  "isActive": true
}
```

## Achievement Schema

```json
{
  "id": "first-spark",
  "title": "First Spark",
  "description": "Complete your first lesson.",
  "icon": "bolt",
  "requiredXp": 20
}
```

## Validation Rules

| Rule | Reason |
| --- | --- |
| Every course has exactly 10 lessons in Phase 1 | Stable progression |
| Every lesson belongs to a valid course | Avoid broken routes |
| Every lesson has one quiz | Complete learning loop |
| Every quiz has 2 questions in Phase 1 | Child-friendly length |
| Every question has 4 options | Consistent UI |
| `answerIndex` appears in `correctAnswerIndexes` | Compatibility |
| Course XP equals sum of lesson XP | Reward clarity |
| Active game route is registered in GoRouter | Avoid broken navigation |

## Localization Strategy

Current localization is split:

- `AppStrings` for UI labels.
- `LocalizedContent` for course, lesson, quiz, and game text overrides.
- JSON remains English-first.

Recommended next step: add a content localization map or separate localized JSON files before content grows too large.

## Versioning Strategy

Add a future `content_manifest.json`:

```json
{
  "version": "1.0.0",
  "phase": "phase-1",
  "updatedAt": "2026-06-19",
  "courses": 3,
  "lessons": 30,
  "quizzes": 30
}
```

## What Already Exists

- JSON assets.
- Asset repositories.
- Cache service for main content.
- SharedPreferences progress.
- Unit tests for models and core flows.

## What Is Missing

- Automated JSON validation script checked into repo.
- Content version manifest.
- Full Hindi localization strategy.
- Explicit unlock mapping.
- Schema documentation near data files.

## Recommended Next Steps

1. Add a validation script in a later implementation phase.
2. Add content manifest.
3. Define a content QA workflow before every release.

## Implementation Checklist

- [ ] Validate JSON syntax.
- [ ] Validate relational integrity.
- [ ] Validate active game routes.
- [ ] Validate quiz answer indexes.
- [ ] Validate Hindi coverage.
- [ ] Validate reward balance.

## Acceptance Criteria

- Content creators can add lessons without reading Dart code.
- Developers can validate content before build.
- Broken IDs/routes are caught before release.
- Localization does not require changing model schemas in v1.

