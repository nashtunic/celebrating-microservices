class ApiConstants {
  static const String baseUrl = 'http://localhost:8080';

  // News Feed Types
  static const String postType = 'post';
  static const String eventType = 'event';
  static const String celebrationType = 'celebration';

  // Author Types
  static const String regularAuthor = 'regular';
  static const String celebrityAuthor = 'celebrity';

  // WebSocket Events
  static const String newsFeedUpdated = 'NEWS_FEED_UPDATED';
  static const String likeUpdated = 'LIKE_UPDATED';
  static const String commentAdded = 'COMMENT_ADDED';
}
