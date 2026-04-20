import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:autoreply_ai/router/app_router.dart';
import 'package:autoreply_ai/ui/review/review_mock_store.dart';
import 'package:autoreply_ai/ui/review/review_models.dart';

@RoutePage()
class ReviewPrototypePage extends StatefulWidget {
  const ReviewPrototypePage({super.key});

  @override
  State<ReviewPrototypePage> createState() => _ReviewPrototypePageState();
}

class _ReviewPrototypePageState extends State<ReviewPrototypePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _index == 0
              ? const _UserReviewScreen()
              : const _AdminDashboardScreen(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.rate_review_outlined),
            selectedIcon: Icon(Icons.rate_review),
            label: 'User',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_outlined),
            selectedIcon: Icon(Icons.dashboard_customize),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

class _UserReviewScreen extends StatefulWidget {
  const _UserReviewScreen();

  @override
  State<_UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<_UserReviewScreen> {
  final _nameController = TextEditingController(text: 'Guest User');
  final _reviewController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<List<ReviewItem>>(
          valueListenable: ReviewMockStore.instance.reviews,
          builder: (context, reviews, _) {
            return ListView(
              children: [
                const _TrustTopBar(),
                const SizedBox(height: 16),
                _HeroBanner(
                  title: 'Build trust with every reply',
                  subtitle:
                      'Collect customer reviews and let your team respond faster with AI assistance.',
                  actionLabel: 'How replies work',
                ),
                const SizedBox(height: 24),
                Text('Share Your Experience', style: textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  'Submit your feedback and see published replies from the business team.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFFFFFffe),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text('Rating', style: textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (index) {
                            final star = index + 1;
                            return IconButton(
                              onPressed: () => setState(() => _rating = star),
                              icon: Icon(
                                star <= _rating
                                    ? Icons.star
                                    : Icons.star_border_outlined,
                                color: star <= _rating
                                    ? Colors.amber
                                    : Theme.of(context).colorScheme.outline,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _reviewController,
                          minLines: 4,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            labelText: 'Write your review',
                            hintText:
                                'Tell us what went well or what we can improve.',
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitReview,
                            icon: const Icon(Icons.send),
                            label: const Text('Submit Review'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Your Recent Reviews', style: textTheme.titleLarge),
                const SizedBox(height: 8),
                ...reviews.asMap().entries.map((entry) {
                  final review = entry.value;
                  return _AnimatedListItem(
                    index: entry.key,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    review.authorName,
                                    style: textTheme.titleMedium,
                                  ),
                                ),
                                _StatusPill(status: review.status),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(review.comment, style: textTheme.bodyMedium),
                            if (review.finalReply != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  review.finalReply!,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submitReview() {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) return;
    ReviewMockStore.instance.submitReview(
      authorName: _nameController.text.trim().isEmpty
          ? 'Guest User'
          : _nameController.text.trim(),
      comment: comment,
      rating: _rating,
    );
    _reviewController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted successfully')),
    );
  }
}

class _AdminDashboardScreen extends StatefulWidget {
  const _AdminDashboardScreen();

  @override
  State<_AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<_AdminDashboardScreen> {
  String _query = '';
  ReviewStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<List<ReviewItem>>(
          valueListenable: ReviewMockStore.instance.reviews,
          builder: (context, reviews, _) {
            final filtered = reviews
                .where((review) {
                  final matchesSearch =
                      review.comment.toLowerCase().contains(
                        _query.toLowerCase(),
                      ) ||
                      review.authorName.toLowerCase().contains(
                        _query.toLowerCase(),
                      );
                  final matchesStatus =
                      _filter == null || review.status == _filter;
                  return matchesSearch && matchesStatus;
                })
                .toList(growable: false);
            final pendingCount = reviews
                .where((item) => item.status == ReviewStatus.pending)
                .length;
            final generatedCount = reviews
                .where((item) => item.status == ReviewStatus.generated)
                .length;
            final approvedCount = reviews
                .where((item) => item.status == ReviewStatus.approved)
                .length;

            return ListView(
              children: [
                const _TrustTopBar(),
                const SizedBox(height: 16),
                _HeroBanner(
                  title: 'Review management for your team',
                  subtitle:
                      'Monitor incoming reviews, generate quality responses, and approve replies quickly.',
                  actionLabel: 'Team workflow',
                ),
                const SizedBox(height: 24),
                Text('Review Inbox', style: textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  'Generate, edit and approve AI replies with one streamlined workflow.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _KpiCard(
                        label: 'Pending',
                        value: pendingCount.toString(),
                        color: const Color(0xFF605E56),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _KpiCard(
                        label: 'Generated',
                        value: generatedCount.toString(),
                        color: const Color(0xFF799DFA),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _KpiCard(
                        label: 'Approved',
                        value: approvedCount.toString(),
                        color: const Color(0xFF00BA72),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search by review text or user',
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3C57BC),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: _filter == null,
                      onSelected: (_) => setState(() => _filter = null),
                    ),
                    ChoiceChip(
                      label: const Text('Pending'),
                      selected: _filter == ReviewStatus.pending,
                      onSelected: (_) =>
                          setState(() => _filter = ReviewStatus.pending),
                    ),
                    ChoiceChip(
                      label: const Text('Generated'),
                      selected: _filter == ReviewStatus.generated,
                      onSelected: (_) =>
                          setState(() => _filter = ReviewStatus.generated),
                    ),
                    ChoiceChip(
                      label: const Text('Approved'),
                      selected: _filter == ReviewStatus.approved,
                      onSelected: (_) =>
                          setState(() => _filter = ReviewStatus.approved),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...filtered.asMap().entries.map(
                  (entry) => _AnimatedListItem(
                    index: entry.key,
                    child: _AdminReviewCard(review: entry.value),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AdminReviewCard extends StatelessWidget {
  const _AdminReviewCard({required this.review});

  final ReviewItem review;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(review.authorName, style: textTheme.titleMedium),
                ),
                _StatusPill(status: review.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat('dd MMM, hh:mm a').format(review.createdAt),
              style: textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            Text(review.comment, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.router.push(
                        ReviewDetailRoute(reviewId: review.id),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: review.status == ReviewStatus.pending
                        ? () {
                            ReviewMockStore.instance.generateReply(review.id);
                          }
                        : null,
                    child: const Text('Generate Reply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final ReviewStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;

    switch (status) {
      case ReviewStatus.pending:
        label = 'Pending';
        color = const Color(0xFF605E56);
      case ReviewStatus.generated:
        label = 'Generated';
        color = const Color(0xFF799DFA);
      case ReviewStatus.approved:
        label = 'Approved';
        color = const Color(0xFF00BA72);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

class _AnimatedListItem extends StatelessWidget {
  const _AnimatedListItem({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final effectiveIndex = index > 8 ? 8 : index;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (effectiveIndex * 40)),
      curve: Curves.easeOutCubic,
      builder: (context, value, widgetChild) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 10),
          child: Opacity(opacity: value, child: widgetChild),
        );
      },
      child: child,
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withValues(alpha: 0.09),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustTopBar extends StatelessWidget {
  const _TrustTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2F29),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF00BA72),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Text(
            'AutoReply AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Dashboard'),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  final String title;
  final String subtitle;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F0EC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDCD6D1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D2F29),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF605E56)),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                width: 34,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BA72),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Container(
                width: 20,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF799DFA),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3C57BC),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(actionLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
