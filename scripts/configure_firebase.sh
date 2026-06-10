#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${FIREBASE_PROJECT_ID:-aiwithshiv-dev-c4197}"
ANDROID_PACKAGE="${ANDROID_PACKAGE:-com.aiwithshiv.app}"
IOS_BUNDLE_ID="${IOS_BUNDLE_ID:-com.aiwithshiv.app}"
PLATFORMS="${FLUTTERFIRE_PLATFORMS:-android,ios,web}"

if ! command -v firebase >/dev/null 2>&1; then
  echo "Firebase CLI is required. Install it with: npm install -g firebase-tools" >&2
  exit 1
fi

if ! command -v flutterfire >/dev/null 2>&1; then
  echo "FlutterFire CLI is required. Install it with: dart pub global activate flutterfire_cli" >&2
  echo 'Make sure $HOME/.pub-cache/bin is on your PATH.' >&2
  exit 1
fi

firebase projects:list >/dev/null
firebase use "$PROJECT_ID"

flutterfire configure \
  --project="$PROJECT_ID" \
  --platforms="$PLATFORMS" \
  --android-package-name="$ANDROID_PACKAGE" \
  --ios-bundle-id="$IOS_BUNDLE_ID" \
  --out=lib/config/firebase_options.dart \
  --yes

firebase deploy --only firestore:rules,firestore:indexes,storage
