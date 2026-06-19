import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";

const projectId = process.env.FIREBASE_PROJECT_ID ?? process.argv[2];
if (!projectId) {
  console.error("Usage: FIREBASE_PROJECT_ID=<project> node scripts/seed_firestore_rest.mjs");
  process.exit(1);
}

async function getAccessToken() {
  if (process.env.FIREBASE_ACCESS_TOKEN) return process.env.FIREBASE_ACCESS_TOKEN;
  const configPath = path.join(os.homedir(), ".config", "configstore", "firebase-tools.json");
  const config = JSON.parse(await fs.readFile(configPath, "utf8"));
  const token = config.tokens?.access_token;
  if (!token) {
    throw new Error("No Firebase access token found. Run firebase login first.");
  }
  return token;
}

function firestoreValue(value) {
  if (value === null || value === undefined) return {nullValue: null};
  if (typeof value === "string") return {stringValue: value};
  if (typeof value === "boolean") return {booleanValue: value};
  if (typeof value === "number") {
    return Number.isInteger(value) ? {integerValue: String(value)} : {doubleValue: value};
  }
  if (Array.isArray(value)) {
    return {arrayValue: {values: value.map(firestoreValue)}};
  }
  if (typeof value === "object") {
    return {
      mapValue: {
        fields: Object.fromEntries(
          Object.entries(value).map(([key, nested]) => [key, firestoreValue(nested)]),
        ),
      },
    };
  }
  throw new Error(`Unsupported Firestore value: ${value}`);
}

async function seedCollection(token, collectionName, fileName) {
  const raw = await fs.readFile(path.join(process.cwd(), "assets", "data", fileName), "utf8");
  const items = JSON.parse(raw);
  const writes = items.map(({id, ...data}) => ({
    update: {
      name: `projects/${projectId}/databases/(default)/documents/${collectionName}/${id}`,
      fields: Object.fromEntries(
        Object.entries(data).map(([key, value]) => [key, firestoreValue(value)]),
      ),
    },
  }));

  const response = await fetch(
    `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents:commit`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({writes}),
    },
  );
  if (!response.ok) {
    throw new Error(`${collectionName} seed failed: ${response.status} ${await response.text()}`);
  }
  console.log(`Seeded ${items.length} ${collectionName}`);
}

const token = await getAccessToken();
await seedCollection(token, "courses", "courses.json");
await seedCollection(token, "lessons", "lessons.json");
await seedCollection(token, "quizzes", "quizzes.json");
await seedCollection(token, "rewards", "rewards.json");
await seedCollection(token, "achievements", "achievements.json");
