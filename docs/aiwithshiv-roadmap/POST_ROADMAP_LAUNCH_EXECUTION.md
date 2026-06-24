# Post-Roadmap Launch Execution

## Purpose

Track the work after Phase 1-8 roadmap completion. This phase is not new product development. It is the operational launch path for Play Console, TestFlight, and App Store Connect.

## New Readiness Command

Run:

```bash
node scripts/verify_launch_readiness.mjs
```

The script checks:

- Content JSON validity.
- Android package id.
- iOS bundle id.
- Age 5-10 app metadata.
- Default launch feature flags.
- No hardcoded API secret pattern in app source.
- No Firebase package/reference in app source.
- Store/privacy/runbook docs exist.
- Android/iOS build artifacts exist when available.
- Android signing files are present locally when ready.

Warnings are expected until manual launch steps are complete.

## Expected Warnings Before Manual Launch

These are normal before store upload:

- `android/key.properties` missing.
- `android/upload-keystore.jks` missing.
- Android AAB/APK artifacts missing if builds have not been run after a clean.
- iOS build artifact missing if iOS build has not been run after a clean.
- Google test AdMob ids present while `ENABLE_ADS=false`.

Do not treat these as blockers for development. Treat them as reminders before store submission.

## What To Do Next

1. Create Android upload keystore.
2. Build signed Android AAB.
3. Install release APK on real Android.
4. Configure Apple Developer Team in Xcode.
5. Upload iOS build to TestFlight.
6. Run Android and iPhone real-device QA.
7. Capture screenshots.
8. Publish privacy/support URLs.
9. Complete store forms.

## Commands

Android:

```bash
keytool -genkey -v \
  -keystore android/upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

cp android/key.properties.example android/key.properties

flutter build appbundle --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
flutter build apk --release --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
node scripts/verify_launch_readiness.mjs
```

iOS:

```bash
open ios/Runner.xcworkspace
```

Then configure signing team and archive from Xcode.

## Go/No-Go Rule

Public production remains No-go until:

- Real Android QA passes.
- Real iPhone/TestFlight QA passes.
- Signed Android AAB is accepted by Play Console internal testing.
- Signed iOS build is accepted by TestFlight.
- Privacy/support URLs are live.
- Store forms match the actual build.
