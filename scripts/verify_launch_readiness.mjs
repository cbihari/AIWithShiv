import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const errors = [];
const warnings = [];
const info = [];

function read(file) {
  return fs.readFileSync(path.join(root, file), 'utf8');
}

function exists(file) {
  return fs.existsSync(path.join(root, file));
}

function check(condition, message) {
  if (!condition) errors.push(message);
}

function warn(condition, message) {
  if (!condition) warnings.push(message);
}

function section(title) {
  info.push(`\n## ${title}`);
}

section('Content');
const content = spawnSync(process.execPath, ['scripts/validate_content.mjs'], {
  cwd: root,
  encoding: 'utf8',
});
check(content.status === 0, 'Content validation failed.');
if (content.stdout.trim()) info.push(content.stdout.trim());
if (content.stderr.trim()) warnings.push(content.stderr.trim());

section('App Identity');
const androidGradle = read('android/app/build.gradle.kts');
const iosProject = read('ios/Runner.xcodeproj/project.pbxproj');
const pubspec = read('pubspec.yaml');
check(
  androidGradle.includes('applicationId = "com.aiwithshiv.app"'),
  'Android applicationId must be com.aiwithshiv.app.',
);
check(
  iosProject.includes('PRODUCT_BUNDLE_IDENTIFIER = com.aiwithshiv.app;'),
  'iOS PRODUCT_BUNDLE_IDENTIFIER must be com.aiwithshiv.app.',
);
check(
  pubspec.includes('children aged 5-10'),
  'pubspec description should match v1 age 5-10 positioning.',
);
info.push('Android package: com.aiwithshiv.app');
info.push('iOS bundle id: com.aiwithshiv.app');

section('Signing');
check(
  exists('android/key.properties.example'),
  'android/key.properties.example is missing.',
);
warn(
  exists('android/key.properties'),
  'android/key.properties is missing. Create it locally before Play upload.',
);
warn(
  exists('android/upload-keystore.jks'),
  'android/upload-keystore.jks is missing. Create it locally before Play upload.',
);
info.push(
  exists('android/key.properties')
    ? 'Android signing config: local key.properties found.'
    : 'Android signing config: example only; Play upload key still needed.',
);

section('Launch Configuration');
const env = read('lib/config/env.dart');
check(
  env.includes("'ENABLE_ADS'") && env.includes('defaultValue: false'),
  'ENABLE_ADS must default to false.',
);
check(
  env.includes("'AUTH_ENABLED'") && env.includes('defaultValue: false'),
  'AUTH_ENABLED must default to false.',
);
check(
  env.includes("'SHIVBOT_PROVIDER'") && env.includes("defaultValue: 'local'"),
  'SHIVBOT_PROVIDER must default to local.',
);

section('Sensitive References');
const sourceFiles = [
  ...walk('lib'),
  ...walk('android/app/src'),
  ...walk('ios/Runner'),
  'pubspec.yaml',
].filter((file) => /\.(dart|xml|plist|yaml|json|gradle|kts)$/.test(file));
const combinedSource = sourceFiles.map((file) => read(file)).join('\n');
check(
  !/sk-[A-Za-z0-9_-]{20,}/.test(combinedSource),
  'Possible hardcoded OpenAI/API secret key found in app source.',
);
check(
  !/(cloud_firestore|firebase_auth|firebase_core|firebase_)/.test(
    combinedSource,
  ),
  'Firebase package/reference found in app source; core flow should be local-first.',
);
warn(
  !combinedSource.includes('ca-app-pub-3940256099942544'),
  'Google test AdMob ids are present. Keep ENABLE_ADS=false or replace before ads-enabled production.',
);

section('Store Docs');
for (const file of [
  'docs/aiwithshiv-roadmap/FINAL_LAUNCH_READINESS_REPORT.md',
  'docs/aiwithshiv-roadmap/PHASE_7_ANDROID_LAUNCH_RUNBOOK.md',
  'docs/aiwithshiv-roadmap/PHASE_8_IOS_LAUNCH_RUNBOOK.md',
  'docs/PRIVACY_POLICY_DRAFT.md',
  'docs/TERMS_OF_SERVICE_DRAFT.md',
]) {
  check(exists(file), `${file} is missing.`);
}

section('Artifacts');
warn(
  exists('build/app/outputs/bundle/release/app-release.aab'),
  'Android AAB artifact not found. Run flutter build appbundle before upload.',
);
warn(
  exists('build/app/outputs/flutter-apk/app-release.apk'),
  'Android APK artifact not found. Build it before physical-device QA.',
);
warn(
  exists('build/ios/iphoneos/Runner.app'),
  'iOS no-codesign build artifact not found. Run iOS build before archive work.',
);

console.log(info.join('\n'));
printList('Warnings', warnings);
printList('Errors', errors);

if (errors.length > 0) {
  process.exit(1);
}

console.log('\nLaunch readiness check passed with warnings noted above.');

function printList(title, items) {
  if (items.length === 0) {
    console.log(`\n${title}: none`);
    return;
  }
  console.log(`\n${title}:`);
  for (const item of items) console.log(`- ${item}`);
}

function walk(dir) {
  const fullDir = path.join(root, dir);
  if (!fs.existsSync(fullDir)) return [];
  const output = [];
  for (const entry of fs.readdirSync(fullDir, { withFileTypes: true })) {
    if (entry.name === 'Pods' || entry.name.startsWith('.')) continue;
    const relative = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      output.push(...walk(relative));
    } else {
      output.push(relative);
    }
  }
  return output;
}
