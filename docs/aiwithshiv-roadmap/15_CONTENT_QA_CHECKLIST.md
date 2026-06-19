# Content QA Checklist

## Purpose

Provide a repeatable checklist to review every lesson, quiz, game, achievement, reward, and localized string before launch.

## Lesson QA

- [ ] Title is short and child-friendly.
- [ ] Story teaches one main concept.
- [ ] Story uses familiar Indian examples.
- [ ] Story is age-appropriate for 5-10.
- [ ] No scary/adult/political/unsafe content.
- [ ] No private data request.
- [ ] Safety reminder appears when needed.
- [ ] TTS reads naturally.
- [ ] Hindi adaptation exists or is marked TODO.
- [ ] Lesson connects to quiz.

## Quiz QA

- [ ] Quiz has exactly 2 questions.
- [ ] Each question has exactly 4 options.
- [ ] Correct answer is unambiguous.
- [ ] Wrong answers are not confusing.
- [ ] Explanation is short and helpful.
- [ ] No trick questions.
- [ ] No private data examples.
- [ ] Hindi version fits UI.
- [ ] Question matches lesson concept.

## Game QA

- [ ] Game route opens.
- [ ] Back button works.
- [ ] Instructions are clear.
- [ ] Game teaches one AI concept.
- [ ] Completion is possible on small screen.
- [ ] First completion awards XP/coins.
- [ ] Replay does not duplicate rewards.
- [ ] Badge unlocks correctly.
- [ ] No ads during gameplay.
- [ ] Safety note is included where needed.

## Achievement QA

- [ ] Achievement ID is stable.
- [ ] Title is child-friendly.
- [ ] Description is clear.
- [ ] Icon exists in supported icon set or is handled.
- [ ] Unlock rule is implemented.
- [ ] Badge does not unlock unfairly.
- [ ] Badge can be explained to parent.

## Reward Balance QA

- [ ] XP values are not too high.
- [ ] Coins are exciting but not required.
- [ ] Replay cannot farm rewards.
- [ ] Ads are optional only.
- [ ] Shop prices feel reachable.
- [ ] Level thresholds are consistent.

## Localization QA

- [ ] English text is simple.
- [ ] Hindi/Hinglish is natural.
- [ ] No awkward word-for-word translation.
- [ ] Devanagari renders correctly.
- [ ] Hindi text does not overflow.
- [ ] TTS handles selected language.

## Child Safety QA

- [ ] No request for password, address, phone, email, school ID, or private photo.
- [ ] AI mistake-checking is taught.
- [ ] Trusted adult guidance appears.
- [ ] No fear-based safety messaging.
- [ ] No social sharing pressure.
- [ ] No leaderboard pressure.

## AI Accuracy QA

- [ ] AI definition is simple but correct.
- [ ] AI is not described as magic.
- [ ] Children understand humans stay responsible.
- [ ] Training/examples/data/patterns are explained accurately.
- [ ] Limitations and mistakes are mentioned.

## Parent Trust QA

- [ ] App explains no child login is required.
- [ ] App explains local-first learning.
- [ ] Store copy matches implementation.
- [ ] Privacy policy is truthful.
- [ ] Ads policy is clear if ads are enabled.

## Technical QA

- [ ] JSON parses.
- [ ] IDs are unique.
- [ ] All lesson IDs referenced by courses exist.
- [ ] Every lesson has a quiz.
- [ ] Active game routes exist.
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.

## Acceptance Criteria

- Every launch lesson, quiz, and game passes this checklist.
- Any failed item has a tracked TODO.
- Content feels safe, joyful, and age-appropriate.
- Parent trust is protected.

