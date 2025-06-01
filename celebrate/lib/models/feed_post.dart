class FeedPost {
  final int id;
  final String content;
  final String? imageUrl;
  final String authorName;
  final String? authorProfileImage;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final double rating;

  FeedPost({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.authorName,
    this.authorProfileImage,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.rating,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    return FeedPost(
      id: json['id'] as int,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      authorName: json['authorName'] as String,
      authorProfileImage: json['authorProfileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorProfileImage': authorProfileImage,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'rating': rating,
    };
  }
}
