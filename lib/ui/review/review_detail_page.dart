import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:autoreply_ai/ui/review/review_mock_store.dart';
import 'package:autoreply_ai/ui/review/review_models.dart';

@RoutePage()
class ReviewDetailPage extends StatefulWidget {
  const ReviewDetailPage({super.key, required this.reviewId});

  final String reviewId;

  @override
  State<ReviewDetailPage> createState() => _ReviewDetailPageState();
}

class _ReviewDetailPageState extends State<ReviewDetailPage> {
  final _replyController = TextEditingController();
  bool _isGenerating = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ReviewItem>>(
      valueListenable: ReviewMockStore.instance.reviews,
      builder: (context, _, __) {
        final review = ReviewMockStore.instance.byId(widget.reviewId);
        if (review == null) {
          return const Scaffold(body: Center(child: Text('Review not found')));
        }

        if (_replyController.text != (review.aiDraft ?? '')) {
          _replyController.text = review.aiDraft ?? '';
        }

        final textTheme = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(title: const Text('AI Reply Workspace')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_isGenerating)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              Card(
                color: const Color(0xFFFFFffe),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.authorName, style: textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('dd MMM, hh:mm a').format(review.createdAt),
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(review.comment, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('Select Tone', style: textTheme.titleMedium),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _ToneBadge(
                      key: ValueKey(review.selectedTone),
                      tone: review.selectedTone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0EC),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFDCD6D1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SegmentedButton<ReplyTone>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(BorderSide.none),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    segments: const [
                      ButtonSegment(
                        value: ReplyTone.friendly,
                        label: Text('Friendly'),
                      ),
                      ButtonSegment(
                        value: ReplyTone.professional,
                        label: Text('Professional'),
                      ),
                      ButtonSegment(
                        value: ReplyTone.casual,
                        label: Text('Casual'),
                      ),
                    ],
                    selected: {review.selectedTone},
                    onSelectionChanged: (selected) {
                      ReviewMockStore.instance.updateTone(
                        review.id,
                        selected.first,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('AI Suggested Reply', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  _isGenerating
                      ? 'Generating a context-aware response...'
                      : 'Generate, fine-tune and approve your final business response.',
                  key: ValueKey(_isGenerating),
                  style: textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _replyController,
                minLines: 8,
                maxLines: 10,
                onChanged: (value) {
                  ReviewMockStore.instance.updateDraft(review.id, value);
                },
                decoration: InputDecoration(
                  hintText: _isGenerating
                      ? 'Generating response...'
                      : 'Press Generate Reply to create a suggestion.',
                  fillColor: const Color(0xFFFFFffe),
                ),
              ),
              if (review.status == ReviewStatus.approved &&
                  review.approvedAt != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF00BA72).withValues(alpha: 0.12),
                  ),
                  child: Text(
                    'Approved on ${DateFormat('dd MMM, hh:mm a').format(review.approvedAt!)}',
                    style: textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF00BA72),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0EC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFDCD6D1)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isGenerating
                            ? null
                            : () => _generateReply(review.id),
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(
                          review.status == ReviewStatus.pending
                              ? 'Generate Reply'
                              : 'Regenerate',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: (review.aiDraft ?? '').trim().isEmpty
                            ? null
                            : () => _approveReply(review.id),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Approve & Post'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _generateReply(String id) async {
    setState(() => _isGenerating = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    ReviewMockStore.instance.generateReply(id);
    if (mounted) setState(() => _isGenerating = false);
  }

  Future<void> _approveReply(String id) async {
    final shouldApprove = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post this reply publicly?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'You can still regenerate or update the reply later if needed.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Approve & Post'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );

    if (shouldApprove ?? false) {
      ReviewMockStore.instance.approveReply(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reply approved and posted')),
        );
      }
    }
  }
}

class _ToneBadge extends StatelessWidget {
  const _ToneBadge({super.key, required this.tone});

  final ReplyTone tone;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;

    switch (tone) {
      case ReplyTone.friendly:
        label = 'Friendly';
        color = const Color(0xFF00BA72);
      case ReplyTone.professional:
        label = 'Professional';
        color = const Color(0xFF3C57BC);
      case ReplyTone.casual:
        label = 'Casual';
        color = const Color(0xFF799DFA);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
