import 'package:flutter/foundation.dart';

import 'review_models.dart';

class ReviewMockStore {
  ReviewMockStore._();

  static final ReviewMockStore instance = ReviewMockStore._();

  final ValueNotifier<List<ReviewItem>>
  reviews = ValueNotifier<List<ReviewItem>>([
    ReviewItem(
      id: 'rvw-1001',
      authorName: 'Aarav',
      comment:
          'Loved the overall experience. Delivery was quick and support was very polite.',
      rating: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      status: ReviewStatus.pending,
    ),
    ReviewItem(
      id: 'rvw-1002',
      authorName: 'Mira',
      comment:
          'The quality is good, but packaging can be improved. It arrived slightly damaged.',
      rating: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: ReviewStatus.generated,
      selectedTone: ReplyTone.friendly,
      aiDraft:
          'Thanks for your honest feedback, Mira. We are glad you liked the quality and we are sorry about the packaging issue. We are improving our packaging process right away.',
    ),
    ReviewItem(
      id: 'rvw-1003',
      authorName: 'Chris',
      comment: 'Great service. Team resolved my issue within minutes.',
      rating: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ReviewStatus.approved,
      selectedTone: ReplyTone.professional,
      aiDraft:
          'Thank you for sharing your experience. We are happy our team could resolve your issue quickly.',
      finalReply:
          'Thank you for sharing your experience, Chris. We are happy our team could resolve your issue quickly. Your feedback means a lot to us.',
      approvedAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
  ]);

  List<ReviewItem> get all => reviews.value;

  ReviewItem? byId(String id) {
    for (final review in reviews.value) {
      if (review.id == id) return review;
    }
    return null;
  }

  void submitReview({
    required String authorName,
    required String comment,
    int? rating,
  }) {
    final now = DateTime.now();
    final review = ReviewItem(
      id: 'rvw-${now.microsecondsSinceEpoch}',
      authorName: authorName,
      comment: comment,
      rating: rating,
      createdAt: now,
    );
    reviews.value = [review, ...reviews.value];
  }

  void updateTone(String id, ReplyTone tone) {
    _update(id, (item) => item.copyWith(selectedTone: tone));
  }

  void generateReply(String id) {
    _update(
      id,
      (item) => item.copyWith(
        status: ReviewStatus.generated,
        aiDraft: _buildReply(item.comment, item.selectedTone),
      ),
    );
  }

  void updateDraft(String id, String draft) {
    _update(id, (item) => item.copyWith(aiDraft: draft));
  }

  void approveReply(String id) {
    _update(
      id,
      (item) => item.copyWith(
        status: ReviewStatus.approved,
        finalReply: item.aiDraft?.trim(),
        approvedAt: DateTime.now(),
      ),
    );
  }

  void _update(String id, ReviewItem Function(ReviewItem item) mapper) {
    reviews.value = reviews.value
        .map((item) => item.id == id ? mapper(item) : item)
        .toList(growable: false);
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
