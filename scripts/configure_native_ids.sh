#!/usr/bin/env bash
set -euo pipefail

ANDROID_PACKAGE="${ANDROID_PACKAGE:-com.aiwithshiv.app}"
IOS_BUNDLE_ID="${IOS_BUNDLE_ID:-com.aiwithshiv.app}"

if [[ -f android/app/build.gradle ]]; then
  perl -0pi -e "s/applicationId\\s+\"[^\"]+\"/applicationId \"$ANDROID_PACKAGE\"/g" android/app/build.gradle
  perl -0pi -e "s/namespace\\s+\"[^\"]+\"/namespace \"$ANDROID_PACKAGE\"/g" android/app/build.gradle
fi

if [[ -f android/app/build.gradle.kts ]]; then
  perl -0pi -e "s/applicationId\\s*=\\s*\"[^\"]+\"/applicationId = \"$ANDROID_PACKAGE\"/g" android/app/build.gradle.kts
  perl -0pi -e "s/namespace\\s*=\\s*\"[^\"]+\"/namespace = \"$ANDROID_PACKAGE\"/g" android/app/build.gradle.kts
fi

if [[ -f ios/Runner.xcodeproj/project.pbxproj ]]; then
  perl -0pi -e "s/PRODUCT_BUNDLE_IDENTIFIER = [^;]+;/PRODUCT_BUNDLE_IDENTIFIER = $IOS_BUNDLE_ID;/g" ios/Runner.xcodeproj/project.pbxproj
fi

echo "Configured Android package: $ANDROID_PACKAGE"
echo "Configured iOS bundle ID: $IOS_BUNDLE_ID"
