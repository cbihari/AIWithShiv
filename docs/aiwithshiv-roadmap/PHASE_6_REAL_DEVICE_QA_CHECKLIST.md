# Phase 6 Real-Device QA Checklist

## Purpose

Use this checklist before uploading AIWithShiv to Play Console closed testing or App Store Connect TestFlight.

This checklist must be completed on real devices. Simulator results are useful, but they do not replace physical-device QA.

## Required Build Configuration

Use v1-safe production flags:

```bash
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false --dart-define=AUTH_ENABLED=false --dart-define=SHIVBOT_PROVIDER=local
flutter build appbundle --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false --dart-define=AUTH_ENABLED=false --dart-define=SHIVBOT_PROVIDER=local
flutter build ios --release --no-codesign --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false --dart-define=AUTH_ENABLED=false --dart-define=SHIVBOT_PROVIDER=local
```

## Android Device QA

Device:

- Model:
- Android version:
- Screen size:
- Build installed:
- Tester:
- Date:

Checks:

- [ ] App installs successfully from release APK.
- [ ] App launches to the child welcome/dashboard flow.
- [ ] No login or signup is required.
- [ ] Dashboard fits without overflow.
- [ ] Learning path opens.
- [ ] A lesson opens and scrolls correctly.
- [ ] A quiz can be completed.
- [ ] XP and coins update after completion.
- [ ] Rewards do not duplicate on replay.
- [ ] All 5 games open.
- [ ] Each game can be completed.
- [ ] Game progress persists after app restart.
- [ ] Trophy/achievement screen opens.
- [ ] Profile/settings screen opens.
- [ ] Hindi mode renders without clipping.
- [ ] English mode still renders correctly.
- [ ] Voice narration toggle works, or fails gracefully if device TTS is unavailable.
- [ ] Offline airplane-mode launch works.
- [ ] Offline lesson and quiz content still works.
- [ ] ShivBot local/fallback mode does not crash.
- [ ] Ads do not appear with `ENABLE_ADS=false`.
- [ ] Android back button behavior is correct from dashboard, lessons, quizzes, games, profile, and trophies.
- [ ] No critical jank or frozen screen on low battery/data saver.

Android result:

- [ ] Pass
- [ ] Fail

Issues found:

| ID | Screen | Steps | Expected | Actual | Severity | Fixed? |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

## iPhone Device QA

Device:

- Model:
- iOS version:
- Install method: TestFlight / Xcode
- Build installed:
- Tester:
- Date:

Checks:

- [ ] App installs successfully.
- [ ] App launches to the child welcome/dashboard flow.
- [ ] No login or signup is required.
- [ ] Dashboard fits without overflow.
- [ ] Learning path opens.
- [ ] A lesson opens and scrolls correctly.
- [ ] A quiz can be completed.
- [ ] XP and coins update after completion.
- [ ] Rewards do not duplicate on replay.
- [ ] All 5 games open.
- [ ] Each game can be completed.
- [ ] Game progress persists after app restart.
- [ ] Trophy/achievement screen opens.
- [ ] Profile/settings screen opens.
- [ ] Hindi mode renders without clipping.
- [ ] English mode still renders correctly.
- [ ] Voice narration toggle works, or fails gracefully if device TTS is unavailable.
- [ ] Offline airplane-mode launch works.
- [ ] Offline lesson and quiz content still works.
- [ ] ShivBot local/fallback mode does not crash.
- [ ] Ads do not appear with `ENABLE_ADS=false`.
- [ ] iOS swipe/back/navigation behavior is correct from dashboard, lessons, quizzes, games, profile, and trophies.
- [ ] Dynamic Type/accessibility text does not break core screens.

iPhone result:

- [ ] Pass
- [ ] Fail

Issues found:

| ID | Screen | Steps | Expected | Actual | Severity | Fixed? |
| --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |

## Go/No-Go Rule

Go to store internal testing only when:

- Android physical-device QA passes or all critical bugs are fixed.
- iPhone physical-device QA passes or all critical bugs are fixed.
- Offline mode works.
- Hindi and English both pass.
- Ads remain hidden with `ENABLE_ADS=false`.
- No child login is required.

Do not submit public production until closed/internal testing feedback is clean.
