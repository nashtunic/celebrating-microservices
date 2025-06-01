import 'package:flutter/material.dart';
import '../models/news_feed_item.dart';
import '../services/news_feed_service.dart';

class NewsFeedItemWidget extends StatelessWidget {
  final NewsFeedItem item;
  final Function()? onRefresh;
  final Function()? onRatingTap;

  const NewsFeedItemWidget({
    Key? key,
    required this.item,
    this.onRefresh,
    this.onRatingTap,
  }) : super(key: key);

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (time.year == now.year) {
      return '${time.day}/${time.month}';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  Widget _buildTypeIndicator(BuildContext context) {
    IconData icon;
    Color color;

    switch (item.type.toLowerCase()) {
      case 'celebration':
        icon = Icons.celebration;
        color = Colors.purple;
        break;
      case 'achievement':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      case 'announcement':
        icon = Icons.campaign;
        color = Colors.blue;
        break;
      default:
        icon = Icons.star;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            item.type,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsFeedService = NewsFeedService();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: item.authorProfileImage != null
                  ? NetworkImage(item.authorProfileImage!)
                  : null,
              child: item.authorProfileImage == null
                  ? Text(item.authorName[0])
                  : null,
            ),
            title: Row(
              children: [
                Expanded(child: Text(item.authorName)),
                _buildTypeIndicator(context),
              ],
            ),
            subtitle: Text(_formatTime(item.createdAt)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Text(item.content),
              ],
            ),
          ),
          if (item.mediaUrls.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.mediaUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      item.mediaUrls[index],
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  icon: Icon(
                    item.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: item.isLiked ? Colors.red : null,
                  ),
                  label: Text(item.likesCount.toString()),
                  onPressed: () async {
                    try {
                      await newsFeedService.toggleLike(item.id);
                      onRefresh?.call();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.comment),
                  label: Text(item.commentsCount.toString()),
                  onPressed: () {
                    // TODO: Navigate to comments screen
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.star),
                  label: const Text('Rate'),
                  onPressed: onRatingTap,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
