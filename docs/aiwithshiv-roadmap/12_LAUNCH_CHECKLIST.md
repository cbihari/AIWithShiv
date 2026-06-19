# Launch Checklist

## Purpose

Provide a practical Play Store and App Store launch checklist for AIWithShiv.

## Android Checklist

- [ ] Confirm package name.
- [ ] Configure release signing.
- [ ] Build Android App Bundle.
- [ ] Test release APK/AAB on real Android device.
- [ ] Confirm min SDK and target SDK.
- [ ] Confirm launcher icon.
- [ ] Confirm splash screen.
- [ ] Confirm app works offline.
- [ ] Confirm no Firebase dependency in core flow.

## iOS Checklist

- [ ] Confirm bundle ID.
- [ ] Configure signing team.
- [ ] Configure app icons.
- [ ] Configure launch screen.
- [ ] Build archive in Xcode.
- [ ] Test on real iPhone.
- [ ] Upload to TestFlight.
- [ ] Run TestFlight QA.

## AdMob Checklist

- [ ] Keep `ENABLE_ADS=false` unless ready.
- [ ] Replace production ad IDs before enabling in prod.
- [ ] Confirm child-directed treatment requirements.
- [ ] Do not show ads during lessons.
- [ ] Do not show ads during quizzes.
- [ ] Do not show ads during games.
- [ ] Do not show ads during ShivBot.
- [ ] Test ad failure gracefully.

## Privacy and Data Safety

- [ ] Finalize privacy policy.
- [ ] Finalize terms.
- [ ] Complete Google Play Data safety form.
- [ ] Complete Apple privacy nutrition labels.
- [ ] Document local progress storage.
- [ ] Document optional ads data if enabled.
- [ ] Document ShivBot backend data if enabled.

## Child Safety Compliance

- [ ] No child login required.
- [ ] No phone/email/password required.
- [ ] No direct AI API key in Flutter.
- [ ] Safe content review complete.
- [ ] Ads policy reviewed if ads enabled.
- [ ] Parent-friendly safety explanation complete.

## Testing Checklist

- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Android release build.
- [ ] iOS release/archive build.
- [ ] Small screen test.
- [ ] Hindi mode test.
- [ ] Voice narration test.
- [ ] Offline airplane-mode test.
- [ ] Low-end device performance test.
- [ ] Back button/navigation test.
- [ ] Game reward replay test.
- [ ] ShivBot fallback/backend test.

## Final Build Commands

Android:

```bash
flutter clean
flutter pub get
flutter build appbundle --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

iOS:

```bash
flutter clean
flutter pub get
flutter build ios --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

Testing:

```bash
flutter analyze
flutter test
```

## Current Project Understanding

The project already builds and tests locally in prior work. Current code has optional ads and local-first learning. Production launch still requires real device QA, store assets, signing, privacy policy, and child-safety review.

## What Already Exists

- Android/iOS project structure.
- App icon/splash assets.
- Optional ads flag.
- Privacy policy draft.
- Terms draft.
- Store readiness checklist.
- Tests.

## What Is Missing

- Final signing verification.
- Production AdMob IDs.
- Final privacy policy URL.
- Store screenshots.
- TestFlight/closed testing evidence.
- Final child-safety review.

## Recommended Next Steps

1. Finish content QA.
2. Run Android/iOS real device tests.
3. Prepare store assets.
4. Submit internal testing first.

## Acceptance Criteria

- App builds in release mode for Android and iOS.
- App works offline.
- Store forms are truthful.
- No private key/API key ships in app.
- Child safety claims are backed by implementation.

