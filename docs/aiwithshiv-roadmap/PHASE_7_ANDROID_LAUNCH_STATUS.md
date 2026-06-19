# Phase 7 Android Launch Status

## Phase 7 Goal

Prepare AIWithShiv for Google Play internal testing, closed testing, and production rollout.

## Completed In This Phase

- Added Android release signing support using local `android/key.properties`.
- Added safe signing example file: `android/key.properties.example`.
- Kept keystore and password files untracked/ignored.
- Updated app metadata description to children aged 5-10.
- Added Android launch runbook.
- Updated launch checklist for release signing support.

## Files Changed

- `android/app/build.gradle.kts`
- `android/key.properties.example`
- `pubspec.yaml`
- `docs/aiwithshiv-roadmap/PHASE_7_ANDROID_LAUNCH_RUNBOOK.md`
- `docs/aiwithshiv-roadmap/12_LAUNCH_CHECKLIST.md`

## What Is Ready

- Android package name is set to `com.aiwithshiv.app`.
- AAB build command is documented.
- APK QA build command is documented.
- Data safety draft notes exist for ads-disabled/local-first launch.
- Internal testing checklist is documented.

## What Still Requires User/Play Console Action

- Create real upload keystore.
- Keep `android/key.properties` local and uncommitted.
- Rebuild release AAB with real upload signing.
- Upload AAB to Play Console.
- Publish privacy policy URL.
- Add screenshots and feature graphic.
- Complete Play Console Data safety, content rating, target audience, and app access forms.
- Run physical Android device QA.

## Important Signing Note

If `android/key.properties` is missing, the project falls back to debug signing so local release builds still compile. This fallback artifact must not be uploaded to Play Console.

For Play Console, create the real upload keystore and `android/key.properties`, then rebuild the AAB.

## Current Phase Status

Phase 7 is prepared but not complete.

It becomes complete only after:

- A signed AAB is uploaded to Play Console internal/closed testing.
- Google Play accepts the build for testing.
- Critical tester feedback is resolved.
