import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;

class ApiConfig {
  static const String _localBaseUrl = 'http://localhost:8080';
  static const String _prodBaseUrl =
      'http://localhost:8080'; // Update with your production URL

  static String get baseUrl {
    if (kReleaseMode) {
      return _prodBaseUrl;
    }
    return _localBaseUrl;
  }

  // API Endpoints
  static const String auth = '/api/auth';
  static const String users = '/api/users';
  static const String posts = '/api/posts';
  static const String messages = '/api/messages';
  static const String notifications = '/api/notifications';
  static const String search = '/api/search';
  static const String awards = '/api/awards';
  static const String ratings = '/api/ratings';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';

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
  static const String wsEndpoint = 'ws://localhost:8080/ws/chat';
}
