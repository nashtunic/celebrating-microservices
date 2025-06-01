class NewsFeedItem {
  final String id;
  final String title;
  final String content;
  final String type;
  final String authorId;
  final String authorName;
  final String authorType;
  final String? authorProfileImage;
  final List<String> mediaUrls;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  NewsFeedItem({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.authorId,
    required this.authorName,
    required this.authorType,
    this.authorProfileImage,
    required this.mediaUrls,
    this.metadata,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
  });

  factory NewsFeedItem.fromJson(Map<String, dynamic> json) {
    return NewsFeedItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorType: json['authorType'] as String,
      authorProfileImage: json['authorProfileImage'] as String?,
      mediaUrls: List<String>.from(json['mediaUrls'] as List),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int,
      commentsCount: json['commentsCount'] as int,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'authorId': authorId,
      'authorName': authorName,
      'authorType': authorType,
      'authorProfileImage': authorProfileImage,
      'mediaUrls': mediaUrls,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
    };
  }
}
