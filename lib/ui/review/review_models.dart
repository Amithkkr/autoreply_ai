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

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: (json['id'] as String?) ?? '',
      authorName: (json['authorName'] as String?) ?? 'Guest User',
      comment: (json['comment'] as String?) ?? '',
      createdAt:
          DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.now(),
      rating: (json['rating'] as num?)?.toInt(),
      status: _reviewStatusFromString((json['status'] as String?) ?? 'pending'),
      selectedTone: _replyToneFromString(
        (json['selectedTone'] as String?) ?? 'professional',
      ),
      aiDraft: json['aiDraft'] as String?,
      finalReply: json['finalReply'] as String?,
      approvedAt: DateTime.tryParse((json['approvedAt'] as String?) ?? ''),
    );
  }

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'authorName': authorName,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'rating': rating,
      'status': status.name,
      'selectedTone': selectedTone.name,
      'aiDraft': aiDraft,
      'finalReply': finalReply,
      'approvedAt': approvedAt?.toIso8601String(),
    };
  }
}

ReviewStatus _reviewStatusFromString(String value) {
  return ReviewStatus.values.firstWhere(
    (status) => status.name == value,
    orElse: () => ReviewStatus.pending,
  );
}

ReplyTone _replyToneFromString(String value) {
  return ReplyTone.values.firstWhere(
    (tone) => tone.name == value,
    orElse: () => ReplyTone.professional,
  );
}
