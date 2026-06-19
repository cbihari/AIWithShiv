# Phase 8 iOS Launch Status

## Phase 8 Goal

Prepare AIWithShiv for TestFlight and App Store review.

## Completed In This Phase

- Verified iOS bundle identifier: `com.aiwithshiv.app`.
- Verified display name: `AI with Shiv`.
- Verified iOS deployment target: iOS 13.0.
- Verified app icon assets exist.
- Verified launch screen assets exist.
- Confirmed signing style is Automatic.
- Added iOS launch runbook.
- Documented App Store Connect setup steps.
- Documented TestFlight QA plan.
- Documented Apple privacy label draft guidance.

## Previously Verified Build Evidence

From Phase 6:

- `flutter build ios --release --no-codesign --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false` passed.
- `flutter build ios --simulator --debug --dart-define=APP_ENV=prod --dart-define=ENABLE_ADS=false` passed.

## Files Changed

- `docs/aiwithshiv-roadmap/PHASE_8_IOS_LAUNCH_RUNBOOK.md`
- `docs/aiwithshiv-roadmap/PHASE_8_IOS_LAUNCH_STATUS.md`
- `docs/aiwithshiv-roadmap/12_LAUNCH_CHECKLIST.md`

## What Is Ready

- Bundle ID is stable.
- iOS icon and launch assets exist.
- No-codesign release build compiles.
- Simulator build compiles.
- App Store listing copy exists.
- App privacy draft notes exist.
- TestFlight QA plan exists.

## What Still Requires User/App Store Connect Action

- Configure Apple Developer Team in Xcode.
- Create App Store Connect app record.
- Archive with real signing.
- Upload build to App Store Connect.
- Complete App Privacy labels.
- Add privacy policy URL and support URL.
- Capture iPhone screenshots.
- Run TestFlight QA on a real iPhone.
- Submit for App Store review.

## Important Ads Note

`ios/Runner/Info.plist` currently contains Google’s AdMob test app id. For v1 launch, keep `ENABLE_ADS=false`.

If ads are enabled later:

- Replace test AdMob app id and ad unit ids with production ids.
- Complete child-directed ad compliance review.
- Update App Privacy labels and privacy policy.

## Current Phase Status

Phase 8 is prepared but not complete.

It becomes complete only after:

- A signed archive is uploaded to App Store Connect.
- TestFlight accepts the build.
- Critical TestFlight feedback is resolved.
- App Store review issues are resolved.
