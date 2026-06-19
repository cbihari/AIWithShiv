# AIWithShiv Project Overview

## Purpose

This document explains the current state of AIWithShiv from product, curriculum, technical, and launch perspectives. It is the starting point for all roadmap work.

## Current Project Understanding

AIWithShiv is a Flutter mobile app for Android and iOS that teaches Indian children aged 5-10 basic AI concepts through a superhero comic learning experience. The app is local-first, child-friendly, bilingual, and centered around Shiv, a friendly robot-superhero tutor.

The app should make the child feel: "I am becoming an AI Hero with Shiv."

## Current Users

| User | Need | Current support |
| --- | --- | --- |
| Child age 5-10 | Fun AI learning, games, rewards | Supported |
| Parent | Trust, privacy, simple progress | Partially supported |
| Teacher | Classroom-friendly AI basics | Needs content |
| School | Offline-safe learning product | Future opportunity |
| EdTech partner | Structured curriculum | Needs packaging |

## Current App Flow

1. App launches at `/`.
2. Splash/welcome/onboarding can route child toward dashboard.
3. Auth, consent, parent, and admin routes redirect to `/dashboard`.
4. Child lands on Dashboard.
5. Child can open Learning Path, Daily Quiz, Ask Shiv, AI Games, Trophies, Profile, and Shop.
6. Lessons and quizzes award XP, coins, streak progress, and badges.
7. Games award XP/coins only on first completion and allow replay.

## Current Main Routes

| Route | Screen |
| --- | --- |
| `/` | Splash |
| `/welcome` | Welcome |
| `/age` | Age selection |
| `/hero-setup` | Hero setup |
| `/dashboard` | Dashboard |
| `/learning-path` | Learning Path |
| `/lesson/:id` | Lesson |
| `/quiz` | Daily Quiz |
| `/quiz/:lessonId` | Lesson Quiz |
| `/ai-buddy` | ShivBot |
| `/achievements` | Trophy Room |
| `/profile` | Profile |
| `/shop` | Shop |
| `/games` | AI Games |
| `/games/train-robot` | Train the Robot |
| `/games/ai-detective` | AI Detective |
| `/games/sort-like-ai` | Sort Like AI |
| `/games/robot-treasure-hunt` | Robot Treasure Hunt |
| `/games/spot-ai-mistake` | Spot the AI Mistake |

## Current Technology

| Layer | Current implementation |
| --- | --- |
| App | Flutter, Dart |
| State | Riverpod |
| Navigation | GoRouter |
| Content | Local JSON assets |
| Progress | SharedPreferences |
| Voice | flutter_tts |
| Ads | google_mobile_ads behind `ENABLE_ADS` |
| AI buddy | Local fallback plus provider paths |
| Tests | Unit and widget tests |
| Core backend | None required for learning flow |

## Current Local Data

| File | Current count |
| --- | ---: |
| `assets/data/courses.json` | 3 courses |
| `assets/data/lessons.json` | 30 lessons |
| `assets/data/quizzes.json` | 30 quizzes |
| `assets/data/games.json` | 5 games |
| `assets/data/achievements.json` | 12 achievements |
| `assets/data/rewards.json` | 5 rewards |

## What Already Exists

- Local-first lesson, quiz, game, reward, achievement, and progress repositories.
- Comic-style shared widgets and child-first screens.
- English/Hindi app string layer.
- Course-level Hindi metadata for current courses.
- TTS settings and voice reading support.
- Optional ads system with test IDs and feature flag.
- Tests for routing, games, quiz view model, gamification, models, ads config, dashboard, lessons, profile accessibility, and small-screen navigation.

## What Is Missing

- Full Hindi translations for all new lessons and quizzes.
- Parent/teacher support screens and guides.
- Store-ready privacy policy and data safety finalization.
- Production AdMob IDs.
- Final ShivBot backend/proxy contract.
- Full 9-game curriculum implementation from the learning ecosystem.
- Real device QA matrix for Android and iOS.

## Current Risks

| Risk | Impact | Recommendation |
| --- | --- | --- |
| ShivBot provider paths can point at direct AI APIs | API key must never ship in app | Use backend/proxy only for production |
| Ads need child-directed compliance | Store rejection or trust risk | Keep disabled by default and document ad policy |
| Hindi content is partial | Bilingual promise feels incomplete | Finish localization before launch |
| Parent/teacher value not visible enough | Lower trust and school adoption | Add parent/teacher docs and future screen plan |
| App metadata still says children, teens, and adults in `pubspec.yaml` | Positioning mismatch | Fix in implementation phase |

## Recommended Next Steps

1. Freeze Phase 1 scope: age 5-10 only, 3 courses, 30 lessons, 5 existing games.
2. Validate all JSON content with a repeatable script.
3. Complete Hindi content coverage.
4. Add parent/teacher documentation and privacy-facing copy.
5. Lock ShivBot to a secure backend/proxy before production.
6. Run real device QA before store submission.

## Implementation Checklist

- [ ] Review all roadmap docs in order.
- [ ] Confirm Phase 1 content scope.
- [ ] Create content validation command.
- [ ] Add missing Hindi translations.
- [ ] Document production ShivBot backend contract.
- [ ] Complete store launch checklist.

## Acceptance Criteria

- A developer can understand the current app flow without reading source code.
- A content creator can see what content exists and what is missing.
- A founder can see launch risks and next steps.
- No production code changes are required by this document.

