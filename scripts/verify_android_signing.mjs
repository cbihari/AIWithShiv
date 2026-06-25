import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const keyPropertiesPath = path.join(root, 'android/key.properties');
const errors = [];

if (!fs.existsSync(keyPropertiesPath)) {
  errors.push('android/key.properties is missing.');
} else {
  const properties = parseProperties(fs.readFileSync(keyPropertiesPath, 'utf8'));
  for (const key of ['storePassword', 'keyPassword', 'keyAlias', 'storeFile']) {
    if (!properties[key]) {
      errors.push(`android/key.properties is missing ${key}.`);
    }
    if (properties[key] === 'change-me' || properties[key] === 'YOUR_STORE_PASSWORD' || properties[key] === 'YOUR_KEY_PASSWORD') {
      errors.push(`android/key.properties has placeholder value for ${key}.`);
    }
  }

  if (properties.storeFile) {
    const storeFilePath = path.resolve(path.dirname(keyPropertiesPath), properties.storeFile);
    if (!fs.existsSync(storeFilePath)) {
      errors.push(`Android upload keystore does not exist: ${storeFilePath}`);
    }
  }
}

if (errors.length > 0) {
  console.error('Android release signing is not ready:');
  for (const error of errors) console.error(`- ${error}`);
  console.error('\nCreate android/upload-keystore.jks and android/key.properties before building a Play Store AAB.');
  process.exit(1);
}

console.log('Android release signing is ready.');

function parseProperties(source) {
  const output = {};
  for (const rawLine of source.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#')) continue;
    const separator = line.indexOf('=');
    if (separator === -1) continue;
    const key = line.slice(0, separator).trim();
    const value = line.slice(separator + 1).trim();
    output[key] = value;
  }
  return output;
}
