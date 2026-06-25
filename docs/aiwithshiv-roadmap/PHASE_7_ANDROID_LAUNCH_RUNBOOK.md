# Phase 7 Android Launch Runbook

## Purpose

Prepare AIWithShiv for Google Play internal testing, closed testing, and production rollout.

## Current Android App Identity

- Package name: `com.aiwithshiv.app`
- App title recommendation: `AI with Shiv: Kids Learn AI`
- Category: Education
- Audience: Indian children aged 5-10
- Core learning: local-first
- Ads: disabled for launch builds unless compliance is complete

## Release Signing Setup

Release signing is configured to read `android/key.properties` when present.

Do not commit:

- `android/key.properties`
- `.jks`
- `.keystore`
- passwords

These files are already ignored by git.

Create a local upload keystore:

```bash
keytool -genkey -v \
  -keystore android/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

Create local signing config:

```bash
cp android/key.properties.example android/key.properties
```

Then edit `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

Important:

The current Gradle setup falls back to debug signing if `android/key.properties` is missing. That is acceptable for local compile verification only. Play Console upload must use a real release/upload key.

## Build Commands

Clean and fetch dependencies:

```bash
flutter clean
flutter pub get
```

Verify Android release signing:

```bash
node scripts/verify_android_signing.mjs
```

Build Play Store AAB with signing guard:

```bash
bash scripts/build_android_store.sh
```

Build manual QA APK:

```bash
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false --dart-define=AUTH_ENABLED=false --dart-define=SHIVBOT_PROVIDER=local
```

Expected artifacts:

- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

## Pre-Upload Verification

Run:

```bash
node scripts/validate_content.mjs
node scripts/verify_android_signing.mjs
flutter analyze
flutter test
```

Manual Android QA before upload:

- Install release APK on a real Android phone.
- Test airplane mode launch.
- Test dashboard.
- Test Hindi mode.
- Test one lesson.
- Test one quiz.
- Test all 5 games.
- Test back navigation.
- Test trophies/profile/shop.
- Test voice narration.
- Confirm no ads appear with `ENABLE_ADS=false`.
- Confirm ShivBot fallback if backend is disabled.

## Play Console Internal Testing Steps

1. Create/select app in Google Play Console.
2. Set package name to `com.aiwithshiv.app`.
3. Choose Education category.
4. Upload `app-release.aab` to Internal testing.
5. Add tester email list.
6. Complete app content declarations:
   - Target audience and content.
   - Data safety.
   - Ads declaration.
   - App access.
   - Content rating questionnaire.
   - Privacy policy URL.
7. Fill store listing using `PHASE_5_STORE_PRIVACY_PACK.md`.
8. Add screenshots captured from real Android device.
9. Add feature graphic.
10. Submit internal testing build.

## Data Safety Draft For Ads Disabled And ShivBot Disabled

Use this only if the production build has:

- `ENABLE_ADS=false`
- ShivBot backend disabled or local fallback only
- No analytics/crash reporting enabled
- No account/login collection

Draft answers:

- Data collected: No, for core learning flow.
- Data shared: No, for core learning flow.
- Data encrypted in transit: Not applicable for local-only core learning.
- User can request data deletion: Local app data is removable by uninstalling; backend deletion process is needed only if backend features are enabled.
- App has account creation: No.
- App uses ads: No for launch build if `ENABLE_ADS=false`.

If ads, ShivBot backend, analytics, crash reporting, or accounts are enabled, update these answers before submission.

## Child-Directed Declaration Notes

For v1:

- Audience includes children aged 5-10.
- Content is educational.
- No child login required.
- No child phone/email/password required.
- No public social features.
- No public user-generated content.
- No ads in launch build if `ENABLE_ADS=false`.

Review Google Play Families policy before choosing any family/kids program options.

## Closed Testing Plan

Internal test first:

- 3-5 trusted testers.
- Test on at least one small Android phone and one modern Android phone.
- Test offline mode.
- Test Hindi mode.
- Test TTS.
- Test full first course path.
- Test all games.

Closed test next:

- 10-20 testers if available.
- Include at least one parent and one teacher.
- Collect feedback on clarity, safety, Hindi text, and performance.

## Known Blockers Before Production

- Real Android device QA is not yet recorded.
- Privacy policy URL is not yet published.
- Release/upload keystore is not yet confirmed in repo docs as created.
- Store screenshots and feature graphic are not yet produced.
- Legal review of privacy/terms is still required.

## Phase 7 Done Criteria

- AAB uploaded to Play Console internal or closed testing.
- Android build approved for testing.
- Critical tester feedback resolved.
- Store listing and data safety forms match the actual build.
