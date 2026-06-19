# Phase 8 iOS Launch Runbook

## Purpose

Prepare AIWithShiv for TestFlight and App Store review.

## Current iOS App Identity

- Bundle ID: `com.aiwithshiv.app`
- Display name: `AI with Shiv`
- Recommended App Store title: `AI with Shiv: Kids Learn AI`
- App Store subtitle: `Comic AI learning for kids`
- Category: Education
- Audience: Indian children aged 5-10
- Minimum iOS deployment target: iOS 13.0
- Signing style: Automatic

## What Is Already Configured

- iOS app icon asset catalog exists.
- Launch screen assets exist.
- Bundle identifier is set.
- Release build without codesign has passed.
- Simulator build has passed.
- Store/privacy copy exists in `PHASE_5_STORE_PRIVACY_PACK.md`.

## Apple Developer Setup Needed

In Xcode:

1. Open `ios/Runner.xcworkspace`.
2. Select `Runner`.
3. Select the `Runner` target.
4. Open `Signing & Capabilities`.
5. Choose your Apple Developer Team.
6. Confirm bundle identifier is `com.aiwithshiv.app`.
7. Ensure Automatically manage signing is enabled.
8. Confirm a valid provisioning profile is created.

Do not change the bundle ID after creating the App Store Connect app unless you intentionally want a new app identity.

## Build Commands

Local compile verification without signing:

```bash
flutter build ios --release --no-codesign --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

Simulator verification:

```bash
flutter build ios --simulator --debug --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false
```

Signed device/archive build should be done from Xcode after selecting a real Apple Developer Team:

```bash
open ios/Runner.xcworkspace
```

Then in Xcode:

1. Select a real iPhone or `Any iOS Device`.
2. Product > Archive.
3. Distribute App.
4. App Store Connect.
5. Upload.

## App Store Connect Setup

1. Create a new app.
2. Platform: iOS.
3. Name: `AI with Shiv: Kids Learn AI`.
4. Primary language: English.
5. Bundle ID: `com.aiwithshiv.app`.
6. SKU: choose an internal value such as `aiwithshiv-ios-v1`.
7. Category: Education.
8. Age rating: complete based on child-safe educational content.
9. Add privacy policy URL.
10. Add support URL.

## App Privacy Notes

Use `PHASE_5_STORE_PRIVACY_PACK.md` as draft guidance.

For the launch build only if:

- `ENABLE_ADS=false`
- ShivBot backend is disabled or local fallback only
- analytics/crash reporting are not enabled
- no child login/account is enabled

Draft privacy label direction:

- Data used to track: none.
- Data linked to user: none for core learning.
- Data not linked to user: none for core learning.
- Explain local-only learning progress in the privacy policy.

If ShivBot backend, ads, analytics, crash reporting, or login are enabled, update App Privacy answers before upload.

## Kids Category Caution

The app is designed for children aged 5-10, but Apple Kids Category requirements are strict.

Before choosing Kids Category:

- Confirm no third-party advertising or analytics violate Kids Category rules.
- Confirm external links are behind parental gates.
- Confirm privacy policy and support URL are live.
- Confirm ShivBot handling is child-safe and compliant.

If unsure, submit as Education first and complete legal/privacy review before Kids Category.

## TestFlight QA Plan

Internal TestFlight:

- Add founder/tester Apple IDs.
- Install on at least one small iPhone and one modern iPhone.
- Test offline launch.
- Test Hindi mode.
- Test voice narration.
- Test lesson and quiz flow.
- Test all 5 games.
- Test trophy/profile/shop.
- Test back navigation.
- Confirm no ads appear with `ENABLE_ADS=false`.
- Confirm ShivBot fallback/backend behavior.

External TestFlight:

- Add 10-20 testers if available.
- Include parents and at least one teacher.
- Ask for feedback on clarity, safety, Hindi text, and performance.

## Required Screenshots

Capture screenshots after TestFlight build is stable:

- Dashboard
- Learning Path
- Lesson Screen
- Quiz Screen
- Games Screen
- Trophy Room
- Profile/Settings
- ShivBot fallback/chat screen if included in store listing

Use captions from `PHASE_5_STORE_PRIVACY_PACK.md`.

## Known Blockers Before App Store Review

- Apple Developer Team is not configured in the repo.
- Signed archive has not been uploaded.
- TestFlight QA is not complete.
- Privacy policy URL is not published.
- App Store screenshots are not captured.
- Legal review of privacy/terms is still pending.
- iOS AdMob app id is currently a test id; keep ads disabled or replace with production ids and update disclosures.

## Phase 8 Done Criteria

- App archive uploads to App Store Connect.
- Build is accepted by TestFlight.
- TestFlight QA has no critical issues.
- App privacy labels match the actual build.
- App Store review issues are resolved.
