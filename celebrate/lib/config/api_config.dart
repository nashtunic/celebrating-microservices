import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

class ApiConfig {
  static const String serverIP = '197.254.53.252';
  static const int apiGatewayPort = 2323;

  // Base URLs
  static const String baseUrl = 'http://$serverIP:$apiGatewayPort';
  static const String wsBaseUrl = 'ws://$serverIP:$apiGatewayPort';

  // API Endpoints
  static const String auth = '/api/auth';
  static const String users = '/api/users';
  static const String posts = '/api/posts';
  static const String messages = '/api/messages';
  static const String notifications = '/api/notifications';
  static const String search = '/api/search';
  static const String awards = '/api/awards';
  static const String ratings = '/api/ratings';
  static const String newsFeed = '/api/news-feed';
  static const String moderation = '/api/moderation';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, Accept, Authorization',
      };

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refreshToken = '/api/auth/refresh';

  // User endpoints
  static const String userProfile = '/api/users/profile';
  static const String updateProfile = '/api/users/profile/update';
  static const String searchUsers = '/api/users/search';

  // Post endpoints
  static const String createPost = '/api/posts/create';
  static const String getFeed = '/api/posts/feed';
  static const String likePost = '/api/posts/like';
  static const String comment = '/api/posts/comment';

  // Messaging endpoints
  static const String getChats = '/api/messages/chats';
  static const String getChatMessages = '/api/messages/chat';
  static const String wsEndpoint = 'ws://$serverIP/ws/chat';

  // Notification endpoints
  static const String getNotifications = '/api/notifications';
  static const String wsNotificationsEndpoint =
      'ws://$serverIP/ws/notifications';

  // News Feed endpoints
  static const String getNewsFeed = '/api/news-feed';
  static const String getTrending = '/api/news-feed/trending';

  // Moderation endpoints
  static const String reportContent = '/api/moderation/report';
  static const String getReports = '/api/moderation/reports';
}
