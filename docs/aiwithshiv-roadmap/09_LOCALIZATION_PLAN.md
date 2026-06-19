# Localization Plan

## Purpose

Define English/Hindi localization strategy for UI, content, TTS, QA, and future scaling.

## Current Project Understanding

The app uses:

- `AppStrings` for UI labels.
- `LanguageService` for runtime language selection.
- `LocalizedContent` for content overrides.
- `TtsService` to choose `hi-IN`/`hi` or `en-IN`/`en-US`/`en`.

## Current Status

| Area | Status |
| --- | --- |
| UI labels | Partially Hindi |
| Course cards | Hindi metadata exists for current courses |
| Course 1 lesson/quiz content | Partial Hindi support |
| Course 2 and 3 lesson/quiz content | Mostly English fallback |
| Games | Partial Hindi support |
| TTS language switching | Supported if device voice exists |
| QA coverage | Needs expansion |

## Hindi Adaptation Rules

- Use natural Hinglish where it helps children.
- Do not translate technical terms awkwardly if English is familiar.
- Keep Hindi simple and spoken.
- Use Devanagari for common Hindi phrases when helpful.
- Keep key AI words consistent: AI, examples, patterns, robot, data.
- Avoid word-for-word translation.

## Example Style

English:

"AI learns from clear examples."

Hindi/Hinglish:

"AI clear examples से सीखता है."

## Runtime Mapping

| Type | Current source |
| --- | --- |
| Button text | `AppStrings` |
| Screen labels | `AppStrings` |
| Course text | `LocalizedContent.course` |
| Lesson text | `LocalizedContent.lesson` |
| Quiz text | `LocalizedContent.quiz` |
| Game text | `LocalizedContent.game` |

## Voice Narration

TTS should:

- Use Hindi voice when Hindi mode is selected.
- Fall back gracefully when Hindi voice is unavailable.
- Avoid reading emoji-heavy text.
- Keep narration short.
- Stop speaking when leaving screen.

## Testing Checklist

- [ ] Toggle English to Hindi.
- [ ] Dashboard does not overflow.
- [ ] Learning path cards remain readable.
- [ ] Lesson TTS works or fails silently.
- [ ] Quiz prompts fit on small devices.
- [ ] Game labels fit.
- [ ] Profile settings persist language.
- [ ] Hindi strings do not break layout.

## What Already Exists

- Language toggle.
- Runtime language service.
- TTS language selection.
- Hindi UI strings and some content.

## What Is Missing

- Full Hindi content parity for all 30 lessons.
- Hindi quiz parity for all 30 quizzes.
- Hindi QA sign-off.
- Localization coverage test.
- Translation glossary.

## Recommended Next Steps

1. Create Hindi glossary.
2. Localize Course 2 and Course 3 lessons/quizzes.
3. Test on small iPhone simulator and Android device.
4. Add a content coverage check.

## Implementation Checklist

- [ ] Build glossary.
- [ ] Localize all course titles/descriptions.
- [ ] Localize all lessons.
- [ ] Localize all quizzes.
- [ ] Localize all games.
- [ ] Run widget overflow tests in both languages.

## Acceptance Criteria

- Hindi mode feels intentional, not partial.
- Children can understand Hindi/Hinglish without adult help.
- TTS does not crash when language voice is missing.
- No layout breaks in Hindi mode.

