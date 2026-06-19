# Phase 6 QA Report

## Phase 6 Goal

Verify Android/iOS release readiness, offline-first assumptions, and remaining real-device QA risks before store submission.

## Environment Checked

Date: 2026-06-20

Connected devices from `flutter devices`:

- iPhone 16e simulator: `451EE975-169F-45C2-9021-C06D3AC1E336`
- macOS desktop
- Chrome web

No physical Android or physical iPhone was connected during this QA pass.

## Commands Run

```bash
node scripts/validate_content.mjs
flutter devices
flutter analyze
flutter test
flutter build appbundle --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build ios --release --no-codesign --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build ios --simulator --debug --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

## Results

| Check | Result |
| --- | --- |
| Content validation | Passed |
| Flutter analyze | Passed |
| Flutter tests | Passed |
| Android AAB release build | Passed |
| Android APK release build | Passed |
| iOS release build without codesign | Passed |
| iOS simulator build | Passed |
| Physical Android install test | Not run: no device connected |
| Physical iPhone/TestFlight test | Not run: no physical device/TestFlight session |

## Build Artifacts

Android Play Store artifact:

- `build/app/outputs/bundle/release/app-release.aab`
- Size observed: 46.9 MB

Android manual install artifact:

- `build/app/outputs/flutter-apk/app-release.apk`
- Size observed: 55.3 MB

iOS no-codesign release artifact:

- `build/ios/iphoneos/Runner.app`
- Size observed: 30.8 MB

iOS simulator artifact:

- `build/ios/iphonesimulator/Runner.app`

## Configuration Checks

Android package:

- `com.aiwithshiv.app`

iOS bundle identifier:

- `com.aiwithshiv.app`

Ads:

- Release builds were made with `--dart-define=ENABLE_ADS=false`.
- AdMob SDK assets may still be bundled because the dependency exists, but ads should not load when disabled.

Firebase:

- No Firebase references were found in current `lib`, `android`, `ios`, or `pubspec.yaml` search results during this QA pass.
- Core learning remains local-first.

OpenAI/API keys:

- No hardcoded OpenAI secret key pattern was found in current app code search results.
- The app still exposes environment configuration for optional ShivBot providers/base URLs, but direct API keys should not ship in Flutter.

## Manual Real-Device QA Still Required

Android physical device:

- Install `build/app/outputs/flutter-apk/app-release.apk`.
- Launch with airplane mode enabled.
- Verify dashboard opens.
- Verify Hindi mode.
- Open Learning Path.
- Open one lesson.
- Complete one quiz.
- Play each of the 5 games.
- Verify back buttons.
- Verify rewards do not duplicate on replay.
- Verify voice narration if device TTS supports selected language.
- Verify no ads appear with `ENABLE_ADS=false`.

iPhone physical device or TestFlight:

- Archive/sign in Xcode.
- Install through TestFlight or direct development signing.
- Launch with network disabled.
- Verify dashboard, learning path, lesson, quiz, games, trophies, profile, and shop.
- Verify Hindi text does not overflow.
- Verify voice narration and accessibility settings.
- Verify ShivBot fallback behavior if backend is disabled.

## Phase 6 Acceptance Criteria Status

| Acceptance criteria | Status |
| --- | --- |
| No critical compile/build crash | Complete |
| Android release artifact builds | Complete |
| iOS release artifact builds without codesign | Complete |
| iOS simulator artifact builds | Complete |
| No major automated overflow regression | Complete through widget tests |
| App works offline | Pending physical/simulator manual pass |
| Physical Android QA | Pending |
| Physical iPhone/TestFlight QA | Pending |

## Next Phase Recommendation

Do not submit to stores until physical-device QA is complete.

Recommended next steps:

1. Run Android release APK on a real Android phone.
2. Run iOS build through Xcode/TestFlight on a real iPhone.
3. Capture final screenshots after real-device QA passes.
4. Then proceed to Phase 7 Android Launch.
