#!/usr/bin/env bash
set -euo pipefail

flutter clean
flutter pub get
flutter build appbundle --release \
  --dart-define=APP_ENV="${APP_ENV:-prod}" \
  --dart-define=OPENAI_API_BASE_URL="${OPENAI_API_BASE_URL:-https://api.openai.com/v1}" \
  --dart-define=GEMINI_API_BASE_URL="${GEMINI_API_BASE_URL:-https://generativelanguage.googleapis.com/v1beta}" \
  --dart-define=BEDROCK_PROXY_BASE_URL="${BEDROCK_PROXY_BASE_URL:-https://example-bedrock-proxy.cloudfunctions.net}"
