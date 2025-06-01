class Rating {
  final String id;
  final String userId;
  final String targetId;
  final String targetType; // 'post', 'user', etc.
  final int value; // 1-5
  final String? comment;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.userId,
    required this.targetId,
    required this.targetType,
    required this.value,
    this.comment,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      userId: json['userId'],
      targetId: json['targetId'],
      targetType: json['targetType'],
      value: json['value'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetId': targetId,
      'targetType': targetType,
      'value': value,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
