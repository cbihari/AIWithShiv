import {initializeApp, cert} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import fs from "node:fs/promises";
import path from "node:path";

const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!serviceAccountPath) {
  console.log("Skipping Firestore seed: set GOOGLE_APPLICATION_CREDENTIALS to a Firebase service account JSON file.");
  process.exit(0);
}

try {
  await fs.access(serviceAccountPath);
} catch {
  console.log(`Skipping Firestore seed: service account file not found at ${serviceAccountPath}.`);
  process.exit(0);
}

initializeApp({credential: cert(JSON.parse(await fs.readFile(serviceAccountPath, "utf8")))});
const db = getFirestore();

const root = process.cwd();

async function seedCollection(collectionName, fileName) {
  const raw = await fs.readFile(path.join(root, "assets", "data", fileName), "utf8");
  const items = JSON.parse(raw);
  const batch = db.batch();
  for (const item of items) {
    const {id, ...data} = item;
    batch.set(db.collection(collectionName).doc(id), data, {merge: true});
  }
  await batch.commit();
  console.log(`Seeded ${items.length} ${collectionName}`);
}

await seedCollection("courses", "courses.json");
await seedCollection("lessons", "lessons.json");
await seedCollection("quizzes", "quizzes.json");
await seedCollection("rewards", "rewards.json");
await seedCollection("achievements", "achievements.json");
