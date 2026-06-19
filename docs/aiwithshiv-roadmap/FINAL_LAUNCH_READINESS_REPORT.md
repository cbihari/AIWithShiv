# Final Launch Readiness Report

## Purpose

Summarize AIWithShiv launch readiness after completing the documented roadmap work from Phase 1 through Phase 8.

## Current Status

AIWithShiv is technically prepared for store-account work, but it is not ready for public production submission until physical-device QA, signing, privacy URL, screenshots, and store console forms are completed.

## Phase Status

| Phase | Status | Evidence |
| --- | --- | --- |
| Phase 1: Content Architecture and Curriculum Cleanup | Complete | Content validation, 3 courses, 30 lessons, 30 quizzes |
| Phase 2: Course 2 and Course 3 Content | Complete | `PHASE_2_COMPLETION_REPORT.md` |
| Phase 3: Games and Reward Balancing | Complete for v1 scope | `PHASE_3_COMPLETION_REPORT.md` |
| Phase 4: Parent/Teacher Support | Complete as docs/content pack | `PHASE_4_COMPLETION_REPORT.md` |
| Phase 5: Store Assets and Privacy | Complete as copy/draft pack | `PHASE_5_COMPLETION_REPORT.md` |
| Phase 6: Real Device QA | Partially complete | Builds/tests passed; physical Android/iPhone QA still pending |
| Phase 7: Android Launch | Prepared, blocked by Play Console/manual steps | Signing support and runbook exist; upload not done |
| Phase 8: iOS Launch | Prepared, blocked by Apple Developer/manual steps | iOS runbook exists; signed archive/TestFlight not done |

## Verified Technical Evidence

Recent verified commands:

```bash
node scripts/validate_content.mjs
flutter analyze
flutter test
flutter build appbundle --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build ios --release --no-codesign --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build ios --simulator --debug --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

Build artifacts verified:

- Android AAB: `build/app/outputs/bundle/release/app-release.aab`
- Android APK: `build/app/outputs/flutter-apk/app-release.apk`
- iOS no-codesign app: `build/ios/iphoneos/Runner.app`
- iOS simulator app: `build/ios/iphonesimulator/Runner.app`

## Product Scope Frozen For V1

V1 scope:

- Android and iOS only.
- Children aged 5-10.
- No child login for core learning.
- Local-first learning progress.
- 3 courses.
- 30 lessons.
- 30 quizzes.
- 5 games.
- Hindi/English support.
- Voice/accessibility support.
- Ads disabled by default.
- ShivBot optional through separate backend only.

Do not add before first launch:

- Child social features.
- Public leaderboards.
- New age groups.
- More games.
- Parent surveillance dashboard.
- Ads-enabled launch without compliance review.
- Direct AI API keys inside Flutter.

## Critical Blockers Before Store Submission

### Android

- Create real Play upload keystore.
- Create local `android/key.properties`.
- Rebuild signed AAB.
- Install APK on physical Android phone.
- Test offline, Hindi, voice, lessons, quizzes, games, profile, trophies, and ShivBot fallback.
- Create Play Console app.
- Upload AAB to internal testing.
- Complete Data safety and target audience forms.
- Publish privacy policy URL.
- Add screenshots and feature graphic.

### iOS

- Configure Apple Developer Team in Xcode.
- Archive signed build.
- Create App Store Connect app.
- Upload archive to TestFlight.
- Run TestFlight on physical iPhone.
- Complete App Privacy labels.
- Publish privacy policy URL.
- Add screenshots and support URL.
- Submit for review only after TestFlight feedback is clean.

### Legal/Policy

- Privacy policy draft needs legal review.
- Terms draft needs legal review.
- Child safety/content review needs final signoff.
- Ads should remain disabled unless child-directed ad compliance is completed.

## Exact Next Manual Commands

Android signing setup:

```bash
keytool -genkey -v \
  -keystore android/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

cp android/key.properties.example android/key.properties
```

Edit `android/key.properties`, then build:

```bash
flutter clean
flutter pub get
flutter build appbundle --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

iOS signing setup:

```bash
open ios/Runner.xcworkspace
```

Then in Xcode:

1. Select `Runner`.
2. Select your Apple Developer Team.
3. Choose `Any iOS Device`.
4. Product > Archive.
5. Distribute App > App Store Connect > Upload.

## Screenshot Capture Checklist

Capture only after real-device QA passes:

- Dashboard.
- Learning Path.
- Lesson Screen.
- Quiz Screen.
- Games Screen.
- Trophy Room.
- Profile/Settings.
- ShivBot fallback/chat screen if included in listing.

Use captions from `PHASE_5_STORE_PRIVACY_PACK.md`.

## Recommended Order From Here

1. Run Android physical-device QA using the release APK.
2. Create Android upload keystore and signed AAB.
3. Upload to Play Console internal testing.
4. Configure Apple Developer Team and upload to TestFlight.
5. Run physical iPhone TestFlight QA.
6. Capture screenshots.
7. Publish privacy/support URLs.
8. Complete store forms.
9. Submit internal/closed testing first, not production.

## Go/No-Go

Current decision: No-go for public production.

Reason:

- Physical Android QA is pending.
- Physical iPhone/TestFlight QA is pending.
- Store signing and account uploads are pending.
- Privacy/support URLs are pending.
- Legal/policy review is pending.

Decision can change to Go for internal testing after signed Android AAB and signed iOS TestFlight build are uploaded successfully.
