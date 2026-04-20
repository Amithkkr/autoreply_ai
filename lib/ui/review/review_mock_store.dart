import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'review_models.dart';

class ReviewMockStore {
  ReviewMockStore._();

  static final ReviewMockStore instance = ReviewMockStore._();

  final ValueNotifier<List<ReviewItem>> reviews = ValueNotifier<List<ReviewItem>>(
    const [],
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  bool _isBootstrapped = false;
  bool _isBootstrapping = false;

  List<ReviewItem> get all => reviews.value;

  Future<void> bootstrap() async {
    if (_isBootstrapped || _isBootstrapping) return;
    _isBootstrapping = true;
    try {
      await _ensureAnonymousAuth();
      await refreshReviews();
      _isBootstrapped = true;
    } catch (error) {
      debugPrint('Review store bootstrap failed: $error');
    } finally {
      _isBootstrapping = false;
    }
  }

  Future<void> refreshReviews() async {
    try {
      final callable = _functions.httpsCallable('listReviews');
      final result = await callable.call();
      final rawReviews = (result.data as List<dynamic>? ?? const <dynamic>[]);
      final parsed = rawReviews
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (item) => ReviewItem.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);
      reviews.value = parsed;
    } catch (error) {
      debugPrint('Failed loading reviews from Firebase Functions: $error');
    }
  }

  ReviewItem? byId(String id) {
    for (final review in reviews.value) {
      if (review.id == id) return review;
    }
    return null;
  }

  Future<void> submitReview({
    required String authorName,
    required String comment,
    int? rating,
  }) async {
    await _ensureAnonymousAuth();
    final callable = _functions.httpsCallable('addReview');
    final result = await callable.call(<String, dynamic>{
      'authorName': authorName,
      'comment': comment,
      'rating': rating,
    });

    final reviewData = result.data;
    if (reviewData is Map<dynamic, dynamic>) {
      final created = ReviewItem.fromJson(
        Map<String, dynamic>.from(reviewData),
      );
      reviews.value = [created, ...reviews.value];
    } else {
      await refreshReviews();
    }
  }

  Future<void> updateTone(String id, ReplyTone tone) async {
    await _update(
      id,
      (item) => item.copyWith(selectedTone: tone),
      {'selectedTone': tone.name},
    );
  }

  Future<void> generateReply(String id) async {
    final review = byId(id);
    if (review == null) return;
    final draft = _buildReply(review.comment, review.selectedTone);
    await setGeneratedReply(id, draft);
  }

  Future<void> updateDraft(String id, String draft) async {
    await _update(id, (item) => item.copyWith(aiDraft: draft), {'aiDraft': draft});
  }

  Future<void> setGeneratedReply(String id, String draft) async {
    await _update(id, (item) {
      return item.copyWith(status: ReviewStatus.generated, aiDraft: draft);
    }, <String, dynamic>{'status': ReviewStatus.generated.name, 'aiDraft': draft});
  }

  Future<void> approveReply(String id) async {
    final now = DateTime.now();
    await _update(id, (item) {
      return item.copyWith(
        status: ReviewStatus.approved,
        finalReply: item.aiDraft?.trim(),
        approvedAt: now,
      );
    }, <String, dynamic>{
      'status': ReviewStatus.approved.name,
      'finalReply': byId(id)?.aiDraft?.trim(),
      'approvedAt': now.toIso8601String(),
    });
  }

  Future<void> _update(
    String id,
    ReviewItem Function(ReviewItem item) mapper,
    Map<String, dynamic> patch,
  ) async {
    final next = reviews.value
        .map((item) => item.id == id ? mapper(item) : item)
        .toList(growable: false);
    reviews.value = next;
    await _firestore.collection('reviews').doc(id).set(
          <String, dynamic>{
            ...patch,
            'updatedAt': DateTime.now().toIso8601String(),
          },
          SetOptions(merge: true),
        );
  }

  Future<void> _ensureAnonymousAuth() async {
    if (_auth.currentUser != null) return;
    await _auth.signInAnonymously();
  }

  String _buildReply(String review, ReplyTone tone) {
    final safeReview = review.toLowerCase();
    final mentionsIssue =
        safeReview.contains('issue') ||
        safeReview.contains('bad') ||
        safeReview.contains('damaged') ||
        safeReview.contains('late');

    switch (tone) {
      case ReplyTone.friendly:
        if (mentionsIssue) {
          return 'Thanks for sharing this with us. We are really sorry the experience was not smooth this time. We are already looking into it and will do better on your next visit.';
        }
        return 'Thank you so much for the lovely review. We are happy you had a great experience and we cannot wait to serve you again.';
      case ReplyTone.professional:
        if (mentionsIssue) {
          return 'Thank you for your feedback. We apologize for the inconvenience and appreciate you bringing this to our attention. Our team is taking corrective action to prevent this issue in the future.';
        }
        return 'Thank you for your positive review. We appreciate your trust and are pleased to know our service met your expectations.';
      case ReplyTone.casual:
        if (mentionsIssue) {
          return 'Thanks for the honest feedback. Sorry this one was not perfect. We are fixing it and will make sure your next experience is much better.';
        }
        return 'Thanks a lot for the shoutout. Glad you enjoyed it. See you again soon.';
    }
  }
}
