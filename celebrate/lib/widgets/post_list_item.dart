import 'package:flutter/material.dart';
import '../models/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  const PostListItem({
    Key? key,
    required this.post,
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

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: post.authorProfileImage != null
                  ? NetworkImage(post.authorProfileImage!)
                  : null,
              child: post.authorProfileImage == null
                  ? Text(post.authorName[0])
                  : null,
            ),
            title: Text(post.authorName),
            subtitle: Text(_formatTime(post.createdAt!)),
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
                  post.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Text(post.content),
              ],
            ),
          ),
          if (post.mediaUrls.isNotEmpty)
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.mediaUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      post.mediaUrls[index],
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
                  icon: const Icon(Icons.favorite_border),
                  label: Text(post.likesCount.toString()),
                  onPressed: () {
                    // TODO: Implement like functionality
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.comment),
                  label: Text(post.commentsCount.toString()),
                  onPressed: () {
                    // TODO: Navigate to comments screen
                  },
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
