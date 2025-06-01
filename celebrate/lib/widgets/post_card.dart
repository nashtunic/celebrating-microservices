import 'package:flutter/material.dart';
import '../models/feed_post.dart';
import '../services/rating_service.dart';

class PostCard extends StatefulWidget {
  final FeedPost post;
  final Function? onRatingChanged;

  const PostCard({
    Key? key,
    required this.post,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final RatingService _ratingService = RatingService();
  bool _isRating = false;
  double? _userRating;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  Future<void> _loadUserRating() async {
    try {
      final rating =
          await _ratingService.getUserPostRating(widget.post.id.toString());
      if (rating != null) {
        setState(() {
          _userRating = rating['ratingValue'].toDouble();
        });
      }
    } catch (e) {
      print('Error loading user rating: $e');
    }
  }

  Future<void> _handleRating(int rating) async {
    if (_isRating) return;

    setState(() {
      _isRating = true;
    });

    try {
      await _ratingService.ratePost(widget.post.id.toString(), rating);
      setState(() {
        _userRating = rating.toDouble();
      });
      widget.onRatingChanged?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to rate post: $e')),
      );
    } finally {
      setState(() {
        _isRating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: widget.post.authorProfileImage != null
                  ? NetworkImage(widget.post.authorProfileImage!)
                  : null,
              child: widget.post.authorProfileImage == null
                  ? Text(widget.post.authorName[0])
                  : null,
            ),
            title: Text(widget.post.authorName),
            subtitle: Text(widget.post.createdAt.toString()),
          ),
          if (widget.post.imageUrl != null)
            Image.network(
              widget.post.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.post.content),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: (index + 1) <= (_userRating ?? 0)
                            ? Colors.orange
                            : Colors.grey,
                      ),
                      onPressed:
                          _isRating ? null : () => _handleRating(index + 1),
                    );
                  }),
                ),
                Text('Average: ${widget.post.rating.toStringAsFixed(1)}'),
              ],
            ),
          ),
          ButtonBar(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.thumb_up),
                label: Text('${widget.post.likes}'),
                onPressed: () {
                  // Handle like
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.comment),
                label: Text('${widget.post.comments}'),
                onPressed: () {
                  // Handle comment
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
