#!/usr/bin/env bash
set -euo pipefail

flutter clean
flutter pub get
flutter build appbundle --release \
  --dart-define=APP_ENV="${APP_ENV:-prod}" \
  --dart-define=ENABLE_ADS="${ENABLE_ADS:-false}" \
  --dart-define=AUTH_ENABLED="${AUTH_ENABLED:-false}" \
  --dart-define=SHIVBOT_PROVIDER="${SHIVBOT_PROVIDER:-local}"
