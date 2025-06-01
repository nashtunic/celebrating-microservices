class Post {
  final int? id;
  final String title;
  final String content;
  final String celebrationType;
  final List<String> mediaUrls;
  final String authorName;
  final String? authorProfileImage;
  final DateTime? createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isPrivate;

  Post({
    this.id,
    required this.title,
    required this.content,
    required this.celebrationType,
    this.mediaUrls = const [],
    required this.authorName,
    this.authorProfileImage,
    this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isPrivate = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      celebrationType: json['celebrationType'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      authorName: json['authorName'],
      authorProfileImage: json['authorProfileImage'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      isPrivate: json['isPrivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'celebrationType': celebrationType,
      'mediaUrls': mediaUrls,
      'authorName': authorName,
      if (authorProfileImage != null) 'authorProfileImage': authorProfileImage,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isPrivate': isPrivate,
    };
  }
}
