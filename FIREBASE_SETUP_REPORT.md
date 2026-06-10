# Firebase Setup Report

Generated: 2026-06-09

## Firebase project

- Project display name: AIWithShiv Dev
- Project ID: aiwithshiv-dev-c4197
- Project number: 55694799834
- Firebase CLI account used: cbihari671@gmail.com

## Platforms configured

- Android: com.aiwithshiv.app
- iOS: com.aiwithshiv.app
- Web: aiwithshiv (web)

## Firebase apps

- Android app ID: 1:55694799834:android:906ac746689cfcac5d06e3
- iOS app ID: 1:55694799834:ios:82dccc07e54a2dda5d06e3
- Web app ID: 1:55694799834:web:18e3096731f46bad5d06e3

## Files generated or updated

- lib/config/firebase_options.dart
- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist
- android/settings.gradle.kts
- android/app/build.gradle.kts
- firebase.json
- .firebaserc
- web/index.html
- web/manifest.json
- web/favicon.png
- web/icons/Icon-192.png
- web/icons/Icon-512.png
- web/icons/Icon-maskable-192.png
- web/icons/Icon-maskable-512.png
- lib/main.dart
- scripts/configure_firebase.sh
- scripts/seed_firestore.mjs

## Commands run

```sh
npm install -g firebase-tools
firebase --version
dart pub global activate flutterfire_cli
$HOME/.pub-cache/bin/flutterfire --version
flutter --version
firebase login --no-localhost
firebase projects:list
firebase projects:create aiwithshiv-dev --display-name 'AIWithShiv Dev'
firebase projects:addfirebase aiwithshiv-dev
$HOME/.pub-cache/bin/flutterfire configure --project=aiwithshiv-dev-c4197 --platforms=android,ios,web --android-package-name=com.aiwithshiv.app --ios-bundle-id=com.aiwithshiv.app --out=lib/config/firebase_options.dart --yes
npm run seed:firestore
flutter create --platforms=web .
flutter pub get
firebase use aiwithshiv-dev-c4197
flutter run -d chrome
flutter analyze
firebase apps:list --project aiwithshiv-dev-c4197
firebase firestore:databases:list --project aiwithshiv-dev-c4197
firebase firestore:databases:create '(default)' --location nam5 --project aiwithshiv-dev-c4197
firebase deploy --only firestore:rules,firestore:indexes --project aiwithshiv-dev-c4197
firebase functions:list --project aiwithshiv-dev-c4197
flutter run -d chrome
```

Service Usage REST calls were also used with the Firebase CLI access token to enable:

- firestore.googleapis.com
- cloudfunctions.googleapis.com
- identitytoolkit.googleapis.com

No service account JSON was created or added.

## Current Firebase status

- Firebase Core: configured for Android, iOS, and Web.
- Firestore: API enabled, default database created in nam5, rules deployed, indexes deployed.
- Cloud Functions: API enabled; no deployed functions found.
- Analytics: Web app has a generated measurement ID in firebase_options.dart.
- App Check: Android/iOS activation is configured. Web App Check is opt-in via `--dart-define=FIREBASE_APP_CHECK_RECAPTCHA_SITE_KEY=...` because this plugin requires a reCAPTCHA provider key on Web.
- Storage: client config generated, but the default Firebase Storage bucket is not provisioned yet.

## Remaining Firebase tasks

- Enable Email/password in Firebase Console: Authentication > Sign-in method > Email/Password.
- Enable Google login later: Authentication > Sign-in method > Google.
- Enable Apple login later: Authentication > Sign-in method > Apple.
- Set up Firebase Storage in the Console. The REST create call returned `403 PERMISSION_DENIED`; Firebase documentation says new default buckets created after 2024-10-30 require the pay-as-you-go Blaze plan.
- Deploy Storage rules after Storage is provisioned:

```sh
firebase deploy --only storage --project aiwithshiv-dev-c4197
```

- Deploy Cloud Functions when backend secrets and billing/runtime requirements are ready:

```sh
firebase deploy --only functions --project aiwithshiv-dev-c4197
```

- Add a Web App Check reCAPTCHA v3 key if App Check should be active on Chrome:

```sh
flutter run -d chrome --dart-define=FIREBASE_APP_CHECK_RECAPTCHA_SITE_KEY=YOUR_RECAPTCHA_V3_SITE_KEY
```

- Keep OpenAI, Gemini, and AWS credentials out of the Flutter client. Use backend functions or a proxy for provider secrets.
- Seed Firestore only after a real service account path is available:

```sh
GOOGLE_APPLICATION_CREDENTIALS=/absolute/path/to/service-account.json npm run seed:firestore
```

## How to run locally

```sh
flutter pub get
flutter run -d chrome
```

For Android or iOS:

```sh
flutter run -d android
flutter run -d ios
```

If `flutterfire` is not found in a future shell, add Pub's global bin directory to PATH:

```sh
export PATH="$PATH":"$HOME/.pub-cache/bin"
```
