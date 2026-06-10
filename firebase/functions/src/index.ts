import * as admin from "firebase-admin";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {z} from "zod";

admin.initializeApp();

const shivBotRequest = z.object({
  message: z.string().min(1).max(1000),
  ageGroup: z.string().min(1),
});

const blockedTerms = [
  "weapon",
  "bomb",
  "kill",
  "self harm",
  "suicide",
  "adult content",
  "hate",
  "ignore previous instructions",
  "system prompt",
  "jailbreak",
];

async function assertRateLimit(uid: string): Promise<void> {
  const ref = admin.firestore().collection("rateLimits").doc(`shivbot_${uid}`);
  const now = admin.firestore.Timestamp.now();
  await admin.firestore().runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    const data = snapshot.data();
    const windowStartedAt = data?.windowStartedAt as admin.firestore.Timestamp | undefined;
    const count = Number(data?.count ?? 0);
    const sameMinute =
      windowStartedAt !== undefined &&
      now.toMillis() - windowStartedAt.toMillis() < 60 * 1000;

    if (sameMinute && count >= 10) {
      throw new HttpsError("resource-exhausted", "ShivBot rate limit reached.");
    }

    transaction.set(
      ref,
      {
        count: sameMinute ? count + 1 : 1,
        windowStartedAt: sameMinute ? windowStartedAt : now,
        updatedAt: now,
      },
      {merge: true},
    );
  });
}

export const askShivBot = onCall({enforceAppCheck: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Login is required.");
  }

  const parsed = shivBotRequest.safeParse(request.data);
  if (!parsed.success) {
    throw new HttpsError("invalid-argument", "Invalid ShivBot request.");
  }

  await assertRateLimit(request.auth.uid);

  const input = parsed.data;
  const normalized = input.message.toLowerCase();
  if (blockedTerms.some((term) => normalized.includes(term))) {
    throw new HttpsError("failed-precondition", "Unsafe learning request blocked.");
  }

  return {
    reply:
      `ShivBot says: for ${input.ageGroup}, AI is like a smart helper that ` +
      "spots patterns and learns from examples. Try asking for a cartoon, game, or sports example.",
  };
});

export const sendWeeklyParentReports = onSchedule("every monday 09:00", async () => {
  const snapshot = await admin.firestore().collection("users")
    .where("parentEmail", "!=", null)
    .limit(500)
    .get();
  await admin.firestore().collection("jobs").add({
    type: "weekly_parent_reports",
    userCount: snapshot.size,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });
});
