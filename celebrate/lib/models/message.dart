class Message {
  final int id;
  final String content;
  final String senderId;
  final String recipientId;
  final DateTime createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.recipientId,
    required this.createdAt,
    this.isRead = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'recipientId': recipientId,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}

class Chat {
  final String id;
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserProfileImage;
  final Message? lastMessage;
  final int unreadCount;

  Chat({
    required this.id,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserProfileImage,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      userId: json['userId'] as String,
      otherUserId: json['otherUserId'] as String,
      otherUserName: json['otherUserName'] as String,
      otherUserProfileImage: json['otherUserProfileImage'] as String?,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'otherUserId': otherUserId,
      'otherUserName': otherUserName,
      'otherUserProfileImage': otherUserProfileImage,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
    };
  }
}
