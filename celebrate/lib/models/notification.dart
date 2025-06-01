class Notification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'like', 'comment', 'rating', etc.
  final String? targetId;
  final String? targetType;
  final bool isRead;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.targetId,
    this.targetType,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      targetId: json['targetId'],
      targetType: json['targetType'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'targetId': targetId,
      'targetType': targetType,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
