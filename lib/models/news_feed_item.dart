import 'package:json_annotation/json_annotation.dart';

part 'news_feed_item.g.dart';

@JsonSerializable()
class NewsFeedItem {
  final String id;
  final String title;
  final String content;
  final String type;
  final String authorId;
  final String authorName;
  final String authorType;
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
    required this.mediaUrls,
    this.metadata,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
  });

  factory NewsFeedItem.fromJson(Map<String, dynamic> json) =>
      _$NewsFeedItemFromJson(json);

  Map<String, dynamic> toJson() => _$NewsFeedItemToJson(this);
}
