import 'package:flutter/material.dart';
import '../models/rating.dart';
import '../services/rating_service.dart';

class RatingsListWidget extends StatefulWidget {
  final String targetId;
  final String targetType;

  const RatingsListWidget({
    Key? key,
    required this.targetId,
    required this.targetType,
  }) : super(key: key);

  @override
  State<RatingsListWidget> createState() => _RatingsListWidgetState();
}

class _RatingsListWidgetState extends State<RatingsListWidget> {
  final RatingService _ratingService = RatingService();
  final ScrollController _scrollController = ScrollController();
  final List<Rating> _ratings = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadRatings();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadRatings();
    }
  }

  Future<void> _loadRatings() async {
    if (!_hasMore || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ratings = await _ratingService.getRatings(
        targetId: widget.targetId,
        targetType: widget.targetType,
        page: _currentPage,
      );

      setState(() {
        _ratings.addAll(ratings);
        _isLoading = false;
        _hasMore = ratings.isNotEmpty;
        if (_hasMore) _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading ratings: $e')),
        );
      }
    }
  }

  Widget _buildRatingItem(Rating rating) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.value ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(rating.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (rating.comment != null) ...[
              const SizedBox(height: 8),
              Text(
                rating.comment!,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text(
                'Ratings & Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_ratings.isNotEmpty)
                Text(
                  'Average: ${_calculateAverage().toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _ratings.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _ratings.length) {
                return _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox();
              }
              return _buildRatingItem(_ratings[index]);
            },
          ),
        ),
      ],
    );
  }

  double _calculateAverage() {
    if (_ratings.isEmpty) return 0;
    final sum =
        _ratings.fold<int>(0, (previous, current) => previous + current.value);
    return sum / _ratings.length;
  }
}
