# Launch Checklist

## Purpose

Provide a practical Play Store and App Store launch checklist for AIWithShiv.

## Android Checklist

- [x] Confirm package name.
- [x] Configure release signing support.
- [ ] Create real Play upload keystore locally.
- [ ] Run `node scripts/verify_android_signing.mjs`.
- [x] Build Android App Bundle.
- [ ] Test release APK/AAB on real Android device.
- [ ] Confirm min SDK and target SDK.
- [x] Confirm launcher icon assets exist.
- [x] Confirm splash screen assets exist.
- [ ] Confirm app works offline.
- [x] Confirm no Firebase dependency in core flow.

## iOS Checklist

- [x] Confirm bundle ID.
- [x] Confirm iOS deployment target.
- [ ] Configure signing team.
- [x] Configure app icons.
- [x] Configure launch screen.
- [x] Build iOS release without codesign.
- [x] Build iOS simulator artifact.
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

- [x] No child login required.
- [x] No phone/email/password required.
- [x] No direct AI API key in Flutter.
- [ ] Safe content review complete.
- [ ] Ads policy reviewed if ads enabled.
- [x] Parent-friendly safety explanation complete.

## Testing Checklist

- [x] `flutter analyze`
- [x] `flutter test`
- [x] Android release build.
- [x] iOS release/no-codesign build.
- [x] Small screen automated tests.
- [x] Hindi mode automated tests.
- [ ] Voice narration test.
- [ ] Offline airplane-mode test.
- [ ] Low-end device performance test.
- [x] Back button/navigation automated tests.
- [x] Game reward replay tests.
- [ ] ShivBot fallback/backend test.

Use `PHASE_6_REAL_DEVICE_QA_CHECKLIST.md` for the required Android/iPhone physical-device QA pass before store internal testing.

## Final Build Commands

Android:

```bash
flutter clean
flutter pub get
bash scripts/build_android_store.sh
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
