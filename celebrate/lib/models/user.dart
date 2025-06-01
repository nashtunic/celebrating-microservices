class User {
  final int id;
  final String username;
  final String displayName;
  final String? email;
  final String? profileImage;
  final String? location;
  final String? bio;
  final DateTime createdAt;
  final int followersCount;
  final int followingCount;
  final bool isFollowing;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    this.email,
    this.profileImage,
    this.location,
    this.bio,
    required this.createdAt,
    required this.followersCount,
    required this.followingCount,
    required this.isFollowing,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      followersCount: json['followersCount'] as int,
      followingCount: json['followingCount'] as int,
      isFollowing: json['isFollowing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'profileImage': profileImage,
      'location': location,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'isFollowing': isFollowing,
    };
  }
}

class UserPost {
  final int id;
  final String title;
  final String content;
  final String celebrationType;
  final List<String> mediaUrls;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  UserPost({
    required this.id,
    required this.title,
    required this.content,
    required this.celebrationType,
    required this.mediaUrls,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });

  factory UserPost.fromJson(Map<String, dynamic> json) {
    return UserPost(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      celebrationType: json['celebrationType'],
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'celebrationType': celebrationType,
      'mediaUrls': mediaUrls,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
