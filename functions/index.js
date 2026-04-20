const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

const REVIEWS_COLLECTION = "reviews";

function normalizeString(value, fallback = "") {
  if (typeof value !== "string") return fallback;
  return value.trim();
}

function normalizeRating(value) {
  if (typeof value !== "number") return null;
  if (!Number.isFinite(value)) return null;
  const rounded = Math.round(value);
  if (rounded < 1 || rounded > 5) return null;
  return rounded;
}

exports.listReviews = onCall(async () => {
  const snapshot = await db
      .collection(REVIEWS_COLLECTION)
      .orderBy("createdAt", "desc")
      .limit(200)
      .get();

  return snapshot.docs.map((doc) => {
    const data = doc.data();
    return {
      id: doc.id,
      authorName: data.authorName || "Guest User",
      comment: data.comment || "",
      createdAt: data.createdAt || new Date().toISOString(),
      rating: data.rating ?? null,
      status: data.status || "pending",
      selectedTone: data.selectedTone || "professional",
      aiDraft: data.aiDraft || null,
      finalReply: data.finalReply || null,
      approvedAt: data.approvedAt || null,
    };
  });
});

exports.addReview = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated.");
  }

  const data = request.data || {};
  const authorName = normalizeString(data.authorName, "Guest User");
  const comment = normalizeString(data.comment);
  const rating = normalizeRating(data.rating);

  if (!comment) {
    throw new HttpsError(
        "invalid-argument",
        "comment is required and cannot be empty.",
    );
  }

  const reviewRef = db.collection(REVIEWS_COLLECTION).doc();
  const now = new Date().toISOString();
  const review = {
    id: reviewRef.id,
    authorName,
    comment,
    rating,
    status: "pending",
    selectedTone: "professional",
    aiDraft: null,
    finalReply: null,
    approvedAt: null,
    createdAt: now,
    createdByUid: request.auth.uid,
    updatedAt: now,
    serverTimestamp: FieldValue.serverTimestamp(),
  };

  await reviewRef.set(review);
  return review;
});
