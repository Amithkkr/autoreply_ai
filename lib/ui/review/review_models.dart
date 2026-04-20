enum ReviewStatus { pending, generated, approved }

enum ReplyTone { friendly, professional, casual }

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.authorName,
    required this.comment,
    required this.createdAt,
    this.rating,
    this.status = ReviewStatus.pending,
    this.selectedTone = ReplyTone.professional,
    this.aiDraft,
    this.finalReply,
    this.approvedAt,
  });

  final String id;
  final String authorName;
  final String comment;
  final DateTime createdAt;
  final int? rating;
  final ReviewStatus status;
  final ReplyTone selectedTone;
  final String? aiDraft;
  final String? finalReply;
  final DateTime? approvedAt;

  ReviewItem copyWith({
    String? id,
    String? authorName,
    String? comment,
    DateTime? createdAt,
    int? rating,
    ReviewStatus? status,
    ReplyTone? selectedTone,
    String? aiDraft,
    String? finalReply,
    DateTime? approvedAt,
  }) {
    return ReviewItem(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
      status: status ?? this.status,
      selectedTone: selectedTone ?? this.selectedTone,
      aiDraft: aiDraft ?? this.aiDraft,
      finalReply: finalReply ?? this.finalReply,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }
}
