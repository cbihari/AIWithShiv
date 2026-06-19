# Technical Audit

## Purpose

Audit current Flutter architecture, risks, strengths, missing tests, and production blockers.

## Scope Inspected

- Routing.
- Riverpod providers.
- SharedPreferences usage.
- JSON loading.
- TTS.
- Ads feature flag.
- Games.
- Quizzes.
- Rewards.
- Profile.
- Localization.
- Tests.

## Routing

Strengths:

- GoRouter is centralized in `lib/core/routing/app_router.dart`.
- Child-first flow redirects login/signup/parent/admin routes to dashboard.
- All five active game routes are registered.

Risks:

- Parent/admin screens exist in source but are intentionally unreachable by redirect.
- Lesson next route assumes 10 lessons per course, which is currently valid.

Recommendations:

- Keep route tests updated as screens are added.
- Document intentionally disabled routes.

## Riverpod Providers

Strengths:

- Providers are feature-scoped.
- Repositories are injectable and testable.
- Dashboard composes progress, daily lesson, quiz, and continue lesson.

Risks:

- Some business rules live inside UI/provider classes instead of service layer.

Recommendations:

- Move unlock/reward rules into services when complexity grows.

## SharedPreferences

Strengths:

- Local-first progress works without backend.
- Game progress is separated from user progress.

Risks:

- No migration/versioning strategy yet.
- Clearing app data resets progress.

Recommendations:

- Add local data version and export/reset settings later.

## JSON Loading

Strengths:

- Content is bundled and offline.
- ContentCacheService caches main files.

Risks:

- `games.json` is loaded directly, not through ContentCacheService.
- No checked-in validation script yet.

Recommendations:

- Add validation script and unit test for data integrity.

## TTS

Strengths:

- TTS settings persist.
- Hindi/English language preference is considered.
- Failures are caught.

Risks:

- Device voice availability varies.
- Narrating emoji-heavy text may sound odd.

Recommendations:

- QA TTS on real Android and iPhone.

## Ads

Strengths:

- Feature flag: `ENABLE_ADS`.
- Test IDs are separated from production placeholders.
- Ads can be disabled completely.

Risks:

- Production IDs are placeholders.
- Child-directed ad compliance must be verified.

Recommendations:

- Keep ads disabled for launch unless compliance is complete.

## ShivBot

Strengths:

- Safety guard exists.
- Local fallback exists.
- Provider flag exists.

Risks:

- Direct OpenAI/Gemini URLs exist in app config paths.
- Production must not ship direct API keys or direct AI API dependency from Flutter.

Recommendations:

- Production ShivBot should use a secure backend/proxy only.
- Consider disabling non-local providers in production builds unless proxy is configured.

## Games

Strengths:

- Five games exist.
- Progress persistence works.
- Reward duplication is guarded.
- Tests exist.

Risks:

- Full 9-game ecosystem plan is not implemented.
- Game content is hardcoded in widgets, not data-driven levels.

Recommendations:

- Keep current 5 for v1.
- Add new games one at a time with tests.

## Quizzes

Strengths:

- Quiz model supports single and multiple answers.
- Quiz view model is tested.
- Lesson quiz and daily quiz paths exist.

Risks:

- Repeated generic quiz prompts need content review.
- Completion/reward model may need first-completion rules for quizzes.

Recommendations:

- Add content QA and duplicate wording review.

## Localization

Strengths:

- AppStrings and LocalizedContent separate UI/content text.
- TTS follows language mode.

Risks:

- Hindi coverage is incomplete.
- Hinglish/Devanagari consistency needs a glossary.

Recommendations:

- Finish Hindi parity before store launch.

## Tests

Current tests include:

- Ad config/stats.
- AI safety guard.
- Auth view model.
- Game completion.
- Game repository.
- Game routes.
- Gamification.
- Models.
- Navigation route map.
- Quiz view model.
- Dashboard widget.
- Lesson widget.
- Login widget.
- Small-screen navigation.
- Profile accessibility settings.
- Quiz widget.
- Static screens.

## Missing Tests

- JSON relational integrity test.
- Hindi localization overflow test.
- TTS graceful failure test.
- Course completion badge test.
- Production config safety test.
- Offline cold-start test.

## Production Blockers

| Blocker | Severity |
| --- | --- |
| ShivBot backend/proxy must be secured | High |
| Store privacy/data safety finalization | High |
| Hindi content parity | Medium |
| Real device QA | High |
| Production AdMob IDs/compliance if ads enabled | High |
| Level threshold alignment | Medium |

## Implementation Checklist

- [ ] Add JSON integrity tests.
- [ ] Finish localization QA.
- [ ] Lock ShivBot production provider.
- [ ] Align XP/level rules.
- [ ] Run Android/iOS release builds.
- [ ] Run real device QA.

## Acceptance Criteria

- Technical risks are known and prioritized.
- Production blockers are not hidden.
- Future refactors are practical, not speculative.
- Core learning remains local-first.

