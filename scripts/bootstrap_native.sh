#!/usr/bin/env bash
set -euo pipefail

flutter create --platforms=android,ios .
./scripts/configure_native_ids.sh
flutter pub get
flutter doctor
